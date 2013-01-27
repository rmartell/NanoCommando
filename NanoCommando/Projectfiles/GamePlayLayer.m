//
//  GamePlayLayer.m
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//

#import "GamePlayLayer.h"
#import "PlayerShip.h"
#import "CancerCell.h"
#import "GJCollisionBitmap.h"
#import "Constants.h"
#import "HudLayer.h"


@interface GamePlayLayer ()
@property (nonatomic, strong) GJCollisionBitmap *collisionMask;
@end

@implementation GamePlayLayer {
    CGSize screenSize;
}

@synthesize batchNode;
@synthesize playerShip;
@synthesize tileLayer;


+(CCScene*)scene
{
	CCScene *scene = [CCScene node];
	HudLayer *hudLayer = [[HudLayer alloc]init];
	[scene addChild:hudLayer z:kHudZ];
    GamePlayLayer* gamePlayLayer = [[GamePlayLayer alloc]initWithGame];
    [scene addChild:gamePlayLayer z:kGameZ];
    
	return scene;
}

-(void)setupPlayerShip {
    
    playerShip = [PlayerShip createWithLayer:self];
    playerShip.position = ccp(screenSize.width/2, screenSize.height/2);
    [batchNode addChild:playerShip z:kPlayerShipZ];
    
    CGRect followBoundary = CGRectMake(-2*screenSize.width, -2*screenSize.height, 4*screenSize.width, 4*screenSize.height);
    
    CCFollow* followAction = [CCFollow actionWithTarget:playerShip worldBoundary:followBoundary];
    [self runAction:followAction];
    
    
}

-(void)setupBackground {
    
    tileLayer = [[TileMapLayer alloc]init];
    tileLayer.position = ccp(-2*screenSize.width, -2*screenSize.height);
    [self addChild:tileLayer z:kBackgroundZ];
    
}


//-(id) initWithTileLayer:(TileMapLayer *)tileLayer {
-(id) initWithGame {
    if ((self = [super init])) {
        
        screenSize = [CCDirector sharedDirector].screenSize;

        // pre load the sprite frames from the texture atlas
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"NanoCommando.plist"];
        
        // setup batchNode
        CCLOG(@"Setting up batchNode");
        batchNode = [CCSpriteBatchNode batchNodeWithFile:@"NanoCommando.pvr.ccz"];
        [self addChild:batchNode z:kBatchNodeZ];
        
        CCSprite* dummy = [CCSprite spriteWithFile:@"game-events.png"];
        dummy.position = ccp(screenSize.width/3,screenSize.height/3);
        [self addChild:dummy z:kGameObjectsZ];
        
        [self setupBackground];
        
        [self setupPlayerShip];
        
    
        
        NSURL *collisionURL = [[NSBundle mainBundle] URLForResource:@"Collision" withExtension:@"bm"];
        NSData *data= [NSData dataWithContentsOfURL:collisionURL];
        self.collisionMask= [[GJCollisionBitmap alloc] initWithWidth:MAP_WIDTH height:MAP_HEIGHT
                                                         bytesPerRow:MAP_WIDTH/8 andData:data];
        
        self.cancerCells= [[CancerCollection alloc] initWithLayer:self andCollisionMask:self.collisionMask];
        [self.cancerCells seed];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)update:(ccTime)delta {
    [self.cancerCells update:delta];
    
  //  [self positionLayerWithPlayer];
}


@end
