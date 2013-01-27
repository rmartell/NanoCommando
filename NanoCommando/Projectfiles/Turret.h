//
//  Turret.h
//  NanoCommando
//
//  Created by Ryan Martell on 1/26/13.
//
//

#import "GameObject.h"


@class GJCollisionBitmap;

// probably should have some sort of collection of sprite type class as common ancestor to this and Cancer
@interface Turret : GameObject
@end

@interface TurretCollection : NSObject
-(id)initWithLayer:(GamePlayLayer *)layer andCollisionMask:(GJCollisionBitmap *)bitmap;

-(void)update:(ccTime)ticksPassed;
-(void)seed;
-(void)addTurretAtPoint:(CGPoint)pt;
@end