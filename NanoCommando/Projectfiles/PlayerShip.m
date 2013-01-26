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
}

-(id) initWithGameLayer:(GamePlayLayer*)layer
{
	if ((self = [super initWithSprite:@"TestShip" andLayer:layer]))
	{
        
        screenSize = [CCDirector sharedDirector].screenSize;
        
        [self scheduleUpdate];
        
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
