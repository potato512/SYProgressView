//
//  SYRingProgressView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/11/15.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import "SYRingProgressView.h"

// 将角度转为弧度
#define kDegreesToRadoans(degress) (M_PI * (degress) / 180.0)

@interface SYRingProgressView ()

//
@property (nonatomic, strong) UIView *ringView;
@property (nonatomic, strong) CAGradientLayer *colorLayer; // 进度
@property (nonatomic, strong) CAShapeLayer *maskLayer; // 遮罩

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
        self.backgroundColor = UIColor.lightGrayColor;
        //
        self.isClockwise = YES;
        self.startAngle = -90.0;
        self.endAngle = 270.0;
    }
    
    return self;
}

#pragma mark - getter

- (UIView *)ringView
{
    if (_ringView == nil) {
        _ringView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_ringView];
    }
    return _ringView;
}

- (CAGradientLayer *)colorLayer
{
    if (_colorLayer == nil) {
        _colorLayer = [CAGradientLayer layer];
        _colorLayer.frame = self.ringView.bounds;
        //
        _colorLayer.colors = @[(id)UIColor.yellowColor.CGColor,
                               (id)UIColor.redColor.CGColor];
        //
        _colorLayer.startPoint = CGPointMake(0, 0);
        _colorLayer.endPoint = CGPointMake(1, 0);
        _colorLayer.locations = @[@(0.0), @(1.0)];// @[@0.1, @0.6];
    }
    return _colorLayer;
}

- (CAShapeLayer *)maskLayer
{
    if (_maskLayer == nil) {
        _maskLayer = [self generateMaskLayer];
    }
    return _maskLayer;
}

#pragma mark - setter


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    //
    if (self.isAnimation) {
        self.maskLayer.strokeEnd = 0.0;
        [CATransaction begin];
        [CATransaction setDisableActions:NO];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [CATransaction setAnimationDuration:0.3];
        self.maskLayer.strokeEnd = _progress;
        [CATransaction commit];
    } else {
        self.maskLayer.strokeEnd = _progress;
    }
    
}

#pragma mark - 方法

/**
 创建圆环，适合做蒙层，也适合画纯色图形
 
 @return CAShapeLayer
 */
- (CAShapeLayer *)generateMaskLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.ringView.bounds;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    //
    layer.lineWidth = self.lineWidth;
    if (self.lineRound) {
        layer.lineCap = kCALineCapRound;
    }
    // kDegreesToRadoans(self.startAngle) kDegreesToRadoans(self.endAngle)
//    UIBezierPath *paths = [UIBezierPath bezierPathWithArcCenter:CGPointMake((self.ringView.frame.size.width / 2), (self.ringView.frame.size.height / 2)) radius:(self.ringView.frame.size.width / 2.5) startAngle:kDegreesToRadoans(-220) endAngle:kDegreesToRadoans(40) clockwise:YES];
    UIBezierPath *paths = [UIBezierPath bezierPathWithArcCenter:CGPointMake((self.ringView.frame.size.width / 2), (self.ringView.frame.size.height / 2)) radius:(self.ringView.frame.size.width / 2.5) startAngle:kDegreesToRadoans(self.startAngle) endAngle:kDegreesToRadoans(self.endAngle) clockwise:self.isClockwise];
    layer.path = paths.CGPath;
    
    return layer;
}

- (void)generateProgressColor
{
    if (self.colorsGradient && self.showGradient) {
        if (self.colorsGradient.count <= 0) {
            return;
        }
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        [self.colorsGradient enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [colors addObject:(id)obj.CGColor];
        }];
        self.colorLayer.colors = colors;
    } else {
        self.colorLayer.colors = @[(id)self.progressColor.CGColor, (id)self.progressColor.CGColor];
    }
}

- (void)initializeProgress
{
    self.label.hidden = YES;
    //
    [self.ringView.layer addSublayer:self.colorLayer];
    self.colorLayer.mask = self.maskLayer;
    // view的layer添加蒙层mask
    CAShapeLayer *layer = [self generateMaskLayer];
    [self.ringView.layer addSublayer:layer];
    self.ringView.layer.mask = layer;
    [self generateProgressColor];
    //
    self.ringView.backgroundColor = self.lineColor;
    self.maskLayer.strokeEnd = 0.0;
}

@end
