//
//  GamePlayLayer.m
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//

#import "GamePlayLayer.h"
#import "PlayerShip.h"


@implementation GamePlayLayer {
    CGSize screenSize;
}

@synthesize playerShip;

+(CCScene*)scene
{
	CCScene *scene = [CCScene node];
	TileMapLayer *tileLayer = [[TileMapLayer alloc]init];
	[scene addChild:tileLayer];
    GamePlayLayer* gamePlayLayer = [[GamePlayLayer alloc]initWithTileLayer:tileLayer];
    [scene addChild:gamePlayLayer];
    
	return scene;
}

-(void)setupPlayerShip {
    
    playerShip = [PlayerShip createWithLayer:self];
    playerShip.position = ccp(screenSize.width/2, screenSize.height/2);
    playerShip.destination = playerShip.position;
    [self addChild:playerShip];
    
    //CGRect followBoundary = CGRectMake(0, 0, 1000, 1000);
    //CCFollow* followAction = [CCFollow actionWithTarget:playerShip worldBoundary:followBoundary];
    //[self runAction:followAction];
    
    
}

-(void) setupTouchZones {
    
    [KKInput sharedInput].multipleTouchEnabled = YES;
}


-(id) initWithTileLayer:(TileMapLayer *)tileLayer {
    if ((self = [super init])) {
        
        screenSize = [CCDirector sharedDirector].screenSize;
        
        [self setupPlayerShip];
        [self setupTouchZones];
        
        [self scheduleUpdate];
        
        
    }
    return self;
}

-(void)update:(ccTime)delta {
    [self processTouches:delta];
}


-(void)processTouches:(ccTime)delta {
    
    CCArray* touches = [KKInput sharedInput].touches;
    //    int numberOfTouches = [touches count];
    
    KKTouch* touch;
    
    CCARRAY_FOREACH(touches, touch) {
        CGPoint location = touch.location;
        
        if (touch.phase == KKTouchPhaseBegan) {
            playerShip.destination = location;
            
        } else if (touch.phase == KKTouchPhaseStationary) {
            
        } else if (touch.phase == KKTouchPhaseEnded) {
            
        }
    }
}



@end