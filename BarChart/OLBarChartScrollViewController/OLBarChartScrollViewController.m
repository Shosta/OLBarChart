//
//  OLBarChartScrollViewController.m
//  OLBarChartDemo
//
//  Created by Rémi LAVEDRINE on 02/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "OLBarChartScrollViewController.h"


@implementation OLBarChartScrollViewController

@synthesize barChartScrollView;


#pragma mark -
#pragma mark Barchart view datasource methods

- (NSInteger)numberOfSectionsInBarChart:(OLBarChartScrollView *)barChart{
  return 0;
}

- (NSInteger)barChart:(OLBarChartScrollView *)barChart numberOfBarInSection:(NSInteger)section{
  return 0;
}

- (OLBar *)barChart:(OLBarChartScrollView *)barChart barForChartAtIndexPath:(NSIndexPath *)indexPath{
  return nil;
}


#pragma mark -
#pragma mark Barchart view delegate methods

- (NSInteger)barChart:(OLBarChartScrollView *)barChart widthForBarAtIndexPath:(NSIndexPath *)indexPath{
  return 50;
}

- (BOOL)barChart:(OLBarChartScrollView *)barChart innerShadowForGaugeAtIndexPath:(NSIndexPath *)indexPath{
  return NO;
}

- (BOOL)barChart:(OLBarChartScrollView *)barChart outerShadowForGaugeAtIndexPath:(NSIndexPath *)indexPath{
  return NO;
}

- (UIColor *)barChart:(OLBarChartScrollView *)barChart colorForGaugeAtIndexPath:(NSIndexPath *)indexPath{
  return [UIColor orangeColor];
}

- (UIColor *)barChart:(OLBarChartScrollView *)barChart backgroundColorForBarAtIndexPath:(NSIndexPath *)indexPath{
  return [UIColor clearColor];
}

- (UIColor *)barChart:(OLBarChartScrollView *)barChart backgroundColorForGaugeAtIndexPath:(NSIndexPath *)indexPath{
  return [UIColor clearColor];
}
 
- (UIColor *)barChart:(OLBarChartScrollView *)barChart backgroundColorForHorizontalLegendAtIndexPath:(NSIndexPath *)indexPath{
  return [UIColor clearColor];
}
 
- (UIColor *)barChart:(OLBarChartScrollView *)barChart backgroundColorForVerticalLegendAtIndexPath:(NSIndexPath *)indexPath{
  return [UIColor clearColor];
}



#pragma mark -
#pragma mark Object life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)dealloc
{
  [barChartScrollView release];
  
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Do any additional setup after loading the view from its nib.
  barChartScrollView = [[OLBarChartScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
  barChartScrollView.barDataSource = self;
	barChartScrollView.barDelegate = self;
  barChartScrollView.backgroundColor = [UIColor clearColor];
  
	[self.view addSubview:barChartScrollView];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
