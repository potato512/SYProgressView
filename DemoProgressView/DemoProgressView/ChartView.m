//
//  ChartView.m
//  DemoProgressView
//
//  Created by zhangshaoyu on 2019/3/20.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "ChartView.h"

#define SELF_WIDTH CGRectGetWidth(self.bounds)
#define SELF_HEIGHT CGRectGetHeight(self.bounds)

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@interface ChartView ()

@property (nonatomic, strong) CAGradientLayer *colorLayer; // 进度
@property (nonatomic, strong) CAShapeLayer *maskLayer; // 遮罩

@end

@implementation ChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.lightGrayColor;
        

        [self.layer addSublayer:self.colorLayer];
        self.colorLayer.mask = self.maskLayer;
        
        [self settUI];
        
        self.maskLayer.strokeEnd = 0.5;
    }
    
    return self;
}

#pragma mark - getter

- (CAGradientLayer *)colorLayer
{
    if (_colorLayer == nil) {
        _colorLayer = [CAGradientLayer layer];
        
        _colorLayer.frame = CGRectMake(0, 0, SELF_WIDTH, SELF_HEIGHT);
        
        _colorLayer.colors = @[(id)UIColor.yellowColor.CGColor,
                         (id)UIColor.redColor.CGColor];
        
        _colorLayer.startPoint = CGPointMake(0, 0);
        _colorLayer.endPoint = CGPointMake(1, 0);
        _colorLayer.locations = @[@0.1, @0.6];
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

#pragma mark - 方法

/**
 为view的layer添加蒙层mask。
 */
- (void)settUI
{
    CAShapeLayer *layer = [self generateMaskLayer];
    [self.layer addSublayer:layer];
    self.layer.mask = layer;
}

/**
 创建圆环，适合做蒙层，也适合画纯色图形
 
 @return CAShapeLayer
 */
- (CAShapeLayer *)generateMaskLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    layer.frame = self.bounds;
    
    UIBezierPath *paths = nil;
    paths = [UIBezierPath bezierPathWithArcCenter:CGPointMake(SELF_WIDTH / 2, SELF_HEIGHT / 2) radius:SELF_WIDTH / 2.5 startAngle:DEGREES_TO_RADOANS(-220) endAngle:DEGREES_TO_RADOANS(40) clockwise:YES];
    layer.lineWidth = 20;
    
    layer.fillColor = [UIColor clearColor].CGColor;
    
    layer.strokeColor = [UIColor blackColor].CGColor;
    
    layer.lineCap = kCALineCapRound;
    
    layer.path = paths.CGPath;
    
    return layer;
}

#pragma mark - setter

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
//    [CATransaction begin];
//    [CATransaction setDisableActions:NO];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//    [CATransaction setAnimationDuration:0.3];
//    _muchColorMashLayer.strokeEnd = _progress;
//    [CATransaction commit];
    
    _maskLayer.strokeEnd = _progress;
}

UIColor *UIColorWithHexadecimalString(NSString *color)
{
    NSString *colorString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if (6 > colorString.length)
    {
        return [UIColor clearColor];
    }
    
    if ([colorString hasPrefix:@"0X"] | [colorString hasPrefix:@"0x"] | [colorString hasPrefix:@"OX"] | [colorString hasPrefix:@"Ox"] | [colorString hasPrefix:@"oX"] | [colorString hasPrefix:@"ox"])
    {
        colorString = [colorString substringFromIndex:2];
    }
    if ([colorString hasPrefix:@"#"])
    {
        colorString = [colorString substringFromIndex:1];
    }
    if (6 != colorString.length)
    {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *redString = [colorString substringWithRange:range];
    range.location = 2;
    NSString *greenString = [colorString substringWithRange:range];
    range.location = 4;
    NSString *blueString = [colorString substringWithRange:range];
    
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:redString] scanHexInt:&red];
    [[NSScanner scannerWithString:greenString] scanHexInt:&green];
    [[NSScanner scannerWithString:blueString] scanHexInt:&blue];
    
    UIColor *result = [UIColor colorWithRed:((float)(red) / 255.0) green:((float)(green) / 255.0) blue:((float)(blue) / 255.0) alpha:1.0];
    return result;
}

@end
