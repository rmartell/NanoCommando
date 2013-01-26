//
//  GamePlayLayer.m
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//

#import "GamePlayLayer.h"
#import "PlayerShip.h"


@implementation GamePlayLayer {
    CGSize screenSize;
}

@synthesize playerShip;

+(CCScene*)scene
{
	CCScene *scene = [CCScene node];
	TileMapLayer *tileLayer = [[TileMapLayer alloc]init];
	[scene addChild:tileLayer];
    GamePlayLayer* gamePlayLayer = [[GamePlayLayer alloc]initWithTileLayer:tileLayer];
    [scene addChild:gamePlayLayer];
    
	return scene;
}

-(void)setupPlayerShip {
    
    playerShip = [PlayerShip createWithLayer:self];
    playerShip.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:playerShip];
}

-(id) initWithTileLayer:(TileMapLayer *)tileLayer {
    if ((self = [super init])) {
        
        screenSize = [CCDirector sharedDirector].screenSize;
        
        //CCLabelTTF* hello = [CCLabelTTF labelWithString:@"blah" fontName:@"Helvetica" fontSize:60];
        //hello.position = ccp(screenSize.width/2, screenSize.height/2);
        //[self addChild:hello];
        [self setupPlayerShip];
        
        
        
    }
    return self;
}


@end