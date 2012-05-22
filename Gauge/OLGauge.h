//
//  OLGauge.h
//  orangeEtMoi
//
//  Created by Mathieu Mouilliere on 01/03/11.
//  Copyright Orange. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define defaultBgColor                UIColorFromRGB(0xF4F3F2)
#define defaultFillColor              UIColorFromRGB(0xFF9900)
#define defaultAnimationDuration      1.75f

typedef enum {
  leftToRight,     
  rightToLeft,
  bottomToTop,
  topToBottom
} FillDirection;

@interface OLGauge : UIView {
  
  CGFloat fillDuration;
  UIColor *fillColor;
  UIColor *gaugeBackgroundColor;
  UIImage *shadowImage;
  BOOL innerShadow;
	BOOL outerShadow;
  int percentFilled;
  
@private
  CGRect gaugeFrame;
  CGRect fillFrame;
  UIImageView *shadowView;
  UIView *fillView;
  FillDirection fillDirectionForGauge;
  BOOL drawnOnce;
  BOOL animated;
}

@property (assign) CGFloat fillDuration;
@property FillDirection fillDirectionForGauge;
@property (retain, nonatomic) UIImage *shadowImage;
@property (retain, nonatomic) UIColor *fillColor;
@property (retain, nonatomic) UIColor *gaugeBackgroundColor;
@property (nonatomic) BOOL innerShadow;
@property (nonatomic) BOOL outerShadow;
@property (nonatomic) int percentFilled;

@property (retain, nonatomic, getter=getFillView) UIView *fillView;



- (void)fillGaugeToValue: (int)percent  andFillDirection:(FillDirection)theDirection animated:(BOOL) isAnimated;
- (void)refillGaugeToValue: (int)percent andFillDirection:(FillDirection)theDirection animated:(BOOL) isAnimated;

@end