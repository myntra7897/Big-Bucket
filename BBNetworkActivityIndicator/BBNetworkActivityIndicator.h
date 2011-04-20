//
//  BBNetworkActivityIndicator.h
//
//  Created by Matt Comi on 30/03/11.
//  Copyright 2011 Big Bucket Software. All rights reserved.
//

#import <Foundation/Foundation.h>

// Manages the visibility of the UIApplication's networkActivityIndicator.
@interface BBNetworkActivityIndicator : NSObject
{
    NSUInteger m_numberOfNetworkActivities;
}

+(BBNetworkActivityIndicator*)sharedIndicator;

// Pushes a network activity. If it was the first activity, the networkActivityIndicator will become visible.
-(void)pushNetworkActivity;

// Pops a network activity. If it was the last activity, the networkActivityIndicator will be come hidden.
-(void)popNetworkActivity;

@end