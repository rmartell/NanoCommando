//
//  Turret.m
//  NanoCommando
//
//  Created by Ryan Martell on 1/26/13.
//
//

#import "Turret.h"
#import "GJCollisionBitmap.h"
#import "CancerCell.h"
#import "SoundManager.h"

@interface TurretCollection ()
@property (nonatomic, strong) NSMutableArray *turrets;
@property (nonatomic, strong) NSMutableArray *bullets;
@property (nonatomic, weak) GamePlayLayer *layer;
@property (nonatomic, weak) GJCollisionBitmap *collision;
@property (nonatomic, assign) NSTimeInterval lastUpdate;
@property (nonatomic, strong) NSString *textureFrameName;
@property (nonatomic, strong) NSString *bulletFrameName;

-(void)fireFromPoint:(CGPoint)pt withVector:(CGPoint)v ofType:(int)type;
@end

typedef enum  {
    kStateIdle,
    kStateTurningTowardsTarget,
    kStateFiring,
    kStateCooldown
} TurretState;

#define TURRET_COOLDOWN_SECONDS (0.5)
#define TURRET_RANGE (500)
#define TURRET_SECONDS_FOR_COMPLETE_REVOLUTION (1.0)
#define TURRET_ROTATIONAL_VELOCITY (360.0/TURRET_SECONDS_FOR_COMPLETE_REVOLUTION)
#define BULLET_VELOCITY (700)

@interface Turret ()
@property (nonatomic, assign) TurretState state;
@property (nonatomic, assign) CGPoint target;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, weak) GamePlayLayer *layer;
@property (nonatomic, assign) int weaponType;
@end

@interface Bullet : GameObject
@property (nonatomic, assign) int bulletType;
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) BOOL dead;
@property (nonatomic, weak) GamePlayLayer *layer;
@end

@implementation Bullet
-(id)initWithGameLayer:(GamePlayLayer *)layer andFrameName:(NSString *)frameName
{
	if ((self = [super initWithSprite:frameName andLayer:layer]))
	{
        self.scale= 3;
        self.layer= layer;
	}
	return self;
}

-(void)update:(ccTime)ticksElapsed
{
    CGPoint newPoint= CGPointMake(
                                  self.position.x + ticksElapsed*self.velocity.x,
                                  self.position.y + ticksElapsed*self.velocity.y
                                  );
    
    if([self.layer.collisionMask ptInside:newPoint])
    {
        self.dead= YES;
    } else {
        // compare with the cells.
        NSArray *cells= [self.layer.cancerCells cellsIntersectedByLineSegmentStart:self.position end:newPoint];
        if(cells.count)
        {
            CancerCell *cell= [cells objectAtIndex:0];
            [cell die];
            // and we're done
            self.dead= YES;
        } else {
            self.position= newPoint;
        }
    }
}
@end

@implementation Turret
-(id)initWithGameLayer:(GamePlayLayer *)layer andFrameName:(NSString *)frameName
{
	if ((self = [super initWithSprite:frameName andLayer:layer]))
	{
        self.state= kStateIdle;
        self.layer= layer;
        self.scale= 2.0;
	}
	return self;
}

-(NSString *)nameForState:(int)state
{
    switch(state)
    {
        case kStateIdle: return @"Idle"; break;
        case kStateTurningTowardsTarget: return @"Turning"; break;
        case kStateFiring: return @"Firing"; break;
        case kStateCooldown: return @"Cooldown"; break;
    }
    return @"Unknown";
}
-(void)update:(ccTime)ticksPassed
{
    int newState= self.state;
    switch(self.state)
    {
        case kStateIdle:
            // find a target...
            if([self findTarget])
            {
                newState= kStateTurningTowardsTarget;
            } else {
                newState= kStateCooldown;
            }
            break;
        case kStateTurningTowardsTarget:
            if([self turnTowardsTarget:ticksPassed])
            {
                newState= kStateFiring;
            }
            break;
        case kStateFiring:
            [self fire];
            newState= kStateCooldown;
            break;
            
        case kStateCooldown:
            if([NSDate timeIntervalSinceReferenceDate] - self.startTime > TURRET_COOLDOWN_SECONDS)
            {
                newState= kStateIdle;
            }
            break;
    }
    
    if(newState != self.state)
    {
#if false
        NSLog(@"Turret at %@ state: %@ new state: %@",
              self,
              [self nameForState:self.state],
              [self nameForState:newState]);
#endif
        self.state= newState;
        self.startTime= [NSDate timeIntervalSinceReferenceDate];
    }
}


-(BOOL)findTarget
{
    BOOL foundTarget= NO;
    
    NSArray *possibleTargets= [self.layer.cancerCells cancerCellsInRange:TURRET_RANGE ofPoint:self.position];
    if(possibleTargets.count)
    {
        CCSprite *target= [possibleTargets objectAtIndex:(rand()%[possibleTargets count])];
        self.target= target.position;
        foundTarget= YES;
    }
    
    return foundTarget;
}

