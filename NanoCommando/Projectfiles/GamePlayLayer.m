//
//  GamePlayLayer.m
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//

#import "GamePlayLayer.h"
#import "PlayerShip.h"
#import "Heart.h"
#import "CancerCell.h"
#import "GJCollisionBitmap.h"
#import "Constants.h"
#import "HudLayer.h"
#import "LightLayer.h"


@interface GamePlayLayer ()
@property (nonatomic, strong) GJCollisionBitmap *collisionMask;
@end

@implementation GamePlayLayer {
    CGSize screenSize;
}

@synthesize batchNode;
@synthesize playerShip;
@synthesize heart;
@synthesize tileLayer;


+(CCScene*)scene
{
	CCScene *scene = [CCScene node];

	HudLayer *hudLayer = [[HudLayer alloc]init];
	[scene addChild:hudLayer z:kHudZ];
    
    LightLayer *lightLayer = [[LightLayer alloc]init];
	[scene addChild:lightLayer z:kLightZ];

    GamePlayLayer* gamePlayLayer = [[GamePlayLayer alloc] initWithGame];
    [scene addChild:gamePlayLayer z:kGameZ];
    
    gamePlayLayer.playerShip.hud= hudLayer;
    gamePlayLayer.playerShip.collision= gamePlayLayer.collisionMask;
    
	return scene;
}

-(void)setupPlayerShip {
    
    playerShip = [PlayerShip createWithLayer:self];
    playerShip.position = ccp(0, 0);
    [batchNode addChild:playerShip z:kPlayerShipZ];
    
    CGRect followBoundary = CGRectMake(-(MAP_WIDTH/2), -(MAP_HEIGHT/2), MAP_WIDTH, MAP_HEIGHT);

    CCFollow* followAction = [CCFollow actionWithTarget:playerShip worldBoundary:followBoundary];
    [self runAction:followAction];
}

-(void)setupBackground {
    
    tileLayer = [[TileMapLayer alloc]init];
    tileLayer.position = ccp(-MAP_WIDTH/2, -MAP_HEIGHT/2);
    [self addChild:tileLayer z:kBackgroundZ];
    
}

-(void)setupCancerCells {
    self.cancerCells= [[CancerCollection alloc] initWithLayer:self andCollisionMask:self.collisionMask];
    [self.cancerCells seed];
}

-(void)setupCollisionMask {

    NSURL *collisionURL = [[NSBundle mainBundle] URLForResource:@"Collision" withExtension:@"bm"];
    NSData *data= [NSData dataWithContentsOfURL:collisionURL];
    self.collisionMask= [[GJCollisionBitmap alloc] initWithWidth:MAP_WIDTH height:MAP_HEIGHT
                                                     bytesPerRow:MAP_WIDTH/8 andData:data];
}

-(void)setupBatchNode {
    
    // pre load the sprite frames from the texture atlas
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"NanoCommando.plist"];
    
    // setup batchNode
    CCLOG(@"Setting up batchNode");
    batchNode = [CCSpriteBatchNode batchNodeWithFile:@"NanoCommando.pvr.ccz" capacity:2000];
    [self addChild:batchNode z:kBatchNodeZ];
}

-(void)setupHeart {
    
    heart = [Heart createWithLayer:self];
    heart.position = ccp(0, 0);
    [batchNode addChild:heart z:kHeartZ];
    
}


//-(id) initWithTileLayer:(TileMapLayer *)tileLayer {
-(id) initWithGame {
    if ((self = [super init])) {
        
        screenSize = [CCDirector sharedDirector].screenSize;
    
        [self setupBatchNode];
        [self setupBackground];
        [self setupHeart];
        [self setupPlayerShip];
        [self setupCollisionMask];
        [self setupCancerCells];
        [self scheduleUpdate];
        
    }
    return self;
}

-(void)update:(ccTime)delta {
    [self.cancerCells update:delta];
}

-(CGPoint)screenPointToWorldPoint:(CGPoint)point
{
    return ccpSub(point, self.position);
}
@end