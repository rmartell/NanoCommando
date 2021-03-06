//
//  CancerCell.h
//  NanoCommando
//
//  Created by Ryan Martell on 1/26/13.
//
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "GJCollisionBitmap.h"

@interface CancerCell : GameObject
-(void)die;
@end

@interface CancerCollection : NSObject
-(id)initWithLayer:(GamePlayLayer *)layer andCollisionMask:(GJCollisionBitmap *)bitmap;

-(void)update:(ccTime)ticksPassed;
-(void)seed;

-(NSArray *)cancerCellsInRange:(float)range ofPoint:(CGPoint)pt;
-(NSArray *)cancerCellsInRange:(float)range ofPoint:(CGPoint)pt maxNumber:(int)max;
-(NSArray *)cellsIntersectedByLineSegmentStart:(CGPoint)pt end:(CGPoint)end;
@end