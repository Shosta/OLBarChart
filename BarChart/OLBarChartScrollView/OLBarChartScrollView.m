//
//  OLBarChartScrollView.m
//  OLBarChartDemo
//
//  Created by Rémi LAVEDRINE on 29/08/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "OLBarChartScrollView.h"


@implementation OLBarChartScrollView

@synthesize barDataSource = barDataSource_;
@synthesize barDelegate = barDelegate_;

#define BAR_OBJ_KEY @"barObjKey"
#define BAR_INDEXPATH_KEY @"barIndexPathKey"
#define OLBAR_PADDING 10


#pragma mark -
#pragma mark Object life cycle

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    numberOfSections = 0;
    numberOfBars = 0;
    previousOffsetX = 0;
    
    allBars_ = [[NSMutableArray alloc] initWithCapacity:0];
    visibleOLBars_ = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.delegate = self;
  }
  return self;
}


#pragma mark -
#pragma mark Bar Long press gesture management

/**
 Get the indexPath of touched bar from its position on the screen.
 @author : Rémi Lavedrine
 @date : 01/09/2011
 @remarks : (facultatif)
 */
- (NSIndexPath *)getBarIndexPathFromLocation:(CGPoint)center{
  for ( NSDictionary *currentBarDict in visibleOLBars_ ) {
    OLBar *currentBar = [currentBarDict objectForKey:BAR_OBJ_KEY];
    CGFloat leftBarXPoint = currentBar.frame.origin.x;
    CGFloat rightBarXPoint = currentBar.frame.origin.x + currentBar.frame.size.width;
    
    if ( center.x > leftBarXPoint && center.x < rightBarXPoint ) {
      // NSLog(@"[::getBarFromLocation] %@, %@", currentBar.verticalLegend.text, currentBar.horizontalLegend.text);
      return [currentBarDict objectForKey:BAR_INDEXPATH_KEY];
    }
  }
  
  return nil;
}

- (void)launchBarChartBarActionAtIndexPath:(NSIndexPath *)indexPath{
  [barDelegate_ barChart:self didSelectBarAtIndexPath:indexPath];
}

- (void)handleBarLongPress:(UILongPressGestureRecognizer *)recognizer{
  NSIndexPath *barIndexPath = [self getBarIndexPathFromLocation:[recognizer locationInView:self]];
  
  switch ( [recognizer state]) {
    case UIGestureRecognizerStatePossible:
      // We can use this recognizer to implement the |willSelectBarAtIndexPath| method.
      break;
      
    case UIGestureRecognizerStateBegan:
      [self launchBarChartBarActionAtIndexPath:barIndexPath];
      break;
      
    default:
      break;
  }
}

/**
 Add a long press gesture to the bar.
 @author : Rémi Lavedrine
 @date : 01/09/2011
 @remarks : (facultatif)
 */
- (void)addLongPressGestureRecognizerOnBar:(OLBar *)oLBar atIndexPath:(NSIndexPath *)indexPath{
  if ([barDelegate_ respondsToSelector:@selector(barChart:didSelectBarAtIndexPath:)]) {
    UIGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleBarLongPress:)];
    [oLBar addGestureRecognizer:longPressGesture];
  }
  
}


#pragma mark -
#pragma mark Design Bar for the BarChart from the dataSource

