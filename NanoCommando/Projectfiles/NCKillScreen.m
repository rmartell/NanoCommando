//
//  NCKillScreen.m
//  NanoCommando
//
//  Created by Grillaface on 1/27/13.
//
//

#import "NCKillScreen.h"
#import "CCBReader.h"
#import "GameManger.h"


@implementation NCKillScreen

- (void) didLoadFromCCB
{
    CCLOG(@"Enter %@ %@", NSStringFromSelector(_cmd), self);
    
    [self scheduleOnce:@selector(returnToMainMenu) delay:5.0f];
    
}

-(void)returnToMainMenu {
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}


@end
