//
//  GJCollisionBitmap.h
//  CollisionBitmapGenerator
//
//  Created by Ryan Martell on 1/26/13.
//  Copyright (c) 2013 Martell Ventures, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJCollisionBitmap : NSObject

-(id)initWithWidth:(NSUInteger)width
            height:(NSUInteger)height
       bytesPerRow:(NSUInteger)bytesPerRow
           andData:(NSData *)data;

@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;
@property (nonatomic, strong) NSData *bitmapData;
@property (nonatomic, assign) NSUInteger bytesPerRow;

-(BOOL)ptInside:(CGPoint)pt;
@end
