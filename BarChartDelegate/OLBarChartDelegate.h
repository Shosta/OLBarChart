//
//  OLBarChartDelegate.h
//  OrangeEtMoi
//
//  Created by Rémi LAVEDRINE on 11/03/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLBarChartScrollView;
@protocol OLBarChartDelegate

@optional
- (BOOL)barChart:(OLBarChartScrollView *)barChart innerShadowForGaugeAtIndexPath:(NSIndexPath *)indexPath; 
- (BOOL)barChart:(OLBarChartScrollView *)barChart outerShadowForGaugeAtIndexPath:(NSIndexPath *)indexPath; 

- (UIColor *)barChart:(OLBarChartScrollView *)barChart colorForGaugeAtIndexPath:(NSIndexPath *)indexPath; 
- (UIColor *)barChart:(OLBarChartScrollView *)barChart backgroundColorForBarAtIndexPath:(NSIndexPath *)indexPath; 
- (UIColor *)barChart:(OLBarChartScrollView *)barChart backgroundColorForGaugeAtIndexPath:(NSIndexPath *)indexPath; 
- (UIColor *)barChart:(OLBarChartScrollView *)barChart backgroundColorForHorizontalLegendAtIndexPath:(NSIndexPath *)indexPath; 
- (UIColor *)barChart:(OLBarChartScrollView *)barChart backgroundColorForVerticalLegendAtIndexPath:(NSIndexPath *)indexPath;

- (void)barChart:(OLBarChartScrollView *)tableView didSelectBarAtIndexPath:(NSIndexPath *)indexPath;
// - (NSIndexPath *)barChart:(OLBarChartScrollView *)tableView willSelectBarAtIndexPath:(NSIndexPath *)indexPath;

@required
- (NSInteger)barChart:(OLBarChartScrollView *)barChart widthForBarAtIndexPath:(NSIndexPath *)indexPath; 

@end
