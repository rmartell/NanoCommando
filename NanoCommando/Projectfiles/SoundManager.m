//
//  SoundManager.m
//  NanoCommando
//
//  Created by Ryan Martell on 1/27/13.
//
//

#import "SimpleAudioEngine.h"
#import "SoundManager.h"

@interface SoundManager ()
@property (nonatomic, strong) NSArray *audioFileNames;
@end

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

-(id)init
{
    if(self= [super init])
    {
        SimpleAudioEngine *engine= [SimpleAudioEngine sharedEngine];
        self.audioFileNames= [NSArray arrayWithObjects:
                              @"invalidPlacement.mp3",
                              @"turretDeploy.mp3",
                              @"shotFire.mp3",
                              @"deadCell.mp3",
                              @"pickupItem.mp3",
                              @"powerupPing.mp3",
                              @"flatline.mp3",
                              @"startConfirm.mp3",
                              @"quitBack.mp3",
                              @"pause.mp3",
                              @"shipHum.mp3",
                              @"shipHumShort.mp3",
                              nil];
        
        NSAssert(NUMBER_OF_SOUND_TYPES==self.audioFileNames.count, @"COunts don't match");
        
        for(NSString *filename in self.audioFileNames)
        {
            CCLOG(@"Preloading audio %@", filename);
            [engine preloadEffect:filename];
        }

        CGPoint pts[]= {
          CGPointMake(100, 0),
            CGPointMake(-100, 0),
        };

        for(int ii= 0; ii<ARRAY_SIZE(pts); ii++)
        {
            CGPoint pt= pts[ii];
            float theta= cc_radians_between_points(self.listenerPoint, pt);
            CCLOG(@"Listener %@ Target: %@ Theta: %f",
                  NSStringFromCGPoint(self.listenerPoint),
                  NSStringFromCGPoint(pt),
                  theta);
        }

    }
    return self;
}

-(void)playSound:(SoundType)type
{
    NSAssert(type>=0 && type<self.audioFileNames.count, @"Index %d out of range!", type);
    [[SimpleAudioEngine sharedEngine] playEffect:self.audioFileNames[type]];
}

#define MAXIMUM_AUDIO_DISTANCE (1500)
#define DISTANCE_BEFORE_ATTENUATION (200)

-(void)playSound:(SoundType)type atPoint:(CGPoint)pt
{
    NSAssert(type>=0 && type<self.audioFileNames.count, @"Index %d out of range!", type);
    
    float distance= distance_between_points(self.listenerPoint, pt);
    if(distance < MAXIMUM_AUDIO_DISTANCE)
    {
        float gain= 1.0;
        if(distance < DISTANCE_BEFORE_ATTENUATION)
        {
            gain= 1.0;
        } else {
            gain = (distance - DISTANCE_BEFORE_ATTENUATION)/
            (MAXIMUM_AUDIO_DISTANCE - DISTANCE_BEFORE_ATTENUATION);
        }
        
        /* Pan: [-1.0 to 1.0] stereo affect. Below zero plays your sound more on the left side. Above 0 plays to the right. 0.0 is dead-center. (see note below) */
        float theta= cc_radians_between_points(self.listenerPoint, pt);
        float pan= 0;
        
        [[SimpleAudioEngine sharedEngine] playEffect:self.audioFileNames[type] pitch:1.0
                                             pan:pan gain:gain];
    }    
}
@end