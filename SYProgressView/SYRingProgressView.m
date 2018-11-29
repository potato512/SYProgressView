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

@property (nonatomic, strong) UIImageView *thumbView; // 滑块
@property (nonatomic, assign) CGPoint lastPoint;        //滑块的实时位置

@property (nonatomic, assign) CGFloat radius;           //半径
@property (nonatomic, assign) CGPoint drawCenter;       //绘制圆的圆心
@property (nonatomic, assign) CGPoint circleStartPoint; //thumb起始位置
@property (nonatomic, assign) CGFloat angle;            //转过的角度

@property (nonatomic, assign) BOOL lockClockwise;       //禁止顺时针转动
@property (nonatomic, assign) BOOL lockAntiClockwise;   //禁止逆时针转动

@property (nonatomic, assign) CGFloat circleRadius;     // 圆形进度条的半径（若未设置，则不会显示；默认减24，一般比view的宽高中最小者还要小24）

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
        // 滑块
        self.showThumb = NO;
        self.thumbTintColor = [UIColor blackColor];
        self.thumbRadius = (self.lineWidth * 1.2);
        self.thumbExpandRadius = (self.thumbRadius * 1.2);
        self.thumbView.frame = CGRectMake(0.0, 0.0, self.thumbRadius, self.thumbRadius);
        [self addSubview:self.thumbView];
        // 绘制圆信息
        self.drawCenter = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        self.circleRadius = MIN(self.frame.size.width, self.frame.size.height);
        self.canRepeat = NO;
        self.angle = 0;
        //
        self.lockAntiClockwise = YES;
        self.lockClockwise = NO;
        self.canCounterClockWise = NO;
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
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    // 半径
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - self.lineWidth) * 0.5;
    // 画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    CGFloat startAngle = M_PI * 1.5;
    CGFloat endAngle = startAngle + M_PI * 2 * _progress;
    [path addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    // 连线
    [path stroke];
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

- (UIImageView *)thumbView
{
    if (!_thumbView) {
        _thumbView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _thumbView.layer.masksToBounds = YES;
        _thumbView.userInteractionEnabled = NO;
    }
    return _thumbView;
}

#pragma mark - setter

- (void)setThumbImage:(UIImage *)thumbImage
{
    _thumbImage = thumbImage;
    self.thumbView.image = _thumbImage;
}

- (void)setShowThumb:(BOOL)showThumb
{
    _showThumb = showThumb;
    self.thumbView.hidden = !_showThumb;
}

- (void)setCircleRadius:(CGFloat)circleRadius {
    _circleRadius = (circleRadius - 24.0);
    self.circleStartPoint = CGPointMake(self.drawCenter.x, self.drawCenter.y - self.circleRadius);
//    [self setNeedsDisplay];
}

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
    [self bringSubviewToFront:self.label];
    self.label.layer.cornerRadius = self.layer.cornerRadius;
    if (self.animationText) {
        [self.label animationTextStartValue:0 endValue:0 duration:0.3 complete:^(UILabel *label, CGFloat value) {
            label.text = [NSString stringWithFormat:@"%.0f%%", value];
        }];
    } else {
        self.label.text = [NSString stringWithFormat:@"%.0f%%", (_progress * 100.0)];
    }
    [self bringSubviewToFront:self.thumbView];
    //
    self.lineView.layer.borderColor = self.lineColor.CGColor;
    self.lineView.layer.borderWidth = self.lineWidth;
    self.lineView.layer.cornerRadius = self.frame.size.width / 2;
    [self sendSubviewToBack:self.lineView];
    
    self.progress = 0.0;
}

#pragma mark - KVO

// 对angle添加KVO，有时候手势过快在continueTrackingWithTouch方法中不能及时限定转动，所以需要通过KVO对angle做实时监控
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSNumber *newAngle = [change valueForKey:@"new"];
    if ([keyPath isEqualToString:@"angle"]) {
        if (newAngle.doubleValue >= 300 || self.angle >= 300) {
            self.lockClockwise = YES;
        } else {
            self.lockClockwise = NO;
        }
        
        if (newAngle.doubleValue <= 60 || self.angle <= 60) {
            self.lockAntiClockwise = YES;
        } else {
            self.lockAntiClockwise = NO;
        }
    }
}

@end