/**
 Define the design of the bar's gauge from the delegate.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (void)defineGaugeDesignOnBar:(OLBar *)bar atIndexPath:(NSIndexPath *)indexPath{
  // Defining the inner shadow in the gauge of the bar.
  if ([barDelegate_ respondsToSelector:@selector(barChart:innerShadowForGaugeAtIndexPath:)]) {
    [[bar olGauge] setInnerShadow:[barDelegate_ barChart:self innerShadowForGaugeAtIndexPath:indexPath]];
  }
  
  // Defining the outer shadow in the gauge of the bar.
  if ([barDelegate_ respondsToSelector:@selector(barChart:outerShadowForGaugeAtIndexPath:)]) {
    [[bar olGauge] setOuterShadow:[barDelegate_ barChart:self outerShadowForGaugeAtIndexPath:indexPath]];
  }
  
}

/**
 Define the colors for each component of the bar from the delegate.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (void)defineColorsOnBar:(OLBar *)bar atIndexPath:(NSIndexPath *)indexPath{
  // Defining the background color of the bar.
  if ([barDelegate_ respondsToSelector:@selector(barChart:backgroundColorForBarAtIndexPath:)]) {
    UIColor *barBackgroundColor = [barDelegate_ barChart:self backgroundColorForBarAtIndexPath:indexPath];
    [bar setBackgroundColor:barBackgroundColor]; 
  }
  
  // Defining the color wich will fill the bar's gauge.
  if ([barDelegate_ respondsToSelector:@selector(barChart:colorForGaugeAtIndexPath:)]) {
    [[bar olGauge] setFillColor:[barDelegate_ barChart:self colorForGaugeAtIndexPath:indexPath]];
  }
  
  // Defining the background color wich will be filled by the bar's gauge.
  if ([barDelegate_ respondsToSelector:@selector(barChart:backgroundColorForGaugeAtIndexPath:)]) {
    UIColor *barBackgroundColor = [barDelegate_ barChart:self backgroundColorForGaugeAtIndexPath:indexPath];
    [[bar olGauge] setBackgroundColor:barBackgroundColor];
  }
  
  // Defining the background color of the text on top of the bar. 
  if ([barDelegate_ respondsToSelector:@selector(barChart:backgroundColorForHorizontalLegendAtIndexPath:)]) {
    UIColor *barBackgroundColor = [barDelegate_ barChart:self backgroundColorForHorizontalLegendAtIndexPath:indexPath];
    [[bar verticalLegend] setBackgroundColor:barBackgroundColor];
  }
  
  // Defining the background color of the text at the bottom of the bar.
  if ([barDelegate_ respondsToSelector:@selector(barChart:backgroundColorForVerticalLegendAtIndexPath:)]) {
    UIColor *barBackgroundColor = [barDelegate_ barChart:self backgroundColorForVerticalLegendAtIndexPath:indexPath];
    [[bar horizontalLegend] setBackgroundColor:barBackgroundColor];
  }
  
}

/**
 Define the size of the bar from the delegate.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (void)defineSizeOfBar:(OLBar *)bar atIndexPath:(NSIndexPath *)indexPath{
  if ([barDelegate_ respondsToSelector:@selector(barChart:widthForBarAtIndexPath:)]) {
    int barWidth = [barDelegate_ barChart:self widthForBarAtIndexPath:indexPath];
    
    // Defining the width of the bar.
    CGRect barFrame = bar.frame;
    [bar setFrame:CGRectMake(barFrame.origin.x, barFrame.origin.y, barWidth, barFrame.size.height)];
    
    // Defining the width of the bar's gauge.
    CGRect gaugeFrame = [bar getOLGaugeFrame];
    [bar.olGauge setFrame:CGRectMake(gaugeFrame.origin.x, gaugeFrame.origin.y, barWidth, gaugeFrame.size.height)];
  }
  
}


#pragma mark -
#pragma mark Create Bar for the BarChart from the dataSource

/**
 Create a Bar from the dataSource.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (OLBar *)createOLBarFromDataSourceAtIndexPath:(NSIndexPath *)indexPath {
  OLBar *oLBar = [barDataSource_ barChart:self barForChartAtIndexPath:indexPath];
  
  [self defineGaugeDesignOnBar:oLBar atIndexPath:indexPath];
  [self defineColorsOnBar:oLBar atIndexPath:indexPath];
  [self defineSizeOfBar:oLBar atIndexPath:indexPath];
  
  [self addLongPressGestureRecognizerOnBar:oLBar atIndexPath:indexPath];
  
  return oLBar;
}


#pragma mark -
#pragma mark Populate visible bar queue

/**
 Return the number of bar that should be visible concerning the barWidth described on the dataSource and the viewWidth.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (int)getMaxVisibleBarNumberOnViewFromViewWidth:(int)viewWidth{
  
  int maxVisibleOLBarNumberOnView = 0;
  
  if ([barDelegate_ respondsToSelector:@selector(barChart:widthForBarAtIndexPath:)]) {
    int barWidth = [barDelegate_ barChart:self widthForBarAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    maxVisibleOLBarNumberOnView = floor(viewWidth / (barWidth + OLBAR_PADDING)) + 2;
    
    if (numberOfBars < maxVisibleOLBarNumberOnView) {
      maxVisibleOLBarNumberOnView = numberOfBars;
    }
  }else{
    maxVisibleOLBarNumberOnView = numberOfBars;
  }
  
  return maxVisibleOLBarNumberOnView;
}

- (NSInteger)getSectionNumber{
  // Get the number of sections
	int sectionsNumbers = 0;
  if ([barDataSource_ respondsToSelector:@selector(numberOfSectionsInBarChart:)]) {
		sectionsNumbers = [barDataSource_ numberOfSectionsInBarChart:self];
	}
  return sectionsNumbers;
}

- (NSInteger)getBarNumberForSection:(NSInteger)sectionNumber{
  // Get the number of sections
	int barsNumbers = 0;
  if ([barDataSource_ respondsToSelector:@selector(barChart: numberOfBarInSection:)]) {
		barsNumbers = [barDataSource_ barChart:self numberOfBarInSection:sectionNumber];
	}
  return barsNumbers;
}

/**
 Return the number of bar that are described in the dataSource.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (NSInteger)getAllOLBarNumber{
	NSInteger allBarNumber = 0;
  
  // Get the number of sections
	if ([barDataSource_ respondsToSelector:@selector(numberOfSectionsInBarChart:)]) {
		numberOfSections = [barDataSource_ numberOfSectionsInBarChart:self];
	}
	
  // Get the total number of bars from all sections
	if ([barDataSource_ respondsToSelector:@selector(barChart:numberOfBarInSection:)]) {
		for (NSInteger currentSection = 0; currentSection<numberOfSections; currentSection++) {
			int numberOfBarInCurrentSection = [barDataSource_ barChart:self numberOfBarInSection:currentSection];
			allBarNumber = allBarNumber + numberOfBarInCurrentSection;
		}//for
	}//if
  
  return allBarNumber;
}

/**
 Add to a queue all the bars that should be visible on screen.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (void)addVisibleBarsToList{
  numberOfBars = [self getAllOLBarNumber];
  int maxVisibleOLBarNumberOnView = [self getMaxVisibleBarNumberOnViewFromViewWidth:320];
  int barAddedToVisibleQueueNumber = 0;
  
  int totalSectionNumber = [self getSectionNumber];
  for (NSInteger currentSectionIndex = 0; currentSectionIndex < totalSectionNumber; currentSectionIndex++) {
    // For each section, we get the number of corresponding bar.
    int totalBarNumberForCurrentSection = [self getBarNumberForSection:currentSectionIndex];
    for (NSInteger currentBarIndex = 0; currentBarIndex < totalBarNumberForCurrentSection; currentBarIndex++) {
      OLBar *oLBar = [self createOLBarFromDataSourceAtIndexPath:[NSIndexPath indexPathForRow:currentBarIndex inSection:currentSectionIndex]];
      
      if ( barAddedToVisibleQueueNumber < maxVisibleOLBarNumberOnView ) {
        // We enqueue the Bar's index of the allBar_ array to the visibleOLBar_ queue.
        NSDictionary *barDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:oLBar, [NSIndexPath indexPathForRow:currentBarIndex inSection:currentSectionIndex], nil]  
                                                         forKeys:[NSArray arrayWithObjects:BAR_OBJ_KEY, BAR_INDEXPATH_KEY, nil]];
        [visibleOLBars_ enqueue:barDict];
        barAddedToVisibleQueueNumber++;
      }
    }
  }
}


#pragma mark -
#pragma mark Draw bars on view

/**
 Recenter the view if the contentSize width is smaller than the viewSize width.
 @author : Rémi Lavedrine
 @date : 02/09/2011
 @remarks : (facultatif)
 */
