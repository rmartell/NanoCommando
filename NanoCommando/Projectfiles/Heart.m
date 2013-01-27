//
//  Heart.m
//  NanoCommando
//
//  Created by Grillaface on 1/27/13.
//
//

#import "Heart.h"

@implementation Heart {
    CGSize screenSize;
    CCAction* normalAnimation;
}

-(void)setupAnimation {
    
    id normalAnim = [CCAnimation animationWithFrames:@"heart" frameCount:6 delay:0.25f];
    normalAnimation = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:normalAnim]];
    
}

-(id) initWithGameLayer:(GamePlayLayer*)layer
{
	if ((self = [super initWithSprite:@"heart0" andLayer:layer]))
	{
        
        screenSize = [CCDirector sharedDirector].screenSize;        

        [self setupAnimation];
        [self runAction:normalAnimation];
        
	}
	return self;
}

+(id) createWithLayer:(GamePlayLayer*)layer
{
	id heart= [[self alloc] initWithGameLayer:layer];
    
	return heart;
}


@end
