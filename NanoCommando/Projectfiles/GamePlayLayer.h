//
//  GamePlayLayer.h
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//
//
@class PlayerShip;

#import "cocos2d.h"
#import "TileMapLayer.h"

@interface GamePlayLayer : CCLayer

-(id)initWithTileLayer:(TileMapLayer*)tileLayer;

@property (nonatomic, weak) PlayerShip* playerShip;

@end