- (void)recenterViewIfNeeded{
  int contentWidth = self.contentSize.width;
  int viewWidth = self.frame.size.width;
  CGRect viewFrame = [self frame];
  
  if ( contentWidth < viewWidth) {
    int newViewXOrigin = floor( (viewWidth - contentWidth) / 2 );
    [self setFrame:CGRectMake(newViewXOrigin, viewFrame.origin.y, contentWidth, self.frame.size.height)];
  }
}

/**
 Add each bar width to calculate the barChart content size and set it.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (void)setContentSize{
  if ([barDelegate_ respondsToSelector:@selector(barChart:widthForBarAtIndexPath:)]) {
    int totalBarChartWidth = 0;
    
    int totalSectionNumber = [self getSectionNumber];
    for (NSInteger currentSectionIndex = 0; currentSectionIndex < totalSectionNumber; currentSectionIndex++) {
      int totalBarNumberForCurrentSection = [self getBarNumberForSection:currentSectionIndex];
      for (NSInteger currentBarIndex = 0; currentBarIndex < totalBarNumberForCurrentSection; currentBarIndex++) {
        // Add the current bar width to the total size.
        int currentBarWidth = [barDelegate_ barChart:self widthForBarAtIndexPath:[NSIndexPath indexPathForRow:currentBarIndex inSection:currentSectionIndex]];
        totalBarChartWidth = totalBarChartWidth + OLBAR_PADDING + currentBarWidth;
      }
    }
    
    totalBarChartWidth = totalBarChartWidth - OLBAR_PADDING;
    self.contentSize =CGSizeMake(totalBarChartWidth, self.frame.size.height);
  }
}

/**
 Add each bar contained in the queue (the ones that should be visible) to the view.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : Adding the bar to the view will not make it visible. You had to draw it.
 */
