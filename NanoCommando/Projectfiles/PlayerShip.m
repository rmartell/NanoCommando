//
//  PlayerShip.m
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//
//

#import "PlayerShip.h"

@implementation PlayerShip {
    CGSize screenSize;
    
    CCMoveBy* moveAction;
    CCRotateBy* rotateAction;
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
        
        self.scale= 0.5;
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

-(void)moveBy:(CGPoint)vector {
    
    [moveAction stop];
    moveAction = [CCMoveBy actionWithDuration:1.0f position:vector];
    [self runAction:moveAction];
    
    NSLog(@"Current ship position: %@", NSStringFromCGPoint(self.position));
}

-(void)update:(ccTime)delta {

    
}



@end
