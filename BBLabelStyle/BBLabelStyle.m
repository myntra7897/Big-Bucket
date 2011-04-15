//
//  BBLabelStyle.m
//
//  Created by Matt Comi on 14/04/11.
//  Copyright 2011 Big Bucket Software. All rights reserved.
//

#import "BBLabelStyle.h"

NSString* const BBLabelStyleBackgroundColorKey = @"BBBackgroundColorKey";
NSString* const BBLabelStyleFontKey = @"BBFontKey";
NSString* const BBLabelStyleTextColorKey = @"BBTextColorKey";
NSString* const BBLabelStyleTextAlignmentKey = @"BBTextAlignmentKey";
NSString* const BBLabelStyleLineBreakModeKey = @"BBLineBreakModeKey";
NSString* const BBLabelStyleEnabledKey = @"BBEnabledKey";
NSString* const BBLabelStyleAdjustsFontSizeToFitWidthKey = @"BBAdjustsFontSizeToFitWidthKey";
NSString* const BBLabelStyleBaselineAdjustmentKey = @"BBBaseLineAdjustmentKey";
NSString* const BBLabelStyleMinimumFontSizeKey = @"BBMinimumFontSizeKey";
NSString* const BBLabelStyleNumberOfLinesKey = @"BBNumberOfLinesKey";
NSString* const BBLabelStyleHighlightedTextColorKey = @"BBHighlightedTextColorKey";
NSString* const BBLabelStyleHighlightedKey = @"BBHighlightedKey";
NSString* const BBLabelStyleShadowColorKey = @"BBShadowColorKey";
NSString* const BBLabelStyleShadowOffsetKey = @"BBShadowOffsetKey";

@implementation BBLabelStyle

@synthesize properties=m_properties;

+(BBLabelStyle*)labelStyle
{
    return [[[BBLabelStyle alloc] init] autorelease];
}

