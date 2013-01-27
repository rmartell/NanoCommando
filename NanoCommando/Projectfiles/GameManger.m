//
//  GameManger.m
//  NanoCommando
//
//  Created by Grillaface on 1/27/13.
//
//

#import "GameManger.h" 
#import "CCBReader.h"
#import "GamePlayLayer.h"
#import "NCMainMenu.h"




@implementation GameManager {
    
}

//static GameManager* _sharedGameManager = nil;


+(GameManager*)sharedGameManager {
    static dispatch_once_t pred;
    static GameManager* gameManager = nil;
    dispatch_once(&pred, ^{gameManager = [[GameManager alloc] init]; });
    return gameManager;
}


-(id)init {
    self = [super init];
    if (self!=nil) {
        
        CCLOG(@"Game Manager Singleton, init");
        
        currentScene = kNoSceneUnitialized;
    }
    return self;
}

-(void)runSceneWithID:(SceneTypes)sceneID {
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    CCScene* sceneToRun = nil;
    switch (sceneID) {
        case kMainMenuScene:
            sceneToRun = [CCBReader sceneWithNodeGraphFromFile:@"NanoCommandoMainMenu.ccbi"];
            break;
        case kGameScene :
            sceneToRun = [GamePlayLayer scene];
            break;
        default:
            CCLOG(@"Unknown ID, cannot switch scenes");
            return;
            break;
    }
    if (sceneToRun == nil) {
        // revert back since no new scene was found
        currentScene = oldScene;
        return;
    }
    
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        CCLOG(@"No scene running - calling runWithScene");
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
        
    }
    else {
        CCLOG(@"Replacing scene");
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:sceneToRun]];
        
    }
}

-(void)saveGameData {
    // get allowed save paths
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //string for the default path
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // full path plus filename for saved game
    NSString *gameStatePath = [documentsDirectory stringByAppendingPathComponent:@"gameState.dat"];
    // storage for game state data
    NSMutableData *gameData = [NSMutableData data];
    //keyed archiver
    NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:gameData];
    
    
    //[encoder encodeInt:testInteger forKey:@"TestInteger"];
    //CCLOG(@"Saving TestInteger: %i", testInteger);
    
    //finish, write the encoder
    [encoder finishEncoding];
    [gameData writeToFile:gameStatePath atomically:YES];
}



-(void)loadGameData {
    
    // get allowed save paths
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //string for the default path
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // full path plus filename for saved game
    NSString *gameStatePath = [documentsDirectory stringByAppendingPathComponent:@"gameState.dat"];
    // storage for game state data
    NSMutableData *gameData = [NSMutableData dataWithContentsOfFile:gameStatePath];
    // start the decoder
    NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:gameData];
    
    //testInteger = [decoder decodeIntForKey:@"TestInteger"];
    //CCLOG(@"Retrieved TestInteger %i", testInteger);
    
}


-(void)resetAllData {
    CCLOG(@"RESETTING ALL DATA!!");
}



@end
