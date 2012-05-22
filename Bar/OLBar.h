//
//  Bar.h
//  OrangeEtMoi
//
//  Created by Rémi LAVEDRINE on 10/03/11.
//  Copyright 2011 Orange Labs. All rights reserved.
// 
// A OLBar contains a Gauge as described in the OLGauge class and a UILabel on top of the OLGauge and a UILabel at the bottom of the OLGauge.  
//

#import <UIKit/UIKit.h>
#import "OLGauge.h"


@interface OLBar : UIView {
	
	OLGauge *olGauge;
	
	int m_percent_;
	NSString *m_horizontalLegend_;
	NSString *m_verticalLegend_;
	
	UILabel *horizontalLegend;
	UILabel *verticalLegend;
	
	CGFloat barWidth;
	CGFloat barHeight;

}

@property (assign) 	id barDelegate;
@property (nonatomic, retain) OLGauge *olGauge;
@property (nonatomic, retain) UILabel *horizontalLegend;
@property (nonatomic, retain) UILabel *verticalLegend;


// Drawing Bar management
- (id)initWithContainerFrame:(CGRect)frame percent:(int)a_percent horizontalLegend:(NSString *)a_horizontalLegend andVerticalLegend:(NSString *)a_verticalLegend;

- (void)drawBar;

- (OLGauge *)createOLGaugeWithPercent:(int)a_gaugePercent fillDirection:(FillDirection)a_gaugeFillDirection animated:(BOOL)animated;
- (void)addHorizontalLegendWithFrame:(CGRect)a_frame andLegend:(NSString *)a_legend;
- (void)addVerticalLegendWithFrame:(CGRect)a_frame andLegend:(NSString *)a_legend;
- (void)fillAllBarValuesWithDirection:(FillDirection)theDirection;
- (void)fillHorizontalLegendWithLegend:(NSString *)legend;
- (void)fillVerticalLegendWithLegend:(NSString *)legend;


// OLBar object size management
- (CGRect)getOLGaugeFrame;
- (CGRect)getHorizontalLabelFrame;
- (CGRect)getVerticalLabelFrame;

// Accessors et Setters
- (int)percent;
- (NSString *)horizontalLegendValue;
- (NSString *)verticalLegendValue;

- (void)setPercentValue:(int)percent;
- (void)setHorizontalLegendValue:(NSString *)horizontalLegendValue;
- (void)setVerticalLegendValue:(NSString *)verticalLegendValue;

@end
