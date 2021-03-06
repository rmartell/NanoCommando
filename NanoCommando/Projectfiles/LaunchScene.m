//
//  LaunchScene.m
//  NanoCommando
//
//  Created by Grillaface on 1/27/13.
//
//

#import "LaunchScene.h"
#import "GameManger.h"
#import "SoundManager.h"

@implementation LaunchScene


+(CCScene*)scene {
    
    CCScene* scene = [CCScene node];
    LaunchScene* layer = [[LaunchScene alloc] init];
    [scene addChild:layer];
    return scene;
}

-(id)init {
    if ((self = [super init])) {
        
        CCLOG(@"Welcome to the splash screen");
        [SoundManager sharedSoundManager];
        
        //CGSize screenSize = [CCDirector sharedDirector].screenSize;
        [self scheduleOnce:@selector(showNextScreen) delay:1.0f];
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"NanoCommando.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MenuSpriteSheet.plist"];
        
        CCSprite* backgroundImage = [CCSprite spriteWithFile:@"startupscreen.png"];
        backgroundImage.position = [CCDirector sharedDirector].screenCenter;
        [self addChild:backgroundImage];
        
    }
    return self;
}

-(void)showNextScreen {
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}


@end
