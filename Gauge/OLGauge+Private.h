//
//  Gauge+Private.h
//  OrangeEtMoi
//
//  Created by Mathieu Mouilliere on 02/03/11.
//  Copyright 2011 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "OLGauge.h"

@interface OLGauge (Private)

- (void)setPercentFilled:(int)intValue;

- (void)addFillView;
- (void)addAllShadowViewIfNeeded;
- (CGRect)getFillFrame;
- (float)getFillHeight;
- (float)getFillWidth;
- (void)fillGauge;
- (void)redrawWithNewFrame:(CGRect)newFrame;
- (void)setInnerShadow:(BOOL)shadow;



- (void)makeGradientOnView:(UIView *)view;

@end
