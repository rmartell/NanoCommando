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
        //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4e444];
        CCSprite *ls= [CCSprite spriteWithFile:@"superlamp.png"];
        
        CGSize screenSize;
        screenSize = [CCDirector sharedDirector].screenSize;
        
        ls.position = ccp(screenSize.width/2,screenSize.height/2);
        
        [self addChild:ls];
        self.lampSprite = ls;
        
        //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
    }
    return self;
}

@end
