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
@synthesize panSprite;


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
    
    // Work with some particular gestures for ship control and movement
    if ([KKInput sharedInput].gesturesAvailable) {
        KKInput* input = [KKInput sharedInput];
        input.gestureTapEnabled = YES;
        //input.gestureDoubleTapEnabled = NO;
        //input.gestureLongPressEnabled = NO;
        //input.gestureSwipeEnabled = NO;
        input.gesturePanEnabled = YES;
        //input.gestureRotationEnabled = NO;
        //input.gesturePinchEnabled = NO;
#if DEBUG
        CCLOG(@"Gestures Available, %@", input);
#endif
    }
}


-(id) initWithTileLayer:(TileMapLayer *)tileLayer {
    if ((self = [super init])) {
        
        screenSize = [CCDirector sharedDirector].screenSize;

        self.panSprite = [CCSprite spriteWithFile:@"cancer.png"];
        panSprite.position = ccp(300,300);
        [self addChild:panSprite];


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
    
    KKInput* input = [KKInput sharedInput];
    //CCArray* touches = [KKInput sharedInput].touches;
    //    int numberOfTouches = [touches count];
    
//    KKTouch* touch;
//    
//    CCARRAY_FOREACH(touches, touch) {
//        CGPoint location = touch.location;
//        
//        if (touch.phase == KKTouchPhaseBegan) {
//            playerShip.destination = location;
//            
//        } else if (touch.phase == KKTouchPhaseStationary) {
//            
//        } else if (touch.phase == KKTouchPhaseEnded) {
//            
//        }
//    }
    
    // What gesture we doin
    if (input.gesturePanBegan) {
        // show pan move control
        panSprite.position = ccp(input.gesturePanLocation.x, input.gesturePanLocation.y);
        
#if DEBUG
        CCLOG(@"panSprite.position: %f,%f", panSprite.position.x, panSprite.position.y);
#endif
    }
    else if (input.gestureTapRecognizedThisFrame) {
        // do some deployment
        playerShip.destination = input.gestureTapLocation;
        panSprite.position = ccp(input.gestureTapLocation.x, input.gestureTapLocation.y);
#if DEBUG
        CCLOG(@"gesture tap: %f,%f", panSprite.position.x, panSprite.position.y);
#endif
    }
}



@end