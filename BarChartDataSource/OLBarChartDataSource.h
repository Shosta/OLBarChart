//
//  OLBarChartDataSource.h
//  OrangeEtMoi
//
//  Created by Rémi LAVEDRINE on 10/03/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


// @class OLBarChartScollView;
@class OLBarChartScrollView;
@class OLBar;
@protocol OLBarChartDataSource

@optional
- (NSString *)barChart:(OLBarChartScrollView *)barChart titleInSection:(NSInteger)section;

@required
- (NSInteger)numberOfSectionsInBarChart:(OLBarChartScrollView *)barChart;
- (NSInteger)barChart:(OLBarChartScrollView *)barChart numberOfBarInSection:(NSInteger)section;
- (OLBar *)barChart:(OLBarChartScrollView *)barChart barForChartAtIndexPath:(NSIndexPath *)indexPath;

@end
