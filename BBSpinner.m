//
//  BBSpinner.m
//  TV Forecast for iPad
//
//  Created by Matt Comi on 10/04/11.
//  Copyright 2011 Big Bucket Software. All rights reserved.
//

#import "BBSpinner.h"
#import "UIImage+BBAdditions.h"

#define kDividerRect CGRectMake(46, 0, 1, 27)
#define kMinusNormalRect CGRectMake(0, 27, 49, 27)
#define kMinusDisabledRect CGRectMake(0, 0, 49, 27)
#define kMinusHighlightedRect CGRectMake(0, 54, 49, 27)
#define kPlusNormalRect CGRectMake(0, 189, 49, 27)
#define kPlusDisabledRect CGRectMake(0, 162, 49, 27)
#define kPlusHighlightedRect CGRectMake(0, 135, 49, 27)

@interface BBSpinner ()
-(void)updateButtonState;
@end

@implementation BBSpinner

@synthesize minimum=m_minimum;
@synthesize maximum=m_maximum;
@synthesize value=m_value;
@synthesize delegate=m_delegate;

-(id)initWithFrame:(CGRect)frame
{
    if (![super initWithFrame:frame])
    {
        return nil;
    }
    
    UIImage* image = [UIImage imageNamed:@"BBSpinner.png"];
    
    m_minusButton = [[[UIButton alloc] init] autorelease];
    m_plusButton = [[[UIButton alloc] init] autorelease];
    
    [m_minusButton setImage:[UIImage imageWithImage:image inRect:kMinusNormalRect] forState:UIControlStateNormal];
    [m_minusButton setImage:[UIImage imageWithImage:image inRect:kMinusDisabledRect] forState:UIControlStateDisabled];
    [m_minusButton setImage:[UIImage imageWithImage:image inRect:kMinusHighlightedRect] forState:UIControlStateHighlighted];
    
    [m_plusButton setImage:[UIImage imageWithImage:image inRect:kPlusNormalRect] forState:UIControlStateNormal];
    [m_plusButton setImage:[UIImage imageWithImage:image inRect:kPlusDisabledRect] forState:UIControlStateDisabled];
    [m_plusButton setImage:[UIImage imageWithImage:image inRect:kPlusHighlightedRect] forState:UIControlStateHighlighted];
    
    for (UIButton* button in [NSArray arrayWithObjects:m_minusButton, m_plusButton, nil])
    {    
        [button addTarget:self 
                   action:@selector(buttonDidTouchUpInside:) 
         forControlEvents:UIControlEventTouchUpInside];
        
        [button addTarget:self 
                   action:@selector(buttonDidTouchDown:) 
         forControlEvents:UIControlEventTouchDown];        
    }
    
    UIImageView* divider = [[UIImageView alloc] initWithImage:[UIImage imageWithImage:image inRect:kDividerRect]];
    
    divider.frame = CGRectMake(46, 0, divider.image.size.width, divider.image.size.height);
    
    [self addSubview:[divider autorelease]];
    
    [self addSubview:m_minusButton];
    [self addSubview:m_plusButton];
    
    m_minusButton.frame = CGRectMake(0, 0, 49, 27);
    m_plusButton.frame = CGRectMake(46, 0, 49, 27);

    self.frame = CGRectMake(0, 0, 94, 27);
    self.opaque = NO;
    
    [self setRangeMinimum:0 length:10];
    
    return self;
}

-(void)dealloc
{    
    [super dealloc];
}

-(void)setRangeMinimum:(NSInteger)minimum length:(NSInteger)length
{
    m_minimum = minimum;
    m_maximum = minimum + length;
    
    // forces the value back into the new range
    self.value = self.value;
}

-(void)setValue:(NSInteger)value
{   
    value = MAX(m_minimum, value);
    value = MIN(m_maximum, value);
        
    m_value = value;
    
    [self updateButtonState];
}

#pragma mark - Private

-(void)updateButtonState
{
    m_minusButton.enabled = self.value > m_minimum;
    m_plusButton.enabled = self.value < m_maximum;
}

-(void)buttonDidTouchDown:(UIButton*)button
{
    // the plus and minus button highlighted button images overlap eachother so bring the highlighted button to front
    [self bringSubviewToFront:button];
}

-(void)buttonDidTouchUpInside:(UIButton*)button
{
    if (button == m_minusButton)
    {
        --self.value;
    }
    else if (button == m_plusButton)
    {
        ++self.value;
    }
    
    [self updateButtonState];
    
    [self.delegate spinnerValueDidChange:self];
}

@end