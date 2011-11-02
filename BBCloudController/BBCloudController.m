//
//  BBCloudController.m
//
//  Created by Matt Comi on 28/10/11.
//  Copyright (c) 2011 Big Bucket Software. All rights reserved.
//

#import "BBCloudController.h"

@interface BBCloudController ()
+(NSURL*)ubiquitousContainerURL;
-(void)resolveConflictWithConflictVersion:(NSFileVersion*)fileVersion;
-(void)resolveConflictWithCurrentVersion;
@end

@implementation BBCloudController

@synthesize delegate=m_delegate;
@synthesize document=m_document;

+(NSURL*)ubiquitousContainerURL
{
    if (![[NSFileManager defaultManager] respondsToSelector:@selector(URLForUbiquityContainerIdentifier:)])
    {
        return nil;
    }
    
    return [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
}

-(id)initWithDocumentClass:(Class)documentClass filename:(NSString*)filename;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    NSAssert([documentClass isSubclassOfClass:[UIDocument class]], @"Expected a subclass of UIDocument");
    
    m_documentClass = documentClass;
        
    m_filename = [filename copy];
            
    return self;
}

-(void)dealloc
{
    [m_filename release];
    
    [super dealloc];
}

+(BOOL)isSupported
{
    return [BBCloudController ubiquitousContainerURL] != nil;
}

-(BOOL)openOrCreateDocument
{
    if ([self isBusy])
    {
        return NO;
    }
    
    if ([BBCloudController ubiquitousContainerURL] == nil)
    {
        return NO;
    }
        
    m_query = [[NSClassFromString(@"NSMetadataQuery") alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(queryDidFinish:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification 
                                               object:m_query];
    
    [m_query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDataScope]];
        
    [m_query setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", NSMetadataItemFSNameKey, m_filename]];
        
    [m_query startQuery];
    
    m_isOpeningOrCreatingDocument = YES;    
    
    return YES;
}

-(void)closeDocument
{
    if ([self isDocumentOpen])
    {
        m_isClosingDocument = YES;
        
        [m_document closeWithCompletionHandler:^(BOOL success) {
            m_isClosingDocument = NO;
            [self.delegate cloudControllerDidCloseDocument:self success:success];
        }];
    }
}

-(BOOL)isDocumentOpen
{
    return m_document && (m_document.documentState & UIDocumentStateClosed) == 0;
}

-(BOOL)isDocumentNormal
{
    return m_document && (m_document.documentState == UIDocumentStateNormal);
}

-(BOOL)isBusy
{
    return m_isOpeningOrCreatingDocument || m_isClosingDocument;
}

#pragma mark - Private

-(void)queryDidFinish:(NSNotification*)notification
{
    NSMetadataQuery* query = (NSMetadataQuery*)[notification object];
    
    NSAssert(query == m_query, @"Unexpected query");
    
    NSURL* url = nil;
    
    BOOL isUbiquitous = NO;
    
    if (query && [query resultCount] >= 1)
    {
        isUbiquitous = YES;
        url = [[query resultAtIndex:0] valueForAttribute:NSMetadataItemURLKey];
    } 
    else
    {
        NSString* cacheDirectory = 
            [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        url = [NSURL fileURLWithPath:[cacheDirectory stringByAppendingPathComponent:m_filename]];
    }
    
    [m_query release];
    
    m_query = nil;
    
    m_document = [[m_documentClass alloc] initWithFileURL:url];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(documentStateChanged)
                                                 name:UIDocumentStateChangedNotification 
                                               object:m_document];
    
    if (isUbiquitous)
    {
        // already ubiquitous, just open it.
        [m_document openWithCompletionHandler:^(BOOL success)
        {
            m_isOpeningOrCreatingDocument = NO;            
            [self.delegate cloudControllerDidOpenDocument:self success:success];
        }];    
    }
    else
    {
        // not ubiquitous, so save it locally first.
        [m_document saveToURL:url
             forSaveOperation:UIDocumentSaveForCreating 
            completionHandler:^(BOOL success) {
            // Assert on the ability to save a file locally; failure to do so indicates an entitlements error.
            NSAssert1(success, @"Error creating file: %@", url);

            NSURL* ubiquitousUrl = 
                [[BBCloudController ubiquitousContainerURL] URLByAppendingPathComponent:m_filename];
                    
            // asynchronously move the document to the ubiquity container.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{                          
                NSError* error = nil;
                [[NSFileManager defaultManager] setUbiquitous:YES 
                                                    itemAtURL:url
                                               destinationURL:ubiquitousUrl
                                                        error:&error];
                    
                m_isOpeningOrCreatingDocument = NO;                    
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.delegate cloudControllerDidOpenDocument:self success:error == nil];
                });
            });
        }];
    }
}

-(void)documentStateChanged
{
    UIDocumentState state = m_document.documentState;
    
    // if document is in conflict and editing is enabled then resolve the conflict using the newest version of the
    // document.
    if ((state & UIDocumentStateInConflict) && ((state & UIDocumentStateEditingDisabled) == 0))
    {
        NSArray* conflictedVersions = [NSFileVersion unresolvedConflictVersionsOfItemAtURL:m_document.fileURL];
        
        NSFileVersion* currentVersion = [NSFileVersion currentVersionOfItemAtURL:m_document.fileURL];
        
        NSFileVersion* newestVersion = currentVersion;
        
        if (conflictedVersions)
        {
            for (NSFileVersion* version in conflictedVersions)
            {
                if ([[version modificationDate] compare:[newestVersion modificationDate]] == NSOrderedDescending)
                {
                    newestVersion = version;
                }
            }
            
            if (newestVersion != currentVersion)
            {
                [self resolveConflictWithConflictVersion:newestVersion];
            }
            else
            {
                [self resolveConflictWithCurrentVersion];
            }
        }
    }
    else if ((state & UIDocumentStateSavingError) && ((state & UIDocumentStateEditingDisabled) == 0))
    {
        [self.delegate cloudControllerDidFailToSaveDocument:self];
    }
}

-(void)resolveConflictWithConflictVersion:(NSFileVersion*)fileVersion
{
    [fileVersion replaceItemAtURL:m_document.fileURL options:0 error:nil];
    
    NSArray* conflictVersions = [NSFileVersion unresolvedConflictVersionsOfItemAtURL:m_document.fileURL];
    
    for (NSFileVersion* fileVersion in conflictVersions)
    {
        fileVersion.resolved = YES;
    }
    
    [NSFileVersion removeOtherVersionsOfItemAtURL:m_document.fileURL error:nil];
    
    [m_document revertToContentsOfURL:m_document.fileURL completionHandler:^(BOOL success) {
        [m_document updateChangeCount:UIDocumentChangeDone];
    }];
}

-(void)resolveConflictWithCurrentVersion
{        
    NSArray* conflictVersions = [NSFileVersion unresolvedConflictVersionsOfItemAtURL:m_document.fileURL];
    
    for (NSFileVersion* fileVersion in conflictVersions)
    {
        fileVersion.resolved = YES;
    }
    
    [NSFileVersion removeOtherVersionsOfItemAtURL:m_document.fileURL error:nil];    
}

@end