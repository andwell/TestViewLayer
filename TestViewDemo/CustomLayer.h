//
//  CustomLayer.h
//  TestViewDemo
//
//  Created by andwell on 17/3/5.
//  Copyright © 2017年 andwell. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CustomLayer : CALayer

@end

@protocol CustomLayerDelegate <NSObject>

- (void)fk_layoutSublayersOfLayer:(CALayer *)layer;

- (void)fk_displayLayer:(CALayer *)layer;

- (void)fk_drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;

- (void)fk_layerWillDraw:(CALayer *)layer;

- (CGContextRef)fk_drawContextFromUIGraphics;

- (void)fk_layerDidDraw:(CALayer *)layer;

@end
