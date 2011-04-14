//
//  BBSpinner.h
//
//  Created by Matt Comi on 10/04/11.
//  Copyright 2011 Big Bucket Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBSpinnerDelegate;

// A spinner control.
@interface BBSpinner : UIView
{
    UIButton* m_minusButton;
    UIButton* m_plusButton;    
    NSInteger m_minimum;
    NSInteger m_maximum;
    NSInteger m_value;
    
    id<BBSpinnerDelegate> m_delegate;
}

// The value of the spinner.
@property(nonatomic,assign) NSInteger value;

// The minimum value of the spinner.
@property(nonatomic,readonly) NSInteger minimum;

// The maximum value of the spinner.
@property(nonatomic,readonly) NSInteger maximum;

// The delegate.
@property(nonatomic,assign) id<BBSpinnerDelegate> delegate;

// The range of the spinner. The current value of the spinner will be bound to this range.
-(void)setRangeMinimum:(NSInteger)minimum length:(NSInteger)length;

@end

@protocol BBSpinnerDelegate

// Tells the delegate that the spinner value changed. The delegate method will not be called if the value is changed
// programmatically.
-(void)spinnerValueDidChange:(BBSpinner*)spinner;

@end