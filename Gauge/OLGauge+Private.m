//
//  Gauge+Private.m
//  OrangeEtMoi
//
//  Created by Mathieu Mouilliere on 02/03/11.
//  Copyright 2011 Orange. All rights reserved.
//

#import "OLGauge+Private.h"

@implementation OLGauge (Private)

//setters
- (void)setFillColor:(UIColor *)aColor
{
	[aColor retain];
	[fillColor release];
	fillColor = aColor;
	fillView.backgroundColor = fillColor;
	[fillView setNeedsDisplay];
}

- (void)setGaugeBackgroundColor:(UIColor *)aColor
{
  
	[aColor retain];
	[gaugeBackgroundColor release];
	gaugeBackgroundColor = aColor;
	self.backgroundColor = gaugeBackgroundColor;
	[self setNeedsDisplay];
}

- (void)setInnerShadow:(BOOL)shadow{
  innerShadow=shadow;
  if (!innerShadow) 
  {
    if (shadowView) 
    {
      [shadowView removeFromSuperview];
      [shadowView release];
    }
  }
}

- (void)setShadowImage:(UIImage *)anImage{
  shadowImage = [anImage retain];
  innerShadow = YES;
}

- (void)setPercentFilled:(int)percent
{
  percentFilled=percent;
	if(percentFilled<0) {
    percentFilled=0;
  }
  if (percentFilled>100) {
    percentFilled=100;
  }
}


//return the height for the filling
- (float)getFillHeight{
  return percentFilled * gaugeFrame.size.height / 100;
}

- (float)getFillWidth{
  return percentFilled * gaugeFrame.size.width / 100;
}


//Positionnate the fillview switch the fillDirection
- (void)addFillView{
  switch (fillDirectionForGauge) {
    case leftToRight:
      fillFrame = CGRectMake(0, 0, 0, gaugeFrame.size.height);
      break;
    case rightToLeft:
      fillFrame = CGRectMake(gaugeFrame.size.width, 0, 0, gaugeFrame.size.height);
      break;
    case bottomToTop:
      fillFrame = CGRectMake(0, gaugeFrame.size.height, gaugeFrame.size.width, 0);
      break;
    case topToBottom:
      fillFrame = CGRectMake(0, 0, gaugeFrame.size.width, 0);
      break;
      
    default:
      break;
  }
  
	fillView = [[UIView alloc] initWithFrame:fillFrame];
	fillView.backgroundColor = fillColor;
	[self addSubview:fillView];
}

//return the frame of the fillview for animation
- (CGRect)getFillFrame{
  CGRect frame = fillFrame;
  if (fillDirectionForGauge == leftToRight || fillDirectionForGauge == rightToLeft) {
    float width = [self getFillWidth];
    frame.size.width += width;
    if (fillDirectionForGauge == rightToLeft)
      frame.origin.x -= width;
  }
  else
  {
    float height = [self getFillHeight];
    if (fillDirectionForGauge == bottomToTop)
      frame.size.height -= height;
    else
      frame.size.height += height;
  }
  return frame;
}

-(UIView *)getFillView{
	return fillView;
}

- (void)addInnerShadowViewIfNeeded{
  if (innerShadow){
    shadowView= [[UIImageView alloc] initWithImage:shadowImage];
    // shadowView.frame = CGRectMake(0, 0, gaugeFrame.size.width, gaugeFrame.size.height);
    shadowView.frame = CGRectMake(0, 0, fillFrame.size.width, fillFrame.size.height);
    [self addSubview:shadowView];
  }
}

- (void)addOuterShadowViewIfNeeded{
  if (outerShadow) {
    [self makeGradientOnView:fillView];
  }//if
}

- (void)addAllShadowViewIfNeeded{
  [self addInnerShadowViewIfNeeded];
  [self addOuterShadowViewIfNeeded];
}

- (void)fillGauge{
  //add the view that will be animated 
  [self addFillView];
  
  //calculate the final frame for the animation
  CGRect newFrame = [self getFillFrame];
  if (animated) {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:fillDuration];
    [self addAllShadowViewIfNeeded];
		fillView.frame= newFrame;
		[UIView commitAnimations];
  }
  else{
    [self addAllShadowViewIfNeeded];
    fillView.frame= newFrame;
  }
	
}

//redraw the gauge given a new frame
- (void)redrawWithNewFrame:(CGRect)newFrame
{
  gaugeFrame=newFrame;
  [fillView removeFromSuperview];
  [fillView release];
  if (innerShadow){
    
    [shadowView removeFromSuperview];
    [shadowView release];
  }
  [self fillGauge];
	
}

- (void)layoutSubviews {
  [super layoutSubviews];
	
  if (drawnOnce) {
    [self redrawWithNewFrame:[self frame]];
  }
 drawnOnce=YES;
}

/**
 Permet de mettre une ombre portée sur la vue de la jauge.
 @author : Rémi Lavedrine & Mathieu Mouillière
 @date : 14/03/2011
 @remarks : (facultatif)
 */
- (void)makeGradientOnView:(UIView *)view{
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 3.2)
	{
		//turning off bounds clipping allows the shadow to extend beyond the rect of the view
		[view setClipsToBounds:NO];
		
		//the colors for the gradient.  highColor is at the top, lowColor as at the bottom
		UIColor * highColor = [UIColor colorWithWhite:1.000 alpha:1.000];
		UIColor * lowColor = [UIColor colorWithRed:0.851 green:0.859 blue:0.867 alpha:1.000];
		
		//The gradient, simply enough.  It is a rectangle
		CAGradientLayer * gradient = [CAGradientLayer layer];
		[gradient setFrame:[view bounds]];
		[gradient setColors:[NSArray arrayWithObjects:(id)[highColor CGColor], (id)[lowColor CGColor], nil]];
		
		//[gradient setStartPoint:CGPointMake(0, 0)];
		//[gradient setEndPoint:CGPointMake(view.frame.size.width, 0)];
		
		//the rounded rect, with a corner radius of 6 points.
		//this *does* maskToBounds so that any sublayers are masked
		//this allows the gradient to appear to have rounded corners
		CALayer * roundRect = [CALayer layer];
		[roundRect setFrame:[view bounds]];
		[roundRect setCornerRadius:6.0f];
		[roundRect setMasksToBounds:YES];
		[roundRect addSublayer:gradient];
		
		//add the rounded rect layer underneath all other layers of the view
		[[view layer] insertSublayer:roundRect atIndex:0];
		
		//set the shadow on the view's layer
		[[view layer] setShadowColor:[[UIColor blackColor] CGColor]];
		[[view layer] setShadowOffset:CGSizeMake(0, 4)];
		[[view layer] setShadowOpacity:0.6];
		[[view layer] setShadowRadius:5.0];
	}
  
}


- (void)dealloc
{
  [fillView release];
  [fillColor release];
  [gaugeBackgroundColor release];
  [super dealloc];
}

@end
