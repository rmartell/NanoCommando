//
//  SoundManager.h
//  NanoCommando
//
//  Created by Ryan Martell on 1/27/13.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    kSoundInvalidDeploy= 0,
    kSoundTurretDeploy,
    kSoundFireProjectile,
    kSoundCellDeath,
    kSoundPowerupPickup,
    kSoundPowerupPing,
    kSoundFlatline,
    kSoundGameStart,
    kSoundPause,
    NUMBER_OF_SOUND_TYPES
} SoundType;

@interface SoundManager : NSObject

+(SoundManager *)sharedSoundManager;

-(void)playSound:(SoundType)type;
-(void)playSound:(SoundType)type at:(CGPoint)pt;
@end
