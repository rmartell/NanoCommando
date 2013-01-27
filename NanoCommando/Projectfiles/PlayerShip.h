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

typedef enum {
    PlayerDeathStateAlive= 0,
    PlayerDeathStateWarning,
    PlayerDeathStateCritical,
    PlayerDeathStateDead,
    NUMBER_OF_DEATH_STATES
} PlayerDeathState;

@interface PlayerShip : GameObject

@property (nonatomic, weak) HudLayer *hud;
@property (nonatomic, weak) GJCollisionBitmap *collision;
@property (nonatomic, assign) int turretInventory;
@property (nonatomic, assign) PlayerDeathState deathState;

+(id) createWithLayer:(GamePlayLayer*)layer;


@end
