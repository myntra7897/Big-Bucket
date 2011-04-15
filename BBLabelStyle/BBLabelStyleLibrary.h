//
//  BBLabelStyleLibrary.h
//
//  Created by Matt Comi on 15/04/11.
//  Copyright 2011 Big Bucket Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBLabelStyle.h"

// A shared library of BBLabelStyles.
@interface BBLabelStyleLibrary : NSObject
{
@private
    NSMutableDictionary* m_labelStyles;
}

+(BBLabelStyleLibrary*)sharedLibrary;

-(BBLabelStyle*)labelStyleWithName:(NSString*)name;

-(void)setLabelStyle:(BBLabelStyle*)labelStyle forName:(NSString*)name;

@end