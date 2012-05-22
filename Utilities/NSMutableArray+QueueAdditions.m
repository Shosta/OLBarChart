//
//  NSMutableArray+QueueAdditions.m
//  OLBarChartDemo
//
//  Created by Rémi LAVEDRINE on 29/08/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "NSMutableArray+QueueAdditions.h"


@implementation NSMutableArray (QueueAdditions)

// Queues are first-in-first-out, so we remove objects from the head
- (id) dequeue {
  // if ([self count] == 0) return nil; // to avoid raising exception (Quinn)
  id headObject = [self objectAtIndex:0];
  if (headObject != nil) {
    [[headObject retain] autorelease]; // so it isn't dealloc'ed on remove
    [self removeObjectAtIndex:0];
  }
  return headObject;
}

// Queues are first-in-first-out, so we remove objects from the head
- (id) getTail {
  // if ([self count] == 0) return nil; // to avoid raising exception (Quinn)
  id tailObject = [self lastObject];
  if (tailObject != nil) {
    [[tailObject retain] autorelease]; // so it isn't dealloc'ed on remove
    [self removeLastObject];
  }
  return tailObject;
}

// Add to the tail of the queue (no one likes it when people cut in line!)
- (void) enqueue:(id)anObject {
  [self addObject:anObject];
  //this method automatically adds to the end of the array
}

// Add to the head of the queue (no one likes it when people cut in line!)
- (void) addToHead:(id)anObject {
  [self insertObject:anObject atIndex:0];
  //this method automatically adds to the beginning of the array
}

@end
