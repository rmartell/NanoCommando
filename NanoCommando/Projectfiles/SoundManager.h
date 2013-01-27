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
    kSoundGameQuit,
    kSoundPause,
    kSoundMoveShipLong,
    kSoundMoveShipShort,
    kSoundNoMoreTurrets,
    kTheme,
    NUMBER_OF_SOUND_TYPES
} SoundType;

@interface SoundManager : NSObject
@property (nonatomic, assign) CGPoint listenerPoint;
@property (nonatomic, assign) BOOL backgroundMusicPlaying;

+(SoundManager *)sharedSoundManager;

-(void)playSound:(SoundType)type;
-(void)playSound:(SoundType)type atPoint:(CGPoint)pt;

-(void)startBackgroundMusic:(SoundType)type;
-(void)stopBackgroundMusic;

@end
