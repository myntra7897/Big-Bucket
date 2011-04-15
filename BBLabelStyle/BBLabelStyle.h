//
//  BBLabelStyle.h
//
//  Created by Matt Comi on 14/04/11.
//  Copyright 2011 Big Bucket Software. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const BBLabelStyleBackgroundColorKey;
extern NSString* const BBLabelStyleFontKey;
extern NSString* const BBLabelStyleTextColorKey;
extern NSString* const BBLabelStyleTextAlignmentKey;
extern NSString* const BBLabelStyleLineBreakModeKey;
extern NSString* const BBLabelStyleEnabledKey;
extern NSString* const BBLabelStyleAdjustsFontSizeToFitWidthKey;
extern NSString* const BBLabelStyleBaselineAdjustmentKey;
extern NSString* const BBLabelStyleMinimumFontSizeKey;
extern NSString* const BBLabelStyleNumberOfLinesKey;
extern NSString* const BBLabelStyleHighlightedTextColorKey;
extern NSString* const BBLabelStyleHighlightedKey;
extern NSString* const BBLabelStyleShadowColorKey;
extern NSString* const BBLabelStyleShadowOffsetKey;

// Encapsulates style properties of a UILabel. Only properties defined by a BBLabelStyle are applied to a UILabel.
// To remove a property from the style, you may use removeProperty or, for object types, specify a value of nil.
@interface BBLabelStyle : NSObject
{
@private
    NSMutableDictionary* m_properties;
}

+(BBLabelStyle*)labelStyle;

// Removes a property from the style.
-(void)removeProperty:(NSString*)property;

@property(nonatomic,readonly) NSDictionary* properties;
@property(nonatomic,retain) UIColor* backgroundColor;
@property(nonatomic,retain) UIFont* font;
@property(nonatomic,retain) UIColor* textColor;
@property(nonatomic,assign) UITextAlignment textAlignment;
@property(nonatomic,assign) UILineBreakMode lineBreakMode;
@property(nonatomic,assign,getter=isEnabled) BOOL enabled;
@property(nonatomic,assign) BOOL adjustsFontSizeToFitWidth;
@property(nonatomic,assign) UIBaselineAdjustment baselineAdjustment;
@property(nonatomic,assign) CGFloat minimumFontSize;
@property(nonatomic,assign) NSInteger numberOfLines;
@property(nonatomic,retain) UIColor* highlightedTextColor;
@property(nonatomic,assign,getter=isHighlighted) BOOL highlighted;
@property(nonatomic,retain) UIColor* shadowColor;
@property(nonatomic,assign) CGSize shadowOffset;

@end

@interface UILabel (BigBucket)

-(id)initWithLabelStyle:(BBLabelStyle*)style;

-(id)initWithLabelStyles:(NSArray*)styles;

@end