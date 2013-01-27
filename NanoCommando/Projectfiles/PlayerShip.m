//
//  PlayerShip.m
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//
//

#import "PlayerShip.h"
#import "HudLayer.h"

// Maximum velocity in world units/second
#define MAXIMUM_VELOCITY (300)

@interface PlayerShip ()
@property (nonatomic, assign) float desiredTheta;
@property (nonatomic, assign) CGPoint desiredVelocity;
@property (nonatomic, assign) CGPoint velocity;
@end

@implementation PlayerShip {
    CGSize screenSize;
    CCAction* normalAnimation;
}

-(void)setupAnimation {
    
    id normalAnim = [CCAnimation animationWithFrames:@"ship" frameCount:16 delay:(float)1.0/6.0];
    normalAnimation = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:normalAnim]];
    
}

-(id) initWithGameLayer:(GamePlayLayer*)layer
{
	if ((self = [super initWithSprite:@"ship0" andLayer:layer]))
	{
        
        screenSize = [CCDirector sharedDirector].screenSize;
        
//        self.scale= 0.5;
        [self scheduleUpdate];
        [self setupAnimation];
        
        [self runAction:normalAnimation];
        
	}
	return self;
}

+(id) createWithLayer:(GamePlayLayer*)layer
{
	id playerShip= [[self alloc] initWithGameLayer:layer];
    
	return playerShip;
}


-(void)update:(ccTime)delta {
    // update theta
    // instantaneous for now.
    float currentRotationTheta= self.hud.theta;
    self.rotation= 360 - RADIANS_TO_DEGREES(currentRotationTheta) - 90;
    
    // update velocity
    float velocityMag= MAXIMUM_VELOCITY*self.hud.throttle;
    self.velocity= CGPointMake(
                               velocityMag*cos(currentRotationTheta),
                               velocityMag*sin(currentRotationTheta));

    // update position
    CGPoint newPosition= CGPointMake(
                                     self.position.x + delta*self.velocity.x,
                                     self.position.y + delta*self.velocity.y);

    // collision test on newPosition
    
    self.position= newPosition;
}



@end