- (void)addVisibleBarToView{
  int originX = 0;
  for ( NSDictionary *barDict in visibleOLBars_) {
    OLBar *olBar = [barDict objectForKey:BAR_OBJ_KEY];
    [olBar setFrame:CGRectMake(originX, 0, 50, self.frame.size.height)];
    originX = originX + 50 + OLBAR_PADDING;
  }

}

/**
 Draw each bar contained in the queue (the ones that should be visible) to the view.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : The drawing must be done after adding the bar to the view.
 */
- (void)drawAllVisibleBars{
  for ( NSDictionary *barDict in visibleOLBars_) {
    OLBar *olBar = [barDict objectForKey:BAR_OBJ_KEY];
    [olBar drawBar];
    [self addSubview:olBar];
  }
}


#pragma mark -
#pragma mark IndexPath management

- (NSIndexPath *)getPreviousIndexPath:(NSIndexPath *)currentIndexPath{
  NSIndexPath *previousIndexPath = nil;
  
  if ( currentIndexPath.row > 0 ) {
    previousIndexPath = [NSIndexPath indexPathForRow:(currentIndexPath.row - 1) inSection:currentIndexPath.section];
  }else{
    previousIndexPath = [NSIndexPath indexPathForRow:([self getBarNumberForSection:(currentIndexPath.section - 1)] - 1) inSection:(currentIndexPath.section - 1)];
  }
  
  // NSLog(@"currentIndexPath : %@; previousIndexPath : %@", [currentIndexPath description], [previousIndexPath description]);
  return previousIndexPath;
}

- (NSIndexPath *)getNextIndexPath:(NSIndexPath *)currentIndexPath{
  NSIndexPath *nextIndexPath = nil;
  
  int totalBarNumberForSection = [self getBarNumberForSection:currentIndexPath.section];
  if ( currentIndexPath.row < totalBarNumberForSection - 1 ) {
    nextIndexPath = [NSIndexPath indexPathForRow:(currentIndexPath.row + 1) inSection:currentIndexPath.section];
  }else{
    nextIndexPath = [NSIndexPath indexPathForRow:0 inSection:(currentIndexPath.section + 1)];
  }
  
  // NSLog(@"currentIndexPath : %@; nextIndexPath : %@", [currentIndexPath description], [nextIndexPath description]);
  return nextIndexPath;
}



#pragma mark -
#pragma mark Move reusable bar

