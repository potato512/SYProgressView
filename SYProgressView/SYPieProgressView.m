//
//  SYPieProgressView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/11/15.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import "SYPieProgressView.h"

@interface SYPieProgressView ()

@property (nonatomic, assign) CGFloat lastProgress;

@end

@implementation SYPieProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat size = MIN(frame.size.width, frame.size.height);
        CGRect rect = self.frame;
        rect.size = CGSizeMake(size, size);
        self.frame = rect;
        self.backgroundColor = [UIColor clearColor];
        //
        self.showSpace = NO;
        self.spaceWidth = 0.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (!self.label.hidden) {
        if (self.animationText) {
            [self.label animationTextStartValue:self.lastProgress endValue:(self.progress * 100.0) duration:0.3 complete:^(UILabel *label, CGFloat value) {
                label.text = [NSString stringWithFormat:@"%.0f%%", value];
            }];
        } else {
            self.label.text = [NSString stringWithFormat:@"%.0f%%", (self.progress * 100.0)];
        }
    }
    
    self.lastProgress = (self.progress * 100.0);
    
    CGRect pathRect = rect;
    if (self.showBorderline) {
        pathRect = CGRectMake(self.lineWidth, self.lineWidth, (rect.size.width - self.lineWidth * 2), (rect.size.height - self.lineWidth * 2));
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:pathRect];
    [self.progressColor setFill]; // 背景颜色
    [path fill];
    [path addClip];
    //
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    CGFloat radius = MIN(pathRect.size.width, pathRect.size.height) * 0.5 - (self.showSpace ? self.spaceWidth : 0.0);
    // 进度
    [self.defaultColor set];
    if (self.progress >= 1.0) {
        [self.progressColor set];
    }
    // 进程圆
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    CGContextSetLineWidth(context, (self.showSpace ? self.spaceWidth : 0.0));
    CGContextMoveToPoint(context, xCenter, yCenter);
    CGContextAddLineToPoint(context, xCenter, 0);
    CGFloat endAngle = -M_PI * 0.5 + self.progress * M_PI * 2 + 0.001;
    CGContextAddArc(context, xCenter, yCenter, radius, -M_PI * 0.5, endAngle, 1);
    CGContextFillPath(context);
    [CATransaction commit];
    
}

#pragma mark - getter

#pragma mark - setter

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    if (_progress < 0.0) {
        _progress = 0.0;
    }
    if (_progress > 1.0) {
        _progress = 1.0;
    }
    [self setNeedsDisplay];
}

- (void)initializeProgress
{
    // 背景及圆角
    self.layer.cornerRadius = MIN(self.frame.size.width, self.frame.size.height) / 2;
    self.layer.masksToBounds = YES;
    self.backgroundColor = self.defaultColor;
    // 边框颜色
    if (self.showBorderline) {
        self.layer.borderColor = self.lineColor.CGColor;
        self.layer.borderWidth = self.lineWidth;
    }
    //
    [self bringSubviewToFront:self.label];
    self.label.layer.cornerRadius = self.layer.cornerRadius;
    if (self.animationText) {
        [self.label animationTextStartValue:0 endValue:0 duration:0.3 complete:^(UILabel *label, CGFloat value) {
            label.text = [NSString stringWithFormat:@"%.0f%%", (value * 100.0)];
        }];
    } else {
        self.label.text = [NSString stringWithFormat:@"%.0f%%", (_progress * 100.0)];
    }
    
    self.progress = 0.0;
}

@end
