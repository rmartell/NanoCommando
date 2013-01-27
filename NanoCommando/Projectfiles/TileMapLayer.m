/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "TileMapLayer.h"
#import "SimpleAudioEngine.h"

@implementation TileMapLayer

-(id) init
{
	if ((self = [super init]))
	{
		CCTMXTiledMap* tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map.tmx"];
		tileMapHeightInPixels = tileMap.mapSize.height * tileMap.tileSize.height / CC_CONTENT_SCALE_FACTOR();
		[self addChild:tileMap z:kBackgroundZ tag:TileMapNode];
		
		// hide the event layer, we only need this information for code, not to display it
		CCTMXLayer* eventLayer = [tileMap layerNamed:@"GameEventLayer"];
		eventLayer.visible = NO;
	}

	return self;
}

@end
