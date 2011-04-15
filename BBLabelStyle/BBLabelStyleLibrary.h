//
//  BBLabelStyleLibrary.h
//  TV Forecast for iPad
//
//  Created by Matt Comi on 15/04/11.
//  Copyright 2011 Big Bucket Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBLabelStyle.h"

@interface BBLabelStyleLibrary : NSObject
{
@private
    NSMutableDictionary* m_labelStyles;
}

+(BBLabelStyleLibrary*)sharedLibrary;

-(BBLabelStyle*)labelStyleWithName:(NSString*)name;

-(void)setLabelStyle:(BBLabelStyle*)labelStyle forName:(NSString*)name;

@end