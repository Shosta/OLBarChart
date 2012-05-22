//
//  NSMutableArray+QueueAdditions.h
//  OLBarChartDemo
//
//  Created by Rémi LAVEDRINE on 29/08/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (id) getTail;
- (void) enqueue:(id)obj;
- (void) addToHead:(id)obj;
@end
