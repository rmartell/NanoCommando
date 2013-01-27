//
//  PowerUpCollection.h
//  NanoCommando
//
//  Created by Ryan Martell on 1/27/13.
//
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

typedef enum {
    kPowerUpTurret
} PowerUpType;

@interface PowerUp : GameObject
@property (nonatomic, assign) PowerUpType type;
-(void)pickup;
@end

@interface PowerUpCollection : NSObject
-(id)initWithLayer:(GamePlayLayer *)layer;

-(void)update:(ccTime)ticksPassed;

-(NSArray *)powerupsInRange:(float)range ofPoint:(CGPoint)pt;
-(void)addPowerUpOfType:(PowerUpType)type atPoint:(CGPoint)pt;
@end