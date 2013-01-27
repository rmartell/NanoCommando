//
//  HudLayer.m
//  NanoCommando
//
//  Created by Mark Adkins-hastings on 1/26/13.
//
//

#import "HudLayer.h"

@implementation HudLayer

@synthesize panSprite;
@synthesize panSprite2;
@synthesize startpan;
@synthesize startpos;
@synthesize theta;
@synthesize throttle;

-(id) init {
    if(self=[super init])
    {
        self.panSprite = [CCSprite spriteWithFile:@"thumbstickcenter.png"];
        panSprite.position = ccp(300,300);
        [self addChild:panSprite];
        
        self.panSprite2 = [CCSprite spriteWithFile:@"thumbstickedge.png"];
        panSprite2.position = ccp(350,300);
        [self addChild:panSprite2];
        
        self.startpos = ccp(0,0);
        self.startpan = true;
        self.theta = 0.0;
        self.throttle = 0.0;
        panSprite.visible = false;
        panSprite2.visible = false;
        
        [self setupTouchZones];
        CCLOG(@"==========INIT CALLED===========");
        [self scheduleUpdate];
    }
    return self;
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


-(CGPoint)adjustPoint:(CGPoint)pt toMaximumRadius:(float)r fromCenter:(CGPoint)center
{
    float dx= pt.x-center.x;
    float dy= pt.y - center.y;
    if((dx*dx + dy*dy)>r*r) {
        // calculate the sin/cosine, then move it out that far..
        // tan would give us the angle directly, but it wouldn't like have the correct hemisphere.
        float r2= sqrt(dx*dx + dy*dy);
        float theta= asin(dy/r2);
        pt.y= r*sin(theta) + center.y;
        
        theta= acos(dx/r2);
        pt.x= r*cos(theta) + center.x;
    }
    
    return pt;
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
    double lenx;
    double leny;
    double maxlen = 50;
    
    // What gesture we doin
    if (input.gesturePanBegan) {
        // show pan move control
        if (self.startpan) {
            self.startpan = false;
            self.startpos = ccp(input.gesturePanLocation.x, input.gesturePanLocation.y);
            panSprite.visible = true;
            panSprite2.visible = true;
        }
        
        panSprite2.position = self.startpos;
        panSprite.position = ccp(input.gesturePanLocation.x, input.gesturePanLocation.y);
        lenx = panSprite.position.x - panSprite2.position.x;
        leny = panSprite.position.y - panSprite2.position.y;
        
        double c = sqrt(lenx*lenx+leny*leny);
        
        self.theta = atan2(leny, lenx);
        if (self.theta < 0) {
            self.theta = 2*M_PI + self.theta;
        }
        
        //#if false
        //    CCARRAY_FOREACH(touches, touch) {
        //        CGPoint location = touch.location;
        //        //CCLOG(@"Real touch location is at: %f, %f", location.x, location.y);
        //        CGPoint screenCenter = ccp(screenSize.width/2, screenSize.height/2);
        //        float relativeX = location.x - screenCenter.x;
        //        float relativeY = location.y - screenCenter.y;
        //        //CCLOG(@"Relative touch location is at: %f, %f", relativeX, relativeY);
        //        //CCLOG(@"PlayerShip is at %f, %f", playerShip.position.x, playerShip.position.y);
        //        CGPoint relativeLocation = ccp(relativeX, relativeY);
        //
        //
        //        if (touch.phase == KKTouchPhaseBegan) {
        //            [playerShip moveBy:relativeLocation];
        //
        //        } else if (touch.phase == KKTouchPhaseStationary) {
        //
        //        } else if (touch.phase == KKTouchPhaseEnded) {
        //        }
        //#endif
        panSprite.rotation = self.theta*-58-90;
        
        
        panSprite.position = [self adjustPoint:panSprite.position toMaximumRadius:25.0 fromCenter:panSprite2.position];
        
        if (c >= maxlen) {
            self.throttle = 1;
        } else {
            self.throttle = c/50;
        }
        
        
        
#if DEBUG
        CCLOG(@"panSprite.position: %f,%f\nself.theta: %f\nself.throttle: %f", panSprite.position.x, panSprite.position.y, self.theta, self.throttle);
#endif
    }
    else if (input.gestureTapRecognizedThisFrame) {
        // do some deployment
        panSprite.position = ccp(input.gestureTapLocation.x, input.gestureTapLocation.y);
#if DEBUG
        CCLOG(@"gesture tap: %f,%f", panSprite.position.x, panSprite.position.y);
#endif
    }
    
    else if (!input.gesturePanBegan && !self.startpan) {
#if DEBUG
        CCLOG(@"TOUCH ENDED---------");
#endif
        panSprite.visible = false;
        panSprite2.visible = false;
        self.startpan = true;
    }
}

-(void)update:(ccTime)delta {
    [self processTouches:delta];
    
    //  [self positionLayerWithPlayer];
}

@end
