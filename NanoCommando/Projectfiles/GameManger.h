//
//  GameManger.h
//  NanoCommando
//
//  Created by Grillaface on 1/27/13.
//
//

#import "GameManger.h"

@interface GameManager : NSObject {
    
    SceneTypes currentScene;
    
}

+(GameManager*)sharedGameManager;
-(void)runSceneWithID:(SceneTypes)sceneID;

-(void)saveGameData;
-(void)loadGameData;
-(void)resetAllData;


@end
