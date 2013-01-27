//
//  PlayerShip.h
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//
//
//@class GamePlayLayer;

#import "GameObject.h"

@interface PlayerShip : GameObject



+(id) createWithLayer:(GamePlayLayer*)layer;

-(void)moveBy:(CGPoint)vector;

@end
