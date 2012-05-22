//
//  Gauge.m
//  orangeEtMoi
//
//  Created by Mathieu Mouilliere on 01/03/11.
//  Copyright 2011 Orange. All rights reserved.
//


#import "OLGauge.h"
#import "OLGauge+Private.h"


@implementation OLGauge

@synthesize fillDuration;
@synthesize shadowImage;
@synthesize fillColor, gaugeBackgroundColor;
@synthesize fillDirectionForGauge;
@synthesize innerShadow, outerShadow;
@synthesize percentFilled;
@synthesize fillView;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    //set the default values of the gauge
    self.backgroundColor = defaultBgColor;
    gaugeFrame = frame;
    animated = YES;
    drawnOnce = NO;
    innerShadow = NO;
		outerShadow = NO;
    fillDuration=defaultAnimationDuration;
		fillColor = [defaultFillColor retain];
		percentFilled = 0;
    shadowImage = [UIImage imageNamed:@"jauge_shadow_paysage.png"];
  }
  return self;
}



//animate the gauge given a percentage to fill and a direction
- (void)fillGaugeToValue:(int)percent  andFillDirection:(FillDirection)theDirection animated:(BOOL)isAnimated{
  //set the fillDirection value for the gauge
  fillDirectionForGauge = theDirection;
  animated = isAnimated;
  [self setPercentFilled:percent];
  
  [self fillGauge];
}

//update the gauge given a percentage to fill and a direction
- (void)refillGaugeToValue:(int)percent andFillDirection:(FillDirection)theDirection animated:(BOOL)isAnimated{
  //set the fillDirection value for the gauge
  if(drawnOnce){
    animated = isAnimated;
    drawnOnce=YES;
    [self setPercentFilled:percent];
    [self setFillDirectionForGauge:theDirection];
    if (outerShadow) {
      [self makeGradientOnView:fillView];
		}//if
    [self setNeedsLayout];
  }
}

- (void)setFrame:(CGRect)frame{
  [super setFrame:frame];
  gaugeFrame = frame;
}

@end