/**
 Move a bar to a new position on the current OLBarChartScrollView.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (void)addBar:(OLBar *)bar OnNewPosition:(CGRect)newPosition{
  [bar removeFromSuperview];
  [bar fillAllBarValuesWithDirection:bottomToTop];
  [bar setFrame:newPosition];
  [self addSubview:bar];
}

/**
 Move a bar to the head of the current OLBarChartScrollView.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (void)addBarOnBarChartHead{
  NSDictionary *firstBarDict = [visibleOLBars_ objectAtIndex:0];
  // It retrieves the bar since the creation of bar (in this case it will normally be reused and not recreated).
  NSIndexPath *firstVisibleBarIndexPath = [firstBarDict objectForKey:BAR_INDEXPATH_KEY];
  NSIndexPath *reusedBarIndexPath = [self getPreviousIndexPath:firstVisibleBarIndexPath];
  OLBar *reusedBar = [self createOLBarFromDataSourceAtIndexPath:reusedBarIndexPath];
  
  // Moving the bar after the first bar currently visible.
  OLBar *firstVisibleBar = [firstBarDict objectForKey:BAR_OBJ_KEY];
  int newBarOriginX = firstVisibleBar.frame.origin.x - OLBAR_PADDING - reusedBar.frame.size.width;
  [self addBar:reusedBar OnNewPosition:CGRectMake(newBarOriginX, reusedBar.frame.origin.y, reusedBar.frame.size.width, reusedBar.frame.size.height)];
  
  // We add the new bar at the beginning of the visible bars queue.
  [visibleOLBars_ addToHead:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:reusedBar, reusedBarIndexPath, nil] 
                                                        forKeys:[NSArray arrayWithObjects:BAR_OBJ_KEY, BAR_INDEXPATH_KEY, nil]]];
}

/**
 Move a bar to the tail of the current OLBarChartScrollView.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (void)addBarOnBarChartTail{
  // It retrieves the bar since the creation of bar (in this case it will normally be reused and not recreated).
  NSIndexPath *lastVisibleBarIndexPath = [[visibleOLBars_ lastObject] objectForKey:BAR_INDEXPATH_KEY];
  NSIndexPath *reusedBarIndexPath = [self getNextIndexPath:lastVisibleBarIndexPath];
  OLBar *reusedBar = [self createOLBarFromDataSourceAtIndexPath:reusedBarIndexPath];
  
  // Moving the bar after the last bar currently visible.
  OLBar *lastVisibleBar = [[visibleOLBars_ lastObject] objectForKey:BAR_OBJ_KEY];
  int newBarOriginX = lastVisibleBar.frame.origin.x + lastVisibleBar.frame.size.width + OLBAR_PADDING;
  [self addBar:reusedBar OnNewPosition:CGRectMake(newBarOriginX, reusedBar.frame.origin.y, reusedBar.frame.size.width, reusedBar.frame.size.height)];
  
  // We add the new bar at the beginning of the visible bars queue.
  [visibleOLBars_ enqueue:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:reusedBar, reusedBarIndexPath, nil] 
                                                        forKeys:[NSArray arrayWithObjects:BAR_OBJ_KEY, BAR_INDEXPATH_KEY, nil]]];
}


#pragma mark -
#pragma mark Reuse bar

/**
 Dequeue a bar from head or tail (depends on the scrolling way) and return it. Return nil if no bar is available.
 @author : Rémi Lavedrine
 @date : 31/08/2011
 @remarks : (facultatif)
 */
- (OLBar *)dequeueReusableBar{
  if ( [visibleOLBars_ count] < 1 ) {
    return nil;
  }else{
    OLBar *firstVisibleBar = [[visibleOLBars_ objectAtIndex:0] objectForKey:BAR_OBJ_KEY];
    int barUnvisibleX = firstVisibleBar.frame.origin.x + firstVisibleBar.frame.size.width + OLBAR_PADDING;
    if ( barUnvisibleX < self.contentOffset.x ) {
      return [[visibleOLBars_ dequeue] objectForKey:BAR_OBJ_KEY];
    }
    if ( firstVisibleBar.frame.origin.x > self.contentOffset.x ){
      return [[visibleOLBars_ getTail] objectForKey:BAR_OBJ_KEY];
    }
  }
  return nil;
}

- (void)layoutSubviews{
  if ([barDelegate_ respondsToSelector:@selector(barChart:barForChartAtIndexPath:)]) {
    if ( [visibleOLBars_ count] < 1 ) {
      [self setContentSize];
      [self addVisibleBarsToList];
      [self addVisibleBarToView];
      [self drawAllVisibleBars];
      [self recenterViewIfNeeded];
    }
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
  if ([barDelegate_ respondsToSelector:@selector(barChart:barForChartAtIndexPath:)]) {
    OLBar *firstVisibleBar = [[visibleOLBars_ objectAtIndex:0] objectForKey:BAR_OBJ_KEY];
    int barUnvisibleX = firstVisibleBar.frame.origin.x + firstVisibleBar.frame.size.width + OLBAR_PADDING;
    BOOL scrollFromLeftToRight = previousOffsetX < scrollView.contentOffset.x;
    
    // Adding the first bar to the end.
    if ( barUnvisibleX < scrollView.contentOffset.x && scrollView.contentOffset.x < (scrollView.contentSize.width - scrollView.frame.size.width - OLBAR_PADDING - 50) && scrollFromLeftToRight ) {
      [self addBarOnBarChartTail];
    }
    
    // Adding the last bar to the head.
    if ( firstVisibleBar.frame.origin.x > scrollView.contentOffset.x && scrollView.contentOffset.x > 0 && !scrollFromLeftToRight ) {
      [self addBarOnBarChartHead];
    }
    
    previousOffsetX = scrollView.contentOffset.x;
  }
  
}


#pragma mark -
#pragma mark Public accessors

- (NSMutableArray *)visibleOLBars{
  return visibleOLBars_;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
  [visibleOLBars_ release];
  
  [super dealloc];
}

@end
