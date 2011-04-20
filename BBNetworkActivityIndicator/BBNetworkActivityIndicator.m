//
//  BBNetworkActivityIndicator.m
//
//  Created by Matt Comi on 30/03/11.
//  Copyright 2011 Big Bucket Software. All rights reserved.
//

#import "BBNetworkActivityIndicator.h"

@interface BBNetworkActivityIndicator ()
-(id)initSharedIndicator;
@end

@implementation BBNetworkActivityIndicator

+(BBNetworkActivityIndicator*)sharedIndicator
{
    static id sharedInstance = nil;
    
    static dispatch_once_t once = 0;
    
    dispatch_once(&once,
    ^{
        sharedInstance = [[self alloc] initSharedIndicator];
    });
    
    return sharedInstance;
}

-(id)init
{
    NSAssert1(NO, @"There can only be one %@ instance.", [self class]);
    
    return nil;
}

-(id)initSharedIndicator
{
    if (![super init])
    {
        return nil;
    }
    
    return self;
}

-(void)release
{
}

-(void)pushNetworkActivity
{
    NSAssert([NSThread isMainThread], @"Must be called from the main thread");
    
    if (m_numberOfNetworkActivities == 0)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    ++m_numberOfNetworkActivities;
}

-(void)popNetworkActivity
{
    NSAssert([NSThread isMainThread], @"Must be called from the main thread");
    
    --m_numberOfNetworkActivities;
    
    if (m_numberOfNetworkActivities == 0)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

@end