//
//  CancerCell.m
//  NanoCommando
//
//  Created by Ryan Martell on 1/26/13.
//
//

#import "CancerCell.h"

#define PI 3.14159265
#define DEGREES_TO_RADIANS(x) (x*PI/180.0)

@interface CancerCollection ()
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, weak) GamePlayLayer *layer;
@property (nonatomic, weak) GJCollisionBitmap *collision;
@property (nonatomic, assign) NSTimeInterval lastUpdate;

@property (nonatomic, strong) NSString* textureFrameName;
//@property (nonatomic, strong) CCTexture2D *cancerLive;
//@property (nonatomic, strong) CCTexture2D *cancerDormant;

-(void)addCancerAtPoint:(CGPoint)pt intoArray:(NSMutableArray *)array;
-(BOOL)cancerCell:(CancerCell *)cell canGrowToPoint:(CGPoint)pt andInterimArray:(NSMutableArray *)others;
@end

@interface CancerCell ()
@property (nonatomic, assign) unsigned char growDirections;
@property (nonatomic, assign) NSTimeInterval birthTime;
@property (nonatomic, assign) NSTimeInterval lastGrowth;
@property (nonatomic, assign) int roughX;
@property (nonatomic, assign) int roughY;
@end

@implementation CancerCell

//-(id) initWithGameLayer:(GamePlayLayer*)layer andTexture:(CCTexture2D *)texture
-(id) initWithGameLayer:(GamePlayLayer*)layer andFrameName:(NSString *)texture
{
	//if ((self = [super initWithTexture:texture]))
//    if ((self = [super initWithSpriteFrameName:texture]))
    if ((self = [super initWithSprite:@"CancerCell" andLayer:layer]))
	{
        self.growDirections= 0x7f;
        self.birthTime= [NSDate timeIntervalSinceReferenceDate];
	}
	return self;
}

-(BOOL)isGrowing
{
    return (self.growDirections?YES:NO);
}

-(BOOL)ptInside:(CGPoint)pt
{
    return CGRectContainsPoint(self.boundingBox, pt);
}

-(void)spreadIntoCollection:(CancerCollection *)collection andArray:(NSMutableArray *)array
{
    // if we should grow...
    if([NSDate timeIntervalSinceReferenceDate] - self.lastGrowth>1)
    {
        for(int ii= 0; ii<8; ii++)
        {
            unsigned char mask= (1<<ii);
            if(self.growDirections & mask)
            {
                float degrees= ((360/8)*ii);

                // can we grow there?
                float distance= self.contentSize.width * 0.9;
                double radians= DEGREES_TO_RADIANS(degrees);

                float dx= cos(radians)*distance;
                float dy= sin(radians)*distance;
                CGPoint dest= CGPointMake(self.position.x + dx, self.position.y+dy);
//NSLog(@"Testing %@ from center at %@", NSStringFromCGPoint(dest), NSStringFromCGPoint(self.position));
                
                if([collection cancerCell:self canGrowToPoint:dest andInterimArray:array])
                {
                    [collection addCancerAtPoint:dest intoArray:array];
                }
                
                // either we grew, or we clear...
                self.growDirections &= ~mask;
            }
            
            if(!self.growDirections) {
                [self runAction:[CCTintTo actionWithDuration:1.0f red:5 green:5 blue:5]];
               // self.texture= collection.cancerDormant;
            }
        }
        self.lastGrowth= [NSDate timeIntervalSinceReferenceDate];
    }
}
@end


@implementation CancerCollection
-(id)initWithLayer:(GamePlayLayer *)layer andCollisionMask:(GJCollisionBitmap *)bitmap;
{
    if(self= [super init])
    {
        self.cells= [NSMutableArray arrayWithCapacity:10];
        self.layer= layer;
        self.collision= bitmap;
        
        self.textureFrameName = @"CancerCell.png";
      //  self.cancerLive= [[CCTextureCache sharedTextureCache] addImage: @"CancerCell.png"];
        //self.cancerDormant= [[CCTextureCache sharedTextureCache] addImage: @"CancerCellInside.png"];
    }

    return self;
}

-(BOOL)cancerCell:(CancerCell *)cell canGrowToPoint:(CGPoint)pt andInterimArray:(NSMutableArray *)others
{
//    NSLog(@"Testing point: %@", NSStringFromCGPoint(pt));
    BOOL valid= ![self.collision ptInside:pt];
    
    if(valid)
    {
        // check if inside another cancer cell...
        for(CancerCell *c in self.cells)
        {
            if(cell != c && [c ptInside:pt])
            {
                valid= NO;
                break;
            }
        }
        
        if(valid)
        {
            for(CancerCell *c in others)
            {
                if(cell != c && [c ptInside:pt])
                {
                    valid= NO;
                    break;
                }
            }
        }
    }
    
    return valid;
}

-(void)update:(ccTime)ticksPassed
{
    return;
    // I _really_ don't like the ticksPassed in crap..
    if([NSDate timeIntervalSinceReferenceDate] - self.lastUpdate>1)
    {
        int ticks= 1;

NSTimeInterval startTime= [NSDate timeIntervalSinceReferenceDate];
        
//    NSLog(@"Interval: %f Ticks: %d", ticksPassed, ticks);
        NSMutableArray *newGrowth= [NSMutableArray arrayWithCapacity:10];
        for(int ii= 0; ii<ticks; ii++)
        {
            for(CancerCell *cell in self.cells)
            {
                if(cell.isGrowing)
                {
                    [cell spreadIntoCollection:self andArray:newGrowth];
                }
            }
        }
        
        [self.cells addObjectsFromArray:newGrowth];
        self.lastUpdate= [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval delta= [NSDate timeIntervalSinceReferenceDate] - startTime;
        CCLOG(@"Total time spent: %lf", delta);

    }
}

-(void)addCancerAtPoint:(CGPoint)pt intoArray:(NSMutableArray *)array
{
//    CancerCell *cell= [[CancerCell alloc] initWithGameLayer:self.layer andTexture:self.cancerLive];
    CancerCell *cell= [[CancerCell alloc] initWithGameLayer:self.layer andFrameName:self.textureFrameName];
    cell.position= pt;
    double scaled = (double)rand()/RAND_MAX;

    cell.scale= 0.9 + (.20*scaled);
    
    [self.layer.batchNode addChild:cell z:kCancerZ];
    [array addObject:cell];
}

-(void)seed
{
    CGPoint seed_pts[]= {
        CGPointMake(-2031, -1405),
        CGPointMake(-2006, -381.134),
        CGPointMake(-2025, 152.49),
        CGPointMake(-2034, 1087.51)
    };
    
//    [self addCancerAtPoint:ccp(512, 500) intoArray:self.cells];
    for(int ii= 0; ii<(int)(sizeof(seed_pts)/sizeof(seed_pts[0])); ii++)
    {
        [self addCancerAtPoint:seed_pts[ii] intoArray:self.cells];
    }
}
@end