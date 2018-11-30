//
//  SYRingProgressView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/11/15.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import "SYRingProgressView.h"

@interface SYRingProgressView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat lastProgress;

@property (nonatomic, strong) UIColor *cicleBgColor;

@end

@implementation SYRingProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat size = MIN(frame.size.width, frame.size.height);
        CGRect rect = self.frame;
        rect.size = CGSizeMake(size, size);
        self.frame = rect;
        //
        self.backgroundColor = [UIColor clearColor];
        self.lineView.frame = self.bounds;
        //
        self.lineRound = NO;
        //
        [self addObserver:self
               forKeyPath:@"angle"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // 路径
    UIBezierPath *path = [[UIBezierPath alloc] init];
    // 线宽
    path.lineWidth = self.lineWidth;
    // 颜色
    [self.progressColor set];
    // 拐角
    if (self.lineRound) {
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
    }
    // 半径
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - self.lineWidth) * 0.5;
    // 画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    CGFloat startAngle = M_PI * 1.5;
    CGFloat endAngle = startAngle + M_PI * 2 * self.progress;
    [path addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    // 连线
    [path stroke];
    
    //
    if (self.cicleBgColor && ![self.cicleBgColor isEqual:[UIColor clearColor]]) {
        UIBezierPath *pathCircle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.lineWidth, self.lineWidth, (self.frame.size.width - self.lineWidth * 2), (self.frame.size.height - self.lineWidth * 2)) cornerRadius:self.layer.cornerRadius];
        [self.cicleBgColor set];
        [pathCircle stroke];
        [pathCircle fill];
    }
}

#pragma mark - getter

- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        [self addSubview:_lineView];
        _lineView.layer.borderColor = self.lineColor.CGColor;
        _lineView.layer.borderWidth = self.lineWidth;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

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
    
    if (self.animationText) {
        [self.label animationTextStartValue:self.lastProgress endValue:(self.progress * 100.0) duration:0.3 complete:^(UILabel *label, CGFloat value) {
            label.text = [NSString stringWithFormat:@"%.0f%%", value];
        }];
    } else {
        self.label.text = [NSString stringWithFormat:@"%.0f%%", (_progress * 100.0)];
    }
    
    self.lastProgress = (self.progress * 100.0);
    
    [self setNeedsDisplay];
}

#pragma mark - methord

- (void)initializeProgress
{
    // 路径
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = self.lineWidth;
    [self.defaultColor set];
    CGFloat radius = (MIN(self.bounds.size.width, self.bounds.size.height) - self.lineWidth) * 0.5;
    // 画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    CGFloat startAngle = M_PI * 1.5;
    CGFloat endAngle = startAngle + M_PI * 2;
    [path addArcWithCenter:(CGPoint){self.bounds.size.width * 0.5, self.bounds.size.height * 0.5} radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path stroke];
    //
    self.layer.cornerRadius = MIN(self.frame.size.width, self.frame.size.height) / 2;
    self.layer.masksToBounds = YES;
    self.cicleBgColor = self.backgroundColor;
    self.backgroundColor = [UIColor clearColor];
    //
    [self bringSubviewToFront:self.label];
    self.label.layer.cornerRadius = self.layer.cornerRadius;
    if (self.animationText) {
        [self.label animationTextStartValue:0 endValue:0 duration:0.3 complete:^(UILabel *label, CGFloat value) {
            label.text = [NSString stringWithFormat:@"%.0f%%", value];
        }];
    } else {
        self.label.text = [NSString stringWithFormat:@"%.0f%%", (_progress * 100.0)];
    }
    //
    self.lineView.layer.borderColor = self.lineColor.CGColor;
    self.lineView.layer.borderWidth = self.lineWidth;
    self.lineView.layer.cornerRadius = self.frame.size.width / 2;
    [self sendSubviewToBack:self.lineView];
    
    self.progress = 0.0;
}

@end
