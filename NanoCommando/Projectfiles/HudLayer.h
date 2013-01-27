//
//  HudLayer.h
//  NanoCommando
//
//  Created by Mark Adkins-hastings on 1/26/13.
//
//

#import "CCLayer.h"

@interface HudLayer : CCLayer

@property (nonatomic, weak) CCSprite *panSprite;
@property (nonatomic, weak) CCSprite *panSprite2;
@property (nonatomic) Boolean startpan;
@property (nonatomic) CGPoint startpos;
@property (nonatomic) double theta;
@property (nonatomic) double throttle;

@end
