//
//  GamePlayLayer.m
//  NanoCommando
//
//  Created by Grillaface on 1/26/13.
//

#import "GamePlayLayer.h"
#import "PlayerShip.h"
#import "CancerCell.h"
#import "GJCollisionBitmap.h"


@interface GamePlayLayer ()
@property (nonatomic, strong) GJCollisionBitmap *collisionMask;
@end

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
        
        NSURL *collisionURL = [[NSBundle mainBundle] URLForResource:@"Collision" withExtension:@"bm"];
        NSData *data= [NSData dataWithContentsOfURL:collisionURL];
        self.collisionMask= [[GJCollisionBitmap alloc] initWithWidth:MAP_WIDTH height:MAP_HEIGHT
                                                         bytesPerRow:MAP_WIDTH/8 andData:data];
        
        self.cancerCells= [[CancerCollection alloc] initWithLayer:self andCollisionMask:self.collisionMask];
        [self.cancerCells seed];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)update:(ccTime)ticks
{
    [self.cancerCells update:ticks];
}
@end
