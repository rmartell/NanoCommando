//
//  PlayerShip.m
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//
//

#import "PlayerShip.h"
#import "HudLayer.h"
#import "Turret.h"
#import "GJCollisionBitmap.h"

// Maximum velocity in world units/second
#define MAXIMUM_VELOCITY (300)
#define VELOCITY_CHANGE_PER_SECOND (600)

@interface PlayerShip ()
@property (nonatomic, assign) float desiredTheta;
@property (nonatomic, assign) float currentSpeed;
@property (nonatomic, assign) CGPoint desiredVelocity;
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, weak) GamePlayLayer *layer;
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
        self.layer= layer;
        [self scheduleUpdate];
        [self setupAnimation];
        
        [self runAction:normalAnimation];
        
        [self schedule:@selector(logPosition) interval:5.0f];
        
	}
	return self;
}

+(id) createWithLayer:(GamePlayLayer*)layer
{
	id playerShip= [[self alloc] initWithGameLayer:layer];
    
	return playerShip;
}

-(void)logPosition {
    CCLOG(@"-----player ship is at %f %f", self.position.x, self.position.y);
}


-(void)update:(ccTime)delta {
    // update theta
    // instantaneous for now.
    float currentRotationTheta= self.hud.theta;
    self.rotation= 360 - RADIANS_TO_DEGREES(currentRotationTheta) - 90;
    
    // update velocity
    float desiredSpeed= MAXIMUM_VELOCITY*self.hud.throttle;
    float speedDelta= delta*VELOCITY_CHANGE_PER_SECOND;
    
    if(desiredSpeed < self.currentSpeed)
    {
        self.currentSpeed= fmaxf(self.currentSpeed - speedDelta, desiredSpeed);
    } else {
        self.currentSpeed= fminf(self.currentSpeed + speedDelta, desiredSpeed);
    }
    
    self.velocity= CGPointMake(
                               self.currentSpeed*cos(currentRotationTheta),
                               self.currentSpeed*sin(currentRotationTheta));

    // update position
    CGPoint newPosition= CGPointMake(
                                     self.position.x + delta*self.velocity.x,
                                     self.position.y + delta*self.velocity.y);

    // collision test on newPosition
    if(![self.collision ptInside:newPosition])
    {
        // don't allow for now..
        self.position= newPosition;
    }
    
    if(self.hud.deploy)
    {
        [self.layer.turrets addTurretAtPoint:self.hud.deployAt];
        self.hud.deploy = false;
    }
    
}



@end
