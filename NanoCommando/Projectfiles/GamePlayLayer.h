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

@interface GamePlayLayer : CCLayer

-(id) initWithGame;

@property (nonatomic, weak) PlayerShip* playerShip;
@property (nonatomic, strong) CancerCollection *cancerCells;
@property (nonatomic, strong) TileMapLayer* tileLayer;
@end
