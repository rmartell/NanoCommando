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
#import "Turret.h"
#import "LightLayer.h"
#import "PowerUpCollection.h"
#import "GameManger.h"

@interface GamePlayLayer ()
@property (nonatomic, weak) LightLayer *lightLayer;
@property (nonatomic, assign) PlayerDeathState lastPlayerDeathState;
@end

@implementation GamePlayLayer {
    CGSize screenSize;
}

@synthesize batchNode;
@synthesize playerShip;
@synthesize heart;
@synthesize tileLayer;
@synthesize theHudLayer;


+(CCScene*)scene
{
	CCScene *scene = [CCScene node];

	HudLayer *hudLayer = [[HudLayer alloc]init];
	[scene addChild:hudLayer z:kHudZ];
    
    LightLayer *lightLayer = [[LightLayer alloc]init];
	[scene addChild:lightLayer z:kLightZ];

    GamePlayLayer* gamePlayLayer = [[GamePlayLayer alloc] initWithHUDLayer:hudLayer];
    [scene addChild:gamePlayLayer z:kGameZ];
    
    gamePlayLayer.playerShip.hud= hudLayer;
    gamePlayLayer.playerShip.collision= gamePlayLayer.collisionMask;
    gamePlayLayer.lightLayer= lightLayer;
    
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

-(void)setupPowerUps {
    self.powerups= [[PowerUpCollection alloc] initWithLayer:self];
}


-(void)setupTurrets {
    self.turrets= [[TurretCollection alloc] initWithLayer:self andCollisionMask:self.collisionMask];
    [self.turrets seed]; // this is NOOP once testing is complete
}

-(void)setupCollisionMask {

    NSURL *collisionURL = [[NSBundle mainBundle] URLForResource:@"Collision" withExtension:@"bm"];
    NSData *data= [NSData dataWithContentsOfURL:collisionURL];
    self.collisionMask= [[GJCollisionBitmap alloc] initWithWidth:MAP_WIDTH height:MAP_HEIGHT
                                                     bytesPerRow:MAP_WIDTH/8 andData:data];
}


-(void)setupBatchNode {
    
    // pre load the sprite frames from the texture atlas
    //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"NanoCommando.plist"];
    
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
-(id) initWithHUDLayer:(HudLayer*)HUDLayer {
    if ((self = [super init])) {
        
        screenSize = [CCDirector sharedDirector].screenSize;
        
        self.theHudLayer = HUDLayer;
    
        [self setupBatchNode];
        [self setupBackground];
        [self setupHeart];
        [self setupPlayerShip];
        [self setupCollisionMask];
        [self setupCancerCells];
        [self setupPowerUps];
        [self scheduleUpdate];
        [self setupTurrets];
        
        [HUDLayer setGameLayer:self];
    }
    return self;
}

-(void)update:(ccTime)delta {
    [self.cancerCells update:delta];
    [self.turrets update:delta];
    [self.powerups update:delta];
    
    if(self.playerShip.deathState != self.lastPlayerDeathState)
    {
        GLubyte red;
        switch(self.playerShip.deathState)
        {
            case PlayerDeathStateAlive: red= 0; break;
            case PlayerDeathStateWarning: red= 128; break;
            case PlayerDeathStateCritical: red= 255; break;
            case PlayerDeathStateDead: red= 255; break;
            default:break;
        }

        id action = [CCTintTo actionWithDuration:0.5 red:red green:0 blue:0];
        [self.lightLayer.lampSprite runAction:action];
        self.lastPlayerDeathState= self.playerShip.deathState;
    }
    
    if(self.playerShip.deathState==PlayerDeathStateDead)
    {
        [[GameManager sharedGameManager] runSceneWithID:kKillScene];
    }
}

-(CGPoint)screenPointToWorldPoint:(CGPoint)point
{
    return ccpSub(point, self.position);
}
@end