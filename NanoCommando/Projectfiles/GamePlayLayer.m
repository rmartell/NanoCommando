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


@interface GamePlayLayer ()
@property (nonatomic, strong) GJCollisionBitmap *collisionMask;
@end

@implementation GamePlayLayer {
    CGSize screenSize;
}

@synthesize playerShip;
@synthesize tileLayer;

+(CCScene*)scene
{
	CCScene *scene = [CCScene node];
//	TileMapLayer *tileLayer = [[TileMapLayer alloc]init];
//	[scene addChild:tileLayer];
    GamePlayLayer* gamePlayLayer = [[GamePlayLayer alloc]initWithGame];
    [scene addChild:gamePlayLayer];
    
	return scene;
}

-(void)setupPlayerShip {
    
    playerShip = [PlayerShip createWithLayer:self];
    playerShip.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:playerShip z:kPlayerShipZ];
    
    CGRect followBoundary = CGRectMake(-2*screenSize.width, -2*screenSize.height, 4*screenSize.width, 4*screenSize.height);
    CCFollow* followAction = [CCFollow actionWithTarget:playerShip worldBoundary:followBoundary];
    [self runAction:followAction];
    
    
}

-(void) setupTouchZones {
    
    [KKInput sharedInput].multipleTouchEnabled = YES;
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
        
        CCSprite* dummy = [CCSprite spriteWithFile:@"game-events.png"];
        dummy.position = ccp(screenSize.width/3,screenSize.height/3);
        [self addChild:dummy z:kGameObjectsZ];
        
        [self setupBackground];
        
        [self setupPlayerShip];
        [self setupTouchZones];
        
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
    [self processTouches:delta];
    [self.cancerCells update:delta];
    
  //  [self positionLayerWithPlayer];
}

//-(void)positionLayerWithPlayer {
    
   // self.position = playerShip.position;
    //[self.camera setCenterX:playerShip.position.x centerY:playerShip.position.y centerZ:0];
    //[self.camera setEyeX:playerShip.position.x eyeY:playerShip.position.y eyeZ:415];
//}


-(void)processTouches:(ccTime)delta {
    
    CCArray* touches = [KKInput sharedInput].touches;
    //    int numberOfTouches = [touches count];
    
    KKTouch* touch;
    
    CCARRAY_FOREACH(touches, touch) {
        CGPoint location = touch.location;
        //CCLOG(@"Real touch location is at: %f, %f", location.x, location.y);
        CGPoint screenCenter = ccp(screenSize.width/2, screenSize.height/2);
        float relativeX = location.x - screenCenter.x;
        float relativeY = location.y - screenCenter.y;
        //CCLOG(@"Relative touch location is at: %f, %f", relativeX, relativeY);
        //CCLOG(@"PlayerShip is at %f, %f", playerShip.position.x, playerShip.position.y);
        CGPoint relativeLocation = ccp(relativeX, relativeY);
        
        
        if (touch.phase == KKTouchPhaseBegan) {
            [playerShip moveBy:relativeLocation];
            
        } else if (touch.phase == KKTouchPhaseStationary) {
            
        } else if (touch.phase == KKTouchPhaseEnded) {
            
        }
    }
}
@end
