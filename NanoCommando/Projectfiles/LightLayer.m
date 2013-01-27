//
//  LightLayer.m
//  NanoCommando
//
//  Created by Mark Adkins-hastings on 1/27/13.
//
//

#import "LightLayer.h"

@implementation LightLayer

@synthesize lampSprite;

-(id) init {
    if(self=[super init])
    {
        //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        self.lampSprite = [CCSprite spriteWithFile:@"superlamp.png"];
        
        CGSize screenSize;
        screenSize = [CCDirector sharedDirector].screenSize;
        
        lampSprite.position = ccp(screenSize.width/2,screenSize.height/2);
        
        [self addChild:lampSprite];
        
        //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
    }
    return self;
}

@end
