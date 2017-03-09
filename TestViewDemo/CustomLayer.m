//
//  CustomLayer.m
//  TestViewDemo
//
//  Created by andwell on 17/3/5.
//  Copyright © 2017年 andwell. All rights reserved.
//

#import "CustomLayer.h"

@implementation CustomLayer

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)layoutSublayers
{
    __strong id<CustomLayerDelegate> delegate = (id<CustomLayerDelegate>)self.delegate;
    
    if ([delegate respondsToSelector:@selector(fk_layoutSublayersOfLayer:)]) {
        [delegate fk_layoutSublayersOfLayer:self];
    }else {// if not implement layoutSublayers
        // call the layoutManager's layoutSublayersOfLayer method
    }
}

- (void)display {
    
    // if u want start async display release the annotation
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong id<CustomLayerDelegate> delegate = (id<CustomLayerDelegate>)self.delegate;
        
        [delegate fk_layerWillDraw:self];// ①
        
        CGContextRef ctx = [delegate fk_drawContextFromUIGraphics];
        
        [self fk_drawInContext:ctx];// ②
        
        [delegate fk_displayLayer:self];// ③
        
        [delegate fk_layerDidDraw:self];// ④
//    });
}

- (void)fk_drawInContext:(CGContextRef)ctx
{
    // draw backgroundColor
    if (self.opaque) {
        CGSize size = self.bounds.size;
        size.width *= self.contentsScale;
        size.height *= self.contentsScale;
        CGContextSaveGState(ctx);
        if (!self.backgroundColor || CGColorGetAlpha(self.backgroundColor) < 1) {
            const CGFloat color[4] = { 1.0, 1.0, 1.0, 1.0 }; // white color
            CGColorRef aColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), color);
            CGContextSetFillColorWithColor(ctx, aColor);
            CGContextAddRect(ctx, CGRectMake(0, 0, size.width, size.height));
            CGContextFillPath(ctx);
        }
        if (self.backgroundColor) {
            CGContextSetFillColorWithColor(ctx, self.backgroundColor);
            CGContextAddRect(ctx, CGRectMake(0, 0, size.width, size.height));
            CGContextFillPath(ctx);
        }
        CGContextRestoreGState(ctx);
    }
    
    [(id<CustomLayerDelegate>)self.delegate fk_drawLayer:self inContext:ctx];// ②
}

@end
