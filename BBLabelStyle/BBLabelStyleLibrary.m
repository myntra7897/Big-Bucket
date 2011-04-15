//
//  BBLabelStyleLibrary.m
//  TV Forecast for iPad
//
//  Created by Matt Comi on 15/04/11.
//  Copyright 2011 Big Bucket Software. All rights reserved.
//

#import "BBLabelStyleLibrary.h"

#import "BBLabelStyle.h"

@interface BBLabelStyleLibrary ()
-(id)initSharedLibrary;
@end

@implementation BBLabelStyleLibrary

+(BBLabelStyleLibrary*)sharedLibrary
{
    static id sharedInstance = nil;
    
    static dispatch_once_t once = 0;
    
    dispatch_once(&once,
    ^{
        sharedInstance = [[self alloc] initSharedLibrary];
    });
    
    return sharedInstance;
}

-(id)init
{
    NSAssert1(NO, @"There can only be one %@ instance.", [self class]);
    return nil;
}

-(id)initSharedLibrary
{
    if (![super init])
    {
        return nil;
    }
    
    m_labelStyles = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(void)release
{    
}

-(void)dealloc
{
    [m_labelStyles release];
    [super dealloc];
}

-(BBLabelStyle*)labelStyleWithName:(NSString*)name
{
    return [m_labelStyles objectForKey:name];
}

-(void)setLabelStyle:(BBLabelStyle*)labelStyle forName:(NSString*)name
{
    [m_labelStyles setObject:labelStyle forKey:name];
}

@end
