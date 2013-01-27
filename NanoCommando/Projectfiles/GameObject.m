//
//  GameObject.m
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//
//

#import "GameObject.h"

@implementation GameObject {
    CGSize screenSize;
}

-(id) initWithSprite:(NSString*)spriteName andLayer:(GamePlayLayer *)layer
{
    
    screenSize = [CCDirector sharedDirector].screenSize;
    
    NSString* filename = [NSString stringWithFormat:@"%@.png",spriteName];
    self = [super initWithSpriteFrameName:filename];
    if (self) {
    }
    return self;
}



@end
