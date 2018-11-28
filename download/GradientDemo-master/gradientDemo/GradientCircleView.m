//
//  GradientCircleView.m
//  gradientDemo
//
//  Created by Gargit on 16/12/24359.
//  Copyright © 2016年 gargit. All rights reserved.
//

#import "GradientCircleView.h"

@implementation GradientCircleView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // 获取当前context
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    // 设置线的宽度
//    CGContextSetLineWidth(ctx, 10);
//    
//    // 设置线条端点为圆角
//    //kCGLineCapButt 端点什么都不绘制(默认),kCGLineCapRound 端点为圆角,kCGLineCapSquare 端点为方角(跟kCGLineCapButt很像)
//    CGContextSetLineCap(ctx, kCGLineCapRound);
//    // 设置画笔颜色
//    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
//    CGFloat originX = rect.size.width / 2;
//    CGFloat originY = rect.size.height / 2;
//    // 计算半径
//    CGFloat radius = MIN(originX, originY) - 10.0;
//    // CGContextAddArc(CGContextRef cg_nullable c, CGFloat x, CGFloat y, CGFloat radius, CGFloat startAngle, CGFloat endAngle, int clockwise)
//    // 画一个圆弧作为context的路径，(x, y)是圆弧的圆心；radius是圆弧的半径；`startAngle' 是开始点的弧度;`endAngle' 是结束位置的弧度;（此处开始位置为屏幕坐标轴x轴正轴方向）; clockwise 为1是，圆弧是逆时针，0的时候就是顺时针。startAngle跟endAngle都是弧度制
//    // 逆时针画一个圆弧
//    CGContextAddArc(ctx, rect.size.width / 2, rect.size.height / 2, radius, 0, M_PI_2, 1);
//    CGContextStrokePath(ctx);
//}

    - (void)drawRect:(CGRect)rect {
        // 1. 还是添加一个圆弧路径
        // 获取当前context
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        // 设置线的宽度
        CGContextSetLineWidth(ctx, 10);
        
        // 设置线条端点为圆角
        CGContextSetLineCap(ctx, kCGLineCapRound);
        // 设置画笔颜色
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGFloat originX = rect.size.width / 2;
        CGFloat originY = rect.size.height / 2;
        // 计算半径
        CGFloat radius = MIN(originX, originY) - 10.0;
        // 逆时针画一个圆弧
        CGContextAddArc(ctx, rect.size.width / 2, rect.size.height / 2, radius, 0, M_PI * 2, 1);
        
        // 2. 创建一个渐变色
        // 创建RGB色彩空间，创建这个以后，context里面用的颜色都是用RGB表示
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // 渐变色的颜色
        NSArray *colorArr = @[
                              (id)[UIColor whiteColor].CGColor,
                              (id)[UIColor redColor].CGColor
                              ];
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colorArr, NULL);
        // 释放色彩空间
        CGColorSpaceRelease(colorSpace);
        colorSpace = NULL;
        
        // ----------以下为重点----------
        // 3. "反选路径"
        // CGContextReplacePathWithStrokedPath
        // 将context中的路径替换成路径的描边版本，使用参数context去计算路径（即创建新的路径是原来路径的描边）。用恰当的颜色填充得到的路径将产生类似绘制原来路径的效果。你可以像使用一般的路径一样使用它。例如，你可以通过调用CGContextClip去剪裁这个路径的描边
        CGContextReplacePathWithStrokedPath(ctx);
        // 剪裁路径
        CGContextClip(ctx);
        
        // 4. 用渐变色填充
        CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, rect.size.height / 2), CGPointMake(rect.size.width, rect.size.height / 2), 0);
        // 释放渐变色
        CGGradientRelease(gradient);
    }

@end
