//
//  PowerUpCollection.m
//  NanoCommando
//
//  Created by Ryan Martell on 1/27/13.
//
//

#import "PowerUpCollection.h"

#define SPAWN_POWERUPS_TIME (6.0)
#define SPAWN_POWERUP_CHANCE (0.65)

@interface PowerUpCollection ()
@property (nonatomic, strong) NSMutableArray *powerups;
@property (nonatomic, weak) GamePlayLayer *layer;
@property (nonatomic, strong) NSString *powerupFrameName;
@property (nonatomic, assign) NSTimeInterval lastUpdateTime;
@end

@interface PowerUp ()
@property (nonatomic, weak) GamePlayLayer *layer;
@end

@implementation PowerUp : GameObject
-(id)initWithGameLayer:(GamePlayLayer *)layer andFrameName:(NSString *)frameName
{
	if ((self = [super initWithSprite:frameName andLayer:layer]))
	{
        self.scale= 10;
        self.layer= layer;
	}
	return self;
}

-(void)pickup
{
    [self removeFromParentAndCleanup:YES];

    [self.layer.powerups.powerups removeObject:self];
}
@end

@implementation PowerUpCollection
-(id)initWithLayer:(GamePlayLayer *)layer
{
    if(self= [super init])
    {
        self.powerups= [NSMutableArray arrayWithCapacity:10];
        self.layer= layer;
        
        self.powerupFrameName = @"Turret_drop"; // FIXME
    }
    
    return self;
}

-(void)addPowerUpOfType:(PowerUpType)type atPoint:(CGPoint)pt
{
    PowerUp *powerup= [[PowerUp alloc] initWithGameLayer:self.layer andFrameName:self.powerupFrameName];
    powerup.position= pt;
    powerup.type= type;
    
    [self.layer.batchNode addChild:powerup z:kPowerUpZ];
    [self.powerups addObject:powerup];
    NSLog(@"Dropped powerup at %@", NSStringFromCGPoint(pt));
}

-(void)update:(ccTime)ticksPassed
{
    if([NSDate timeIntervalSinceReferenceDate] - self.lastUpdateTime > SPAWN_POWERUPS_TIME)
    {
        if(rand()%100<SPAWN_POWERUP_CHANCE*100)
        {
            // find a random one to seed.
            CGPoint seed_pts[]= {
                CGPointMake(-2031, -1405),
                CGPointMake(-2006, -381.134),
                CGPointMake(-2025, 152.49),
                CGPointMake(-2034, 1087.51),
                CGPointMake(-680, 1520),
                CGPointMake(126, 1533),
                CGPointMake(565, 1501),
                CGPointMake(1249, 1500),
                CGPointMake(1997, 763),
                CGPointMake(2016, -384),
                CGPointMake(2028, -1330),
                CGPointMake(1076, -1473),
                CGPointMake(101, -1481),
                CGPointMake(-827, -1502),
                CGPointMake(-1146, -1525)
            };
            
            int randIndex= rand()%ARRAY_SIZE(seed_pts);
            for(int ii= 0; ii<ARRAY_SIZE(seed_pts); ii++)
            {
                int actualIndex = (randIndex+ii)%ARRAY_SIZE(seed_pts);
                if([self powerupsInRange:50 ofPoint:seed_pts[actualIndex]].count==0)
                {
                    [self addPowerUpOfType:kPowerUpTurret atPoint:seed_pts[actualIndex]];
                    break;
                }
            }
        }
        self.lastUpdateTime= [NSDate timeIntervalSinceReferenceDate];
    }
}

-(NSArray *)powerupsInRange:(float)range ofPoint:(CGPoint)pt
{
    NSMutableArray *results= [NSMutableArray arrayWithCapacity:10];
    for(PowerUp *pu in self.powerups)
    {
        if(distance_between_points(pt, pu.position)<range)
        {
            [results addObject:pu];
        }
    }
    
    return results;
}
@end
