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


@implementation NCMainMenu

- (void) didLoadFromCCB
{
    CCLOG(@"Enter %@ %@", NSStringFromSelector(_cmd), self);
}

-(void)startPressed:(id)sender {
    CCLOG(@"______Start Pressed!_____");
    [[GameManager sharedGameManager] runSceneWithID:kGameScene];
}


@end
