//
//  GJCollisionBitmap.m
//  CollisionBitmapGenerator
//
//  Created by Ryan Martell on 1/26/13.
//  Copyright (c) 2013 Martell Ventures, LLC. All rights reserved.
//

#import "GJCollisionBitmap.h"

typedef unsigned char byte;


@implementation GJCollisionBitmap

-(id)initWithWidth:(NSUInteger)width
            height:(NSUInteger)height
       bytesPerRow:(NSUInteger)bytesPerRow
           andData:(NSData *)data
{
    NSAssert(bytesPerRow<width, @"BytesPerRow is > Width!");
    NSAssert(bytesPerRow*height==[data length], @"BPR * Height != data length");
    
    if(self= [super init])
    {
        self.width= width;
        self.height= height;
        self.bytesPerRow= bytesPerRow;
        self.bitmapData= data;
    }
    
    return self;
}


-(BOOL)ptInside:(CGPoint)pt;
{
    BOOL result= NO;
    int x= (int)(pt.x);
    int y= self.height - (int)(pt.y);
    
    // might want to just return YES on these
    if(x>=0 && x<(int)self.width && y>=0 && y<(int)self.height)
    {
        byte target_byte;
        
        NSRange range= NSMakeRange((self.bytesPerRow*y)+(x>>3), 1);
        [self.bitmapData getBytes:&target_byte range:range];
        byte mask= 1<<(x&0x07);
        
        result= ((target_byte & mask)==mask);
    }
    
    return result;
}
@end
