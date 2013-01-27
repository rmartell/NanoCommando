//
//  HudLayer.h
//  NanoCommando
//
//  Created by Mark Adkins-hastings on 1/26/13.
//
//

@class GamePlayLayer;

#import "CCLayer.h"

@interface HudLayer : CCLayer
@property (nonatomic) double theta;
@property (nonatomic) double throttle;
@property (nonatomic) CGPoint deployAt;
@property (nonatomic) Boolean deploy;

-(void)setGameLayer:(GamePlayLayer*)gameplayLayer;

@end
