//
//  PlayerShip.h
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//
//
//@class GamePlayLayer;

#import "GameObject.h"

@class HudLayer;
@class GJCollisionBitmap;

@interface PlayerShip : GameObject

@property (nonatomic, weak) HudLayer *hud;
@property (nonatomic, weak) GJCollisionBitmap *collision;
@property (nonatomic, assign) int turretInventory;

+(id) createWithLayer:(GamePlayLayer*)layer;


@end