-(id)init
{
    if (![super init])
    {
        return nil;
    }
    
    m_properties = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(void)dealloc
{
    [m_properties release];
    
    [super dealloc];
}

-(NSDictionary*)properties
{
    return m_properties;
}

-(void)removeProperty:(NSString*)property
{
    [m_properties removeObjectForKey:property];
}

-(UIColor*)backgroundColor
{
    return [m_properties objectForKey:BBLabelStyleBackgroundColorKey];
}

-(void)setBackgroundColor:(UIColor*)backgroundColor
{
    [m_properties setObject:backgroundColor forKey:BBLabelStyleBackgroundColorKey];
}

-(UIFont*)font
{
    return [m_properties objectForKey:BBLabelStyleFontKey];
}

-(void)setFont:(UIFont*)font
{
    if (!font)
    {
        [m_properties removeObjectForKey:font];
    }
    else
    {
        [m_properties setObject:font forKey:BBLabelStyleFontKey];
    }
}

-(UIColor*)textColor
{
    return [m_properties objectForKey:BBLabelStyleTextColorKey];
}

-(void)setTextColor:(UIColor*)textColor
{
    [m_properties setObject:textColor forKey:BBLabelStyleTextColorKey];
}

-(UITextAlignment)textAlignment
{
    return [[m_properties objectForKey:BBLabelStyleTextAlignmentKey] intValue];
}

-(void)setTextAlignment:(UITextAlignment)textAlignment
{
    [m_properties setObject:[NSNumber numberWithInt:textAlignment] forKey:BBLabelStyleTextAlignmentKey];
}

-(UILineBreakMode)lineBreakMode
{
    return [[m_properties objectForKey:BBLabelStyleLineBreakModeKey] intValue];
}

-(void)setLineBreakMode:(UILineBreakMode)lineBreakMode
{
    [m_properties setObject:[NSNumber numberWithInt:lineBreakMode] forKey:BBLabelStyleLineBreakModeKey];
}

-(BOOL)isEnabled
{
    return [[m_properties objectForKey:BBLabelStyleEnabledKey] boolValue];
}

-(void)setEnabled:(BOOL)enabled
{
    [m_properties setObject:[NSNumber numberWithBool:enabled] forKey:BBLabelStyleEnabledKey];
}

-(BOOL)adjustsFontSizeToFitWidth
{
    return [[m_properties objectForKey:BBLabelStyleAdjustsFontSizeToFitWidthKey] boolValue];
}

-(void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth
{
    [m_properties setObject:[NSNumber numberWithBool:adjustsFontSizeToFitWidth] forKey:BBLabelStyleAdjustsFontSizeToFitWidthKey];
}

-(UIBaselineAdjustment)baselineAdjustment
{
    return [[m_properties objectForKey:BBLabelStyleAdjustsFontSizeToFitWidthKey] boolValue];
}

-(void)setBaselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
    [m_properties setObject:[NSNumber numberWithInt:baselineAdjustment] forKey:BBLabelStyleBaselineAdjustmentKey];
}

-(CGFloat)minimumFontSize
{
    return [[m_properties objectForKey:BBLabelStyleMinimumFontSizeKey] floatValue];
}

-(void)setMinimumFontSize:(CGFloat)minimumFontSize
{
    [m_properties setObject:[NSNumber numberWithFloat:minimumFontSize] forKey:BBLabelStyleMinimumFontSizeKey];
}

-(NSInteger)numberOfLines
{
    return [[m_properties objectForKey:BBLabelStyleNumberOfLinesKey] integerValue];
}

-(void)setNumberOfLines:(NSInteger)numberOfLines
{
    [m_properties setObject:[NSNumber numberWithInteger:numberOfLines] forKey:BBLabelStyleNumberOfLinesKey];
}

-(UIColor*)highlightedTextColor
{
    return [m_properties objectForKey:BBLabelStyleHighlightedTextColorKey];
}

-(void)setHighlightedTextColor:(UIColor*)highlightedTextColor
{
    if (!highlightedTextColor)
    {
        [m_properties removeObjectForKey:BBLabelStyleHighlightedTextColorKey];
    }
    else
    {
        [m_properties setObject:highlightedTextColor forKey:BBLabelStyleHighlightedTextColorKey];
    }
}

-(BOOL)isHighlighted
{
    return [[m_properties objectForKey:BBLabelStyleHighlightedKey] boolValue];
}

-(void)setHighlighted:(BOOL)highlighted
{
    [m_properties setObject:[NSNumber numberWithBool:highlighted] forKey:BBLabelStyleHighlightedKey];
}

-(UIColor*)shadowColor
{
    return [m_properties objectForKey:BBLabelStyleShadowColorKey];
}

-(void)setShadowColor:(UIColor*)shadowColor
{
    if (!shadowColor)
    {
        [m_properties removeObjectForKey:BBLabelStyleShadowColorKey];
    }
    else
    {
        [m_properties setObject:shadowColor forKey:BBLabelStyleShadowColorKey];
    }
}

-(CGSize)shadowOffset
{
    return [[m_properties objectForKey:BBLabelStyleShadowOffsetKey] CGSizeValue];
}

-(void)setShadowOffset:(CGSize)shadowOffset
{
    [m_properties setObject:[NSValue valueWithCGSize:shadowOffset] forKey:BBLabelStyleShadowOffsetKey];
}

@end

@implementation UILabel (BigBucket)

-(id)initWithLabelStyle:(BBLabelStyle*)style
{
    return [self initWithLabelStyles:[NSArray arrayWithObject:style]];
}

-(id)initWithLabelStyles:(NSArray*)styles
{
    if (![super init])
    {
        return nil;
    }
    
    for (BBLabelStyle* style in styles)
    {
        [style.properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
         {
             if ([key isEqual:BBLabelStyleBackgroundColorKey])
             {
                 self.backgroundColor = obj;
             }
             if ([key isEqual:BBLabelStyleFontKey])
             {
                 self.font = obj;
             }
             else if ([key isEqual:BBLabelStyleTextColorKey])
             {
                 self.textColor = obj;
             }
             else if ([key isEqual:BBLabelStyleTextAlignmentKey])
             {
                 self.textAlignment = [obj intValue];
             }
             else if ([key isEqual:BBLabelStyleLineBreakModeKey])
             {
                 self.lineBreakMode = [obj intValue];
             }
             else if ([key isEqual:BBLabelStyleEnabledKey])
             {
                 self.enabled = [obj boolValue];
             }
             else if ([key isEqual:BBLabelStyleAdjustsFontSizeToFitWidthKey])
             {
                 self.adjustsFontSizeToFitWidth = [obj boolValue];
             }
             else if ([key isEqual:BBLabelStyleBaselineAdjustmentKey])
             {
                 self.baselineAdjustment = [obj intValue];
             }
             else if ([key isEqual:BBLabelStyleMinimumFontSizeKey])
             {
                 self.minimumFontSize = [obj floatValue];
             }
             else if ([key isEqual:BBLabelStyleNumberOfLinesKey])
             {
                 self.numberOfLines = [obj integerValue];
             }
             else if ([key isEqual:BBLabelStyleHighlightedTextColorKey])
             {
                 self.highlightedTextColor = obj;
             }
             else if ([key isEqual:BBLabelStyleHighlightedKey])
             {
                 self.highlighted = [obj boolValue];
             }
             else if ([key isEqual:BBLabelStyleShadowColorKey])
             {
                 self.shadowColor = obj;
             }
             else if ([key isEqual:BBLabelStyleShadowOffsetKey])
             {
                 self.shadowOffset = [obj CGSizeValue];
             }
         }];
    }
    
    return self;
}

@end