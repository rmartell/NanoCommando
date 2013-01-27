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
@class Heart;
@class CancerCollection;
@class TurretCollection;
@class GJCollisionBitmap;

@interface GamePlayLayer : CCLayer

-(id) initWithGame;

@property (nonatomic, weak) CCSpriteBatchNode* batchNode;
@property (nonatomic, weak) Heart* heart;
@property (nonatomic, weak) PlayerShip* playerShip;

@property (nonatomic, strong) CancerCollection *cancerCells;
@property (nonatomic, strong) TurretCollection *turrets;
@property (nonatomic, strong) TileMapLayer* tileLayer;
@property (nonatomic, strong) GJCollisionBitmap *collisionMask;

-(CGPoint)screenPointToWorldPoint:(CGPoint)pt;
@end
