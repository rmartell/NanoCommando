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
}

-(id) initWithGameLayer:(GamePlayLayer*)layer
{
	if ((self = [super initWithSprite:@"TestShip" andLayer:layer]))
	{
        
        screenSize = [CCDirector sharedDirector].screenSize;
        
        self.maxVelocity = 200;
        self.maxAcceleration = 200;
        
        [self scheduleUpdate];
        
        
	}
	return self;
}

+(id) createWithLayer:(GamePlayLayer*)layer
{
	id playerShip= [[self alloc] initWithGameLayer:layer];
	return playerShip;
}

-(void)update:(ccTime)delta {
    [self updateMove:delta];
    
}



@end
