//
//  SYLineProgressView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/11/15.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import "SYLineProgressView.h"

@interface SYLineProgressView ()

@property (nonatomic, strong) UIView *progressView;

@property (nonatomic, assign) CGFloat lastProgress;

@property (nonatomic, strong) CAGradientLayer *gradientlayer; // 渐变层
@property (nonatomic, strong) CALayer *progresslayer; // 遮罩层

@end

@implementation SYLineProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.showGradient = NO;
        self.colorsGradient = @[[UIColor yellowColor], [UIColor redColor]];
        //
        self.showSpace = NO;
        self.spaceWidth = 0.0;
        //
        [self bringSubviewToFront:self.progressView];
    }
    return self;
}

#pragma mark - getter

- (UIView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIView alloc] init];
        [self addSubview:_progressView];
        _progressView.layer.masksToBounds = YES;
        _progressView.backgroundColor = self.progressColor;
    }
    return _progressView;
}

- (CAGradientLayer *)gradientlayer
{
    if (_gradientlayer == nil) {
        // 创建 CAGradientLayer 对象
        _gradientlayer = [CAGradientLayer layer];
        // 设置 gradientLayer 的 Frame
        _gradientlayer.frame = self.progressView.bounds;
        // 创建渐变色数组，需要转换为CGColor颜色
//        _gradientlayer.colors = @[(id)[UIColor greenColor].CGColor,
//                                 (id)[UIColor blueColor].CGColor
//                                 ];
        //  设置三种颜色变化点，取值范围 0.0~1.0
        _gradientlayer.locations = @[@(0.0f), @(1.0f)];
        //  设置渐变颜色方向
        // gradientLayer.startPoint = CGPointMake(0, 0); // 左上
        // gradientLayer.endPoint = CGPointMake(0, 1); // 左下
        // gradientLayer.endPoint = CGPointMake(1, 0); // 右上
        // gradientLayer.endPoint = CGPointMake(1, 1); // 右下
         _gradientlayer.startPoint = CGPointMake(0, 0); // 左上
         _gradientlayer.endPoint = CGPointMake(1, 0); // 左上
    }
    return _gradientlayer;
}

- (CALayer *)progresslayer
{
    if (_progresslayer == nil) {
        _progresslayer = [CALayer layer];
        _progresslayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    return _progresslayer;
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
    
    CGFloat origin = self.showSpace ? (self.spaceWidth + self.lineWidth) : 0.0;
    CGFloat height = self.bounds.size.height - origin * 2;
    CGFloat width = self.bounds.size.width - origin * 2;
    if (self.showGradient) {
        self.progressView.frame = CGRectMake(origin, origin, width, height);
        self.progressView.backgroundColor = nil;
        //
        if (self.gradientlayer.colors == nil) {
            NSMutableArray *colors = [[NSMutableArray alloc] init];
            [self.colorsGradient enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [colors addObject:(id)obj.CGColor];
            }];
            self.gradientlayer.colors = colors;
        }
        self.gradientlayer.mask = self.progresslayer;
        [self.progressView.layer addSublayer:self.gradientlayer];
        //
        width *= _progress;
        if (width > self.bounds.size.width - origin * 2) {
            width = self.bounds.size.width - origin * 2;
        }
        if (self.isAnimation) {
            [UIView animateWithDuration:0.3 animations:^{
                self.progresslayer.frame = CGRectMake(0.0, 0.0, width, height);
            }];
        } else {
            self.progresslayer.frame = CGRectMake(0.0, 0.0, width, height);
        }  
    } else {
        width *= _progress;
        if (width > self.bounds.size.width - origin * 2) {
            width = self.bounds.size.width - origin * 2;
        }
        
        if (self.isAnimation) {
            [UIView animateWithDuration:0.3 animations:^{
                self.progressView.frame = CGRectMake(origin, origin, width, height);
            }];
        } else {
            self.progressView.frame = CGRectMake(origin, origin, width, height);
        }
    }

    
    if (!self.label.hidden) {
        if (self.animationText) {
            [self.label animationTextStartValue:self.lastProgress endValue:(self.progress * 100.0) duration:0.3 complete:^(UILabel *label, CGFloat value) {
                label.text = [NSString stringWithFormat:@"%.0f%%", value];
            }];
        } else {
            self.label.text = [NSString stringWithFormat:@"%.0f%%", (_progress * 100.0)];
        }
    }
    
    self.lastProgress = (self.progress * 100.0);
}

#pragma mark - methord

- (void)initializeProgress
{
    //
    self.layer.borderWidth = self.lineWidth;
    self.layer.borderColor = self.lineColor.CGColor;
    self.layer.masksToBounds = YES;
    //
    [self bringSubviewToFront:self.label];
    //
    self.backgroundColor = self.defaultColor;
    self.progressView.backgroundColor = self.progressColor;
    //
    if (self.layer.cornerRadius > self.frame.size.height) {
        self.layer.cornerRadius = self.frame.size.height / 2;
    }
    self.label.layer.cornerRadius = self.layer.cornerRadius;
    self.progressView.layer.cornerRadius = (self.layer.cornerRadius - (self.showSpace ? (self.spaceWidth + self.lineWidth) : 0.0));
    
    self.progress = 0.0;
}

@end
