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
    BOOL m_isClosingDocument;
}

// Returns YES if iCloud storage is available.
+(BOOL)isSupported;

// Creates and initializes a BBCloudController that controls a document of the specified type, with the specified
// filename.
-(id)initWithDocumentClass:(Class)documentClass filename:(NSString*)filename;

// Asynchronously attempts to locate the document in the ubiquitous container. If the document cannot be found, one
// will be created in the cache directory and then moved to the ubiquitous container. Returns NO if iCloud storage
// is unavailable or if the controller is currently in the process of opening, creating or closing the document. 
// Returns YES otherwise.
-(BOOL)openOrCreateDocument;

-(void)closeDocument;

// Returns YES if the document is open.
-(BOOL)isDocumentOpen;

// Returns YES if the document is normal (documentState is UIDocumentStateNormal).
-(BOOL)isDocumentNormal;

// Returns YES if the controller is currently in the process of opening, creating or closing the document.
-(BOOL)isBusy;

@property(nonatomic,readonly) UIDocument* document;

@property(nonatomic,assign) id<BBCloudControllerDelegate> delegate;

@end

@protocol BBCloudControllerDelegate

// Called when the document is opened.
-(void)cloudControllerDidOpenDocument:(BBCloudController*)controller success:(BOOL)success;

// Called when the document is closed.
-(void)cloudControllerDidCloseDocument:(BBCloudController*)controller success:(BOOL)success;

// Called when the document encounters a saving error.
-(void)cloudControllerDidFailToSaveDocument:(BBCloudController*)controller;

@end