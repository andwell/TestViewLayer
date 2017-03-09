//
//  CustomView.m
//  TestViewDemo
//
//  Created by andwell on 17/3/5.
//  Copyright © 2017年 andwell. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "CustomView.h"
#import "CustomLayer.h"

@interface CustomView()<CustomLayerDelegate>
@end

@implementation CustomView

+ (Class)layerClass {
    return [CustomLayer class];
}

// load from nib
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

// awake from nib
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawStarOnContext:ctx];
}

// drawing process
- (void)drawStarOnContext:(CGContextRef)ctx {
    int aSize = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    const CGFloat color[4] = { 1.0, 0.0, 0.0, 1.0 }; // red color
    CGColorRef aColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), color);
    CGContextSetLineWidth(ctx, aSize);
    CGFloat xCenter = CGRectGetMidX(self.bounds);
    CGFloat yCenter = CGRectGetMidY(self.bounds);
    
    float  w = aSize;
    double r = w / 2.0;
    float flip = -1.0;
    
    CGContextSetFillColorWithColor(ctx, aColor);
    CGContextSetStrokeColorWithColor(ctx, aColor);
    
    double theta = 2.0 * M_PI * (2.0 / 5.0); // 144 degrees
    
    CGContextMoveToPoint(ctx, xCenter, r*flip+yCenter);
    
    for (NSUInteger k=1; k<5; k++)
    {
        float x = r * sin(k * theta);
        float y = r * cos(k * theta);
        CGContextAddLineToPoint(ctx, x+xCenter, y*flip+yCenter);
    }
    
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)fk_layoutSublayersOfLayer:(CALayer *)layer {
    // do something u like layout
    // default (layoutSublayersOfLayer:) inner implementation is layoutSubviews method
     [self layoutSubviews];
}

#pragma mark -- CustomLayer (CALayer) drawing cycle

// get context (beacuse UIKit just apply to iOS，CoreGraphics is apply to iOS and Mac OS X)
- (CGContextRef)fk_drawContextFromUIGraphics {
    CGContextRef context = UIGraphicsGetCurrentContext();
    return context;
}

// ①
- (void)fk_layerWillDraw:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.layer.contentsScale);
}

// ②
- (void)fk_drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    // default (drawLayer:inContext:) inner implementation is drawRect: method
    // [self drawRect:self.bounds];
    
    // draw something u like (this draw red star)
    [self drawStarOnContext:ctx];
}

// ③
- (void)fk_displayLayer:(CALayer *)layer {
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // if u use async display release the annotation
//    dispatch_async(dispatch_get_main_queue(), ^{
        layer.contents = (__bridge id)(image.CGImage);
//    });
}

// ④
- (void)fk_layerDidDraw:(CALayer *)layer {
    UIGraphicsEndImageContext();
}

@end
