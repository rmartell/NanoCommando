//
//  PowerUpCollection.m
//  NanoCommando
//
//  Created by Ryan Martell on 1/27/13.
//
//

#import "PowerUpCollection.h"
#import "SoundManager.h"

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
        self.scale= 1.5;
        self.layer= layer;
	}
	return self;
}

-(void)pickup
{
    [self removeFromParentAndCleanup:YES];

    [self.layer.powerups.powerups removeObject:self];
    
    [[SoundManager sharedSoundManager] playSound:kSoundPowerupPickup];
}
@end

@implementation PowerUpCollection
-(id)initWithLayer:(GamePlayLayer *)layer
{
    if(self= [super init])
    {
        self.powerups= [NSMutableArray arrayWithCapacity:10];
        self.layer= layer;
        
        self.powerupFrameName = @"Turret_Power_Up";
    }
    
    return self;
}

-(void)addPowerUpOfType:(PowerUpType)type atPoint:(CGPoint)pt
{
    PowerUp *powerup= [[PowerUp alloc] initWithGameLayer:self.layer andFrameName:self.powerupFrameName];
    powerup.position= pt;
    powerup.type= type;
    
    [[SoundManager sharedSoundManager] playSound:kSoundPowerupPing atPoint:pt];
    
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
                CGPointMake(-1.094042, 132.172775),
                CGPointMake(-138.877823, 34.268536),
                CGPointMake(3.735448, -128.770248),
                CGPointMake(132.889526, 53.498062),
                CGPointMake(435.893188, 716.664734),
                CGPointMake(-204.679276, 878.736511),
                CGPointMake(631.855652, -723.856201),
                CGPointMake(-463.391632, -714.683533),
                CGPointMake(1376.601562, 296.421906),
                CGPointMake(-870.966736, 12.253122),
                CGPointMake(-1483.273926, -126.869110),
                CGPointMake(-1567.962402, 793.779541),
                CGPointMake(-1675.728027, 1207.793945),
                CGPointMake(-776.062500, 1068.025757),
                CGPointMake(-224.600525, 871.530884),
                CGPointMake(29.772858, -877.352600),
                CGPointMake(1231.633545, -1109.238892),
                CGPointMake(1396.841309, -374.800232),
                CGPointMake(801.565369, -415.316467),
                CGPointMake(1306.285522, 748.267822),
                CGPointMake(-1484.598755, -715.762390)
            };
            
            int randIndex= rand()%ARRAY_SIZE(seed_pts);
            for(int ii= 0; ii<ARRAY_SIZE(seed_pts); ii++)
            {
                int actualIndex = (randIndex+ii)%ARRAY_SIZE(seed_pts);
                if([self powerupsInRange:50 ofPoint:seed_pts[actualIndex]].count==0)
                {
                    [self addPowerUpOfType:kPowerUpTurret atPoint:seed_pts[actualIndex]];
                    [[SoundManager sharedSoundManager] playSound:kSoundPowerupPing atPoint:seed_pts[actualIndex]];
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
