//
//  NCMainMenu.m
//  NanoCommando
//
//  Created by Grillaface on 1/27/13.
//
//

#import "NCMainMenu.h"
#import "CCBReader.h"
#import "GameManger.h"
#import "SoundManager.h"


@implementation NCMainMenu

- (void) didLoadFromCCB
{
    CCLOG(@"Enter %@ %@", NSStringFromSelector(_cmd), self);
}

-(void)startPressed:(id)sender {
    CCLOG(@"______Start Pressed!_____");
    [[SoundManager sharedSoundManager] playSound:kSoundHeartBeat];
    [[GameManager sharedGameManager] runSceneWithID:kGameScene];
    
}


@end
