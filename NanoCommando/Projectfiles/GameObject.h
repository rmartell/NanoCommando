//
//  GameObject.h
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//
//

#import "GamePlayLayer.h"
#import "cocos2d.h"

@interface GameObject : CCSprite

-(id) initWithSprite:(NSString*)spriteName andLayer:(GamePlayLayer*)layer;



@end
