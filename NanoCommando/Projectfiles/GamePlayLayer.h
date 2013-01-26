//
//  GamePlayLayer.h
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//
//

#import "cocos2d.h"
#import "TileMapLayer.h"

@class PlayerShip;
@class CancerCollection;

#define MAP_WIDTH (4096)
#define MAP_HEIGHT (3072)

@interface GamePlayLayer : CCLayer


-(id)initWithTileLayer:(TileMapLayer*)tileLayer;

@property (nonatomic, weak) PlayerShip* playerShip;
@property (nonatomic, strong) CancerCollection *cancerCells;

@end
