//
//  CancerCell.m
//  NanoCommando
//
//  Created by Ryan Martell on 1/26/13.
//
//

#import "CancerCell.h"

@interface CancerCollection ()
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, weak) GamePlayLayer *layer;
@property (nonatomic, weak) GJCollisionBitmap *collision;
@property (nonatomic, assign) NSTimeInterval lastUpdate;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) int currentGeneration;

//@property (nonatomic, strong) NSString* textureFrameName;
//@property (nonatomic, strong) CCTexture2D *cancerLive;
//@property (nonatomic, strong) CCTexture2D *cancerDormant;

-(CancerCell *)addCancerAtPoint:(CGPoint)pt intoArray:(NSMutableArray *)array;
-(BOOL)cancerCell:(CancerCell *)cell canGrowToPoint:(CGPoint)pt andInterimArray:(NSMutableArray *)others;
@end

@interface CancerCell ()
@property (nonatomic, assign) unsigned char growDirections;
@property (nonatomic, assign) NSTimeInterval birthTime;
@property (nonatomic, assign) NSTimeInterval lastGrowth;
@property (nonatomic, assign) int generation;
@property (nonatomic, assign) int roughX;
@property (nonatomic, assign) int roughY;
@end

#define CANCER_SIZE (32)

#define ROUGH_X_FROM_X(x) ((x)/(4*CANCER_SIZE))
#define ROUGH_Y_FROM_Y(y) ((y)/(4*CANCER_SIZE))

@implementation CancerCell

//-(id) initWithGameLayer:(GamePlayLayer*)layer andTexture:(CCTexture2D *)texture
-(id) initWithGameLayer:(GamePlayLayer*)layer // andFrameName:(NSString *)texture
{
	//if ((self = [super initWithTexture:texture]))
//    if ((self = [super initWithSpriteFrameName:texture]))
    if ((self = [super initWithSprite:@"cancertest02" andLayer:layer]))
	{
        self.growDirections= 0x7f;
        self.birthTime= [NSDate timeIntervalSinceReferenceDate];
	}
	return self;
}

-(void)setPosition:(CGPoint)position
{
    self.roughX= ROUGH_X_FROM_X(position.x);
    self.roughY= ROUGH_Y_FROM_Y(position.y);
    [super setPosition:position];
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
            int bitIndex= (ii+self.generation)%8;
            unsigned char mask= (1<<bitIndex);
            if(self.growDirections & mask)
            {
                float degrees= ((360/8)*bitIndex);

                // can we grow there?
                float distance= self.boundingBox.size.width * 0.8;
                double radians= DEGREES_TO_RADIANS(degrees);

                float dx= cos(radians)*distance;
                float dy= sin(radians)*distance;
                CGPoint dest= CGPointMake(self.position.x + dx, self.position.y+dy);
//NSLog(@"Testing %@ from center at %@", NSStringFromCGPoint(dest), NSStringFromCGPoint(self.position));
                
                if([collection cancerCell:self canGrowToPoint:dest andInterimArray:array])
                {
                    CancerCell *newCell= [collection addCancerAtPoint:dest intoArray:array];
                    // The newCell growDirection can't grow back in the way it went before.
                }
                
                // either we grew, or we clear...
                self.growDirections &= ~mask;
                if(!self.growDirections)
                {
                    // [self runAction:[CCTintTo actionWithDuration:1.0f red:0xff green:0 blue:0]];
                   // self.texture= collection.cancerDormant;
                }
//                break; // only do one each time
            }
            
            if(!self.growDirections) {
                //[self runAction:[CCTintTo actionWithDuration:1.0f red:5 green:5 blue:5]];
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
        
      //  self.textureFrameName = @"CancerCell.png";
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
        int rough_x= ROUGH_X_FROM_X(pt.x);
        int rough_y= ROUGH_Y_FROM_Y(pt.y);
        
        // check if inside another cancer cell...
        for(CancerCell *c in self.cells)
        {
            if(cell != c &&
               abs(rough_x-c.roughX)<=1 &&
               abs(rough_y-c.roughY)<=1 &&
               [c ptInside:pt])
            {
//                [c runAction:[CCTintTo actionWithDuration:1.0f red:0 green:0 blue:0xff]];
                valid= NO;
                break;
            }
        }
        
        if(valid)
        {
            for(CancerCell *c in others)
            {
                if(cell != c &&
                   abs(rough_x-c.roughX)<=1 &&
                   abs(rough_y-c.roughY)<=1 &&
                   [c ptInside:pt])
                {
//                    [c runAction:[CCTintTo actionWithDuration:1.0f red:0 green:0 blue:0xff]];
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
//    return;
    // I _really_ don't like the ticksPassed in crap..
    if([NSDate timeIntervalSinceReferenceDate] - self.lastUpdate>1)
    {
        self.currentGeneration+= 1;
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
        CCLOG(@"Total time calculating cancer spent: %lf", delta);
    }
}

-(CancerCell *)addCancerAtPoint:(CGPoint)pt intoArray:(NSMutableArray *)array
{
//    CancerCell *cell= [[CancerCell alloc] initWithGameLayer:self.layer andTexture:self.cancerLive];
    CancerCell *cell= [[CancerCell alloc] initWithGameLayer:self.layer]; //] andFrameName:self.textureFrameName];
    cell.position= pt;
    double scaled = (double)rand()/RAND_MAX;

    cell.scale=2*( 0.8 + (.40*scaled));
    cell.generation= rand()%8;

    [self.layer.batchNode addChild:cell z:kCancerZ];
    [array addObject:cell];
    
    return cell;
}

-(NSArray *)cancerCellsInRange:(float)range ofPoint:(CGPoint)pt
{
    NSMutableArray *array= [NSMutableArray arrayWithCapacity:10];
    int rXStart= ROUGH_X_FROM_X(pt.x - range);
    int rXEnd= ROUGH_X_FROM_X(pt.x + range);
    int rYStart= ROUGH_Y_FROM_Y(pt.y - range);
    int rYEnd= ROUGH_Y_FROM_Y(pt.y + range);

    for(int rx= rXStart; rx<= rXEnd; rx++)
    {
        for(int ry= rYStart; ry<= rYEnd; ry++)
        {
            for(CancerCell *cell in self.cells)
            {
                if(cell.roughY==ry && cell.roughX==rx)
                {
                    float dx= cell.position.x - pt.x;
                    float dy= cell.position.y - pt.y;
                    
                    if((dx*dx + dy*dy)<range*range)
                    {
                        [array addObject:cell];
                    }
                }
            }
        }
    }

    return array;
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