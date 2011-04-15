//
//  UIImage+BBAdditions.m
//
//  Created by Matt Comi on 14/04/11.
//  Copyright 2011 Big Bucket Software. All rights reserved.
//

#import "UIImage+BBAdditions.h"

@implementation UIImage (BigBucket)

+(UIImage*)imageWithImage:(UIImage*)image inRect:(CGRect)rect
{
    CGImageRef cgImage = [image CGImage];
    
    CGImageRef cgImageInRect = CGImageCreateWithImageInRect(cgImage, rect);
    
    UIImage* imageInRect = [UIImage imageWithCGImage:cgImageInRect];
    
    CGImageRelease(cgImageInRect);
    
    return imageInRect;
}

@end