-(BOOL)turnTowardsTarget:(ccTime)ticksElapsed
{
    BOOL matched_bearing= NO;
    float desiredRotation= fmod(REAL_THETA_TO_COCOS_DEGREES(cc_radians_between_points(self.position, self.target))+180.0, 360);
    float rotationDeltaDegrees = ticksElapsed * TURRET_ROTATIONAL_VELOCITY;
    float newRotation= self.rotation;


#if true
    
    // this will not always turn in the optimal direction (FIXME)
    if(desiredRotation > self.rotation)
    {
        newRotation= fminf(self.rotation+rotationDeltaDegrees, desiredRotation);
    } else {
        newRotation= fmaxf(self.rotation-rotationDeltaDegrees, desiredRotation);
    }
#else
    // this is broken, and I've wated too much time on it already..
    // should we turn clockwise or counterclockwise?
    float dx = self.target.x - self.position.x;
    float dy = self.target.y - self.position.y;
    
    float cp= dx*sin(DEGREES_TO_RADIANS(self.rotation)) + dy *cos(DEGREES_TO_RADIANS(self.rotation));
    while(rotationDeltaDegrees>0)
    {
        if(cp<0)
        {
//            NSLog(@"Clockwise! Target: %f, Current: %f", desiredRotation, self.rotation);
            newRotation = ((int)(newRotation +  1)+360)%360;
        } else {
//            NSLog(@"AntiClockwise! Target: %f, Current: %f", desiredRotation, self.rotation);
            newRotation = ((int)(newRotation -  1)+360)%360;
        }
        if((((int)(newRotation - desiredRotation)+360)%360)<2)
        {
            newRotation= desiredRotation;
            break;
        }
        rotationDeltaDegrees-= 1.0;
    }
#endif
    
#if false
    NSLog(@"Turret %@ turning towards %lf (current: %lf) New: %lf Elapsed: %lf", self, desiredRotation, self.rotation, newRotation, ticksElapsed);
#endif

    self.rotation= newRotation;
    if(self.rotation==desiredRotation)
    {
        matched_bearing= YES;
    }

    return matched_bearing;
}

-(void)fire
{
    float theta= cc_radians_between_points(self.position, self.target);
    
    CGPoint vector= CGPointMake(
                                BULLET_VELOCITY*cos(theta),
                                BULLET_VELOCITY*sin(theta)
    );

    [self.layer.turrets fireFromPoint:self.position withVector:vector ofType:self.weaponType];
}

@end


@implementation TurretCollection
-(id)initWithLayer:(GamePlayLayer *)layer andCollisionMask:(GJCollisionBitmap *)bitmap
{
    if(self= [super init])
    {
        self.turrets= [NSMutableArray arrayWithCapacity:10];
        self.bullets= [NSMutableArray arrayWithCapacity:10];
        self.layer= layer;
        self.collision= bitmap;
        
        self.textureFrameName = @"Turret_drop";
        self.bulletFrameName= @"bullet";
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
}

-(void)update:(ccTime)ticksPassed
{
    for(Turret *turret in self.turrets)
    {
        [turret update:ticksPassed];
    }
    
    NSMutableArray *deadBullets= [NSMutableArray arrayWithCapacity:10];
    for(Bullet *bullet in self.bullets)
    {
        [bullet update:ticksPassed];
        if(bullet.dead)
        {
            [bullet removeFromParentAndCleanup:YES];
            [deadBullets addObject:bullet];
        }
    }
    [self.bullets removeObjectsInArray:deadBullets];
}

-(void)fireFromPoint:(CGPoint)pt withVector:(CGPoint)v ofType:(int)type
{
    //    CancerCell *cell= [[CancerCell alloc] initWithGameLayer:self.layer andTexture:self.cancerLive];
    Bullet *bullet= [[Bullet alloc] initWithGameLayer:self.layer andFrameName:self.bulletFrameName];
    bullet.position= pt;
    bullet.velocity= v;
    bullet.bulletType= type;
    
    [[SoundManager sharedSoundManager] playSound:kSoundFireProjectile atPoint:pt];
    
    [self.layer.batchNode addChild:bullet z:kBulletZ];
    [self.bullets addObject:bullet];
    //    [array addObject:cell];
    
}

-(void)seed
{
    [self addTurretAtPoint:CGPointMake(0, 0)];
}
@end

float cc_radians_between_points(CGPoint center, CGPoint target) {
    float dx = target.x - center.x;
    float dy = target.y - center.y;

    float theta = atan2(dy, dx);
    if (theta < 0) {
        theta += 2*M_PI;
    }
    
    return theta;
}

float distance_between_points(CGPoint center, CGPoint target)
{
    float dx = target.x - center.x;
    float dy = target.y - center.y;
    return sqrt(dx*dx + dy*dy);
}