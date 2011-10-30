//
//  BBCloudController.h
//
//  Created by Matt Comi on 28/10/11.
//  Copyright (c) 2011 Big Bucket Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBCloudControllerDelegate;

// A class that encapsulates a single UIDocument. Automatically resolves conflicts using the newest available version.
@interface BBCloudController : NSObject
{
    Class m_documentClass;
    NSMetadataQuery* m_query;
    UIDocument* m_document;
    NSString* m_filename;
    id m_delegate;
    BOOL m_isOpeningOrCreatingDocument;
}

// Returns YES if iCloud storage is available.
+(BOOL)isSupported;

// Creates and initializes a BBCloudController that controls a document of the specified type, with the specified
// filename.
-(id)initWithDocumentClass:(Class)documentClass filename:(NSString*)filename;

// Asynchronously attempts to locate the document in the ubiquitous container. If the document cannot be found, one
// will be created in the cache directory and then moved to the ubiquitous container. Returns NO if iCloud storage
// is unavailable or if an openOrCreateDocument operation is already in progress. Returns YES otherwise.
-(BOOL)openOrCreateDocument;

// Returns YES if the document is open.
-(BOOL)isDocumentOpen;

// Returns YES if the document is normal (documentState is UIDocumentStateNormal).
-(BOOL)isDocumentNormal;

// Returns YES if the controller is currently in the process of opening or creating the document.
-(BOOL)isOpeningOrCreatingDocument;

@property(nonatomic,readonly) UIDocument* document;

@property(nonatomic,assign) id<BBCloudControllerDelegate> delegate;

@end

@protocol BBCloudControllerDelegate

// Called when the document is successfully opened.
-(void)cloudController:(BBCloudController*)controller documentDidOpen:(UIDocument*)document;

// Called if the document could not be successfully opened.
-(void)cloudController:(BBCloudController*)controller documentFailedToOpen:(UIDocument*)document;

// Called when the document encounters a saving error.
-(void)cloudController:(BBCloudController*)controller documentFailedToSave:(UIDocument*)document;

@end