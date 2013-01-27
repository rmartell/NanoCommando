//
//  Turret.m
//  NanoCommando
//
//  Created by Ryan Martell on 1/26/13.
//
//

#import "Turret.h"
#import "GJCollisionBitmap.h"

@interface TurretCollection ()
@property (nonatomic, strong) NSMutableArray *turrets;
@property (nonatomic, weak) GamePlayLayer *layer;
@property (nonatomic, weak) GJCollisionBitmap *collision;
@property (nonatomic, assign) NSTimeInterval lastUpdate;
@property (nonatomic, strong) NSString *textureFrameName;
@end

@implementation Turret
-(id)initWithGameLayer:(GamePlayLayer *)layer andFrameName:(NSString *)frameName
{
	if ((self = [super initWithSprite:frameName andLayer:layer]))
	{
        [self scheduleUpdate];
	}
	return self;
}
@end


@implementation TurretCollection
-(id)initWithLayer:(GamePlayLayer *)layer andCollisionMask:(GJCollisionBitmap *)bitmap
{
    if(self= [super init])
    {
        self.turrets= [NSMutableArray arrayWithCapacity:10];
        self.layer= layer;
        self.collision= bitmap;
        
        self.textureFrameName = @"Turret0.png";
        //  self.cancerLive= [[CCTextureCache sharedTextureCache] addImage: @"CancerCell.png"];
        //self.cancerDormant= [[CCTextureCache sharedTextureCache] addImage: @"CancerCellInside.png"];
    }
    
    return self;
}

-(void)addTurretAtPoint:(CGPoint)pt
{
    //    CancerCell *cell= [[CancerCell alloc] initWithGameLayer:self.layer andTexture:self.cancerLive];
    Turret *turret= [[Turret alloc] initWithGameLayer:self.layer andFrameName:self.textureFrameName];
    turret.position= pt;

    [self.layer.batchNode addChild:turret z:kTurretZ];
    [self.turrets addObject:turret];
//    [array addObject:cell];
}

-(void)update:(ccTime)ticksPassed
{
    
}

-(void)seed
{
    
}
@end