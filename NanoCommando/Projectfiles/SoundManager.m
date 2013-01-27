//
//  SoundManager.m
//  NanoCommando
//
//  Created by Ryan Martell on 1/27/13.
//
//

#import "SoundManager.h"

@implementation SoundManager
+(SoundManager *)sharedSoundManager
{
    static SoundManager *s_Manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
      s_Manager= [[SoundManager alloc] init];
    });

    return s_Manager;
}

-(void)playSound:(SoundType)type
{
    
}

-(void)playSound:(SoundType)type at:(CGPoint)pt
{
    
}
@end
