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
    self = [super initWithFile:filename];
    if (self) {
    }
    return self;
}

- (CGPoint)arriveWithTarget:(CGPoint)target {
    
    CGPoint vector = ccpSub(target, self.position);
    float distance = ccpLength(vector);
    
    float targetRadius = 5;
    float slowRadius = targetRadius + 25;
    static float timeToTarget = 0.1;
    
    if (distance < targetRadius) {
        self.velocity = CGPointZero;
        self.acceleration = CGPointZero;
        return CGPointZero;
    }
    
    float targetSpeed;
    if (distance > slowRadius) {
        targetSpeed = self.maxVelocity;
    } else {
        targetSpeed = self.maxVelocity * distance / slowRadius;
    }
    
    CGPoint targetVelocity = ccpMult(ccpNormalize(vector), targetSpeed);
    
    CGPoint acceleration = ccpMult(ccpSub(targetVelocity, self.velocity), 1/timeToTarget);
    if (ccpLength(acceleration) > self.maxAcceleration) {
        acceleration = ccpMult(ccpNormalize(acceleration), self.maxAcceleration);
    }
    return acceleration;
}


-(void)updateMove:(ccTime)delta {
    
    if (self.maxAcceleration <= 0 || self.maxVelocity <= 0) return;
    
    CGPoint moveTarget = self.destination;
    
    //    float distance = ccpDistance(self.position, moveTarget);
    
    CGPoint arriveComponent = [self arriveWithTarget:moveTarget];
    //CGPoint separateComponent = [self separate];
    //CGPoint newAcceleration = ccpAdd(arriveComponent, separateComponent);
    CGPoint newAcceleration = arriveComponent;
    
    // Update current acceleration based on the above, and clamp
        self.acceleration = ccpAdd(self.acceleration, newAcceleration);
    if (ccpLength(self.acceleration) > self.maxAcceleration) {
        self.acceleration = ccpMult(ccpNormalize(self.acceleration), self.maxAcceleration);
    }
    
    // Update current velocity based on acceleration and dt, and clamp
    self.velocity = ccpAdd(self.velocity, ccpMult(self.acceleration, delta));
    if (ccpLength(self.velocity) > self.maxVelocity) {
        self.velocity = ccpMult(ccpNormalize(self.velocity), self.maxVelocity);
    }
    
    // Update position based on velocity
    CGPoint newPosition = ccpAdd(self.position, ccpMult(self.velocity, delta));
    
    newPosition.x = MAX(MIN(newPosition.x, screenSize.width), 0);
    newPosition.y = MAX(MIN(newPosition.y, screenSize.height), 0);
    self.position = newPosition;
}


@end
