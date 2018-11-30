//
//  ViewController.m
//  STLoopProgressView
//
//  Created by tangjr on 6/12/16.
//  Copyright © 2016 saitjr. All rights reserved.
//

#import "ViewController.h"
#import "STLoopProgressView.h"

#import "ColorView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet STLoopProgressView *loopProgressView;
- (IBAction)sliderValueChanged:(UISlider *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self gradientlayer];
    [self ringlayer];
//    [self circlelayer];
    
//    CGRect rect = CGRectMake(20, 60, 180, 180);
//    ColorView *colorView = [[ColorView alloc] initWithFrame:rect];
//    [self.view addSubview:colorView];
    
    //
    self.loopProgressView.persentage = 0.0;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.loopProgressView.persentage = sender.value;
}

- (void)gradientlayer
{
    CGRect rect = CGRectMake(20, 60, 180, 180);
    
    //
    UIView *myView = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:myView];
    
    //  创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //  设置 gradientLayer 的 Frame
    gradientLayer.frame = myView.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(id)[UIColor yellowColor].CGColor,
                             (id)[UIColor redColor].CGColor
                             ];
    //  设置三种颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    //  设置渐变颜色方向
    //    gradientLayer.startPoint = CGPointMake(0, 0); // 左上
    //    gradientLayer.endPoint = CGPointMake(0, 1); // 左下
    //    gradientLayer.endPoint = CGPointMake(1, 0); // 右上
    //    gradientLayer.endPoint = CGPointMake(1, 1); // 右下
    //    gradientLayer.startPoint = CGPointMake(0, 0); // 左上
    //    gradientLayer.endPoint = CGPointMake(1, 0); // 左上
    gradientLayer.startPoint = CGPointMake(0.0, 0.5); // 左上
    gradientLayer.endPoint = CGPointMake(0.5, 1.0); // 左上
    // 1
    //    CAShapeLayer *progresslayer = [CAShapeLayer layer];
    //    progresslayer.frame = myView.bounds;
    ////    progresslayer.lineWidth = 30;
    //    progresslayer.fillColor = [UIColor clearColor].CGColor;
    ////    UIBezierPath *path = [UIBezierPath bezierPathWithRect:myView.bounds];
    ////    progresslayer.path = path.CGPath;
    // 2
    CALayer *progresslayer = [CALayer layer];
    progresslayer.frame = rect;
    progresslayer.backgroundColor = [UIColor greenColor].CGColor;
    //  添加渐变色到创建的 UIView 上去
    gradientLayer.mask = progresslayer;
    [myView.layer addSublayer:gradientLayer];
}

- (void)ringlayer
{
    CGRect rect = CGRectMake(20, 60, 180, 180);
    
    // 1 图层
    CALayer *layer = [CALayer layer];
    layer.frame = rect;
    layer.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:layer];
    
//    CGFloat width = rect.size.width / 2;
//    CGFloat height = rect.size.height;
//    // 2 颜色渐变
//    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
//    gradientLayer1.frame = CGRectMake(0, 0, width, height);
//    gradientLayer1.startPoint = CGPointMake(1.0, 0.0);
//    gradientLayer1.endPoint = CGPointMake(0.0, 1.0);
//    [gradientLayer1 setColors:@[(id)[UIColor colorWithRed:220 green:20 blue:60 alpha:0.5].CGColor, (id)[UIColor colorWithRed:220 green:20 blue:60 alpha:1.0].CGColor]];
//    [layer addSublayer:gradientLayer1];
//    //
//    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
//    gradientLayer2.frame = CGRectMake(width, 0, width, height);
//    gradientLayer2.startPoint = CGPointMake(0.0, 0.0);
//    gradientLayer2.endPoint = CGPointMake(0.0, 1.0);
//    [gradientLayer2 setColors:@[(id)[UIColor whiteColor].CGColor, (id)[UIColor colorWithRed:220 green:20 blue:60 alpha:0.5].CGColor]];
//    [layer addSublayer:gradientLayer2];
    
    // 3 创建圆环遮罩
    CGFloat lineWidth = 5;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.strokeStart = 0.0;
    shapeLayer.strokeEnd = 1.0;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineDashPhase = 0.8;
    [layer setMask:shapeLayer];

    // 4
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:(rect.size.width - lineWidth * 2) / 2 startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
//    gradientLayer1.shadowPath = bezierPath.CGPath;
//    gradientLayer2.shadowPath = bezierPath.CGPath;
    shapeLayer.path = bezierPath.CGPath;
}

- (void)circlelayer
{
    CGRect rect = CGRectMake(20, 60, 180, 180);
    
    // 1 图层
    CALayer *layer = [CALayer layer];
    layer.frame = rect;
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    // 2 颜色渐变
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, rect.size.width / 2, rect.size.height / 2);
    gradientLayer1.startPoint = CGPointMake(1, 1);
    gradientLayer1.endPoint = CGPointMake(0, 0);
    [gradientLayer1 setColors:@[(id)[UIColor whiteColor].CGColor, (id)[UIColor redColor].CGColor]];
    [layer addSublayer:gradientLayer1];
    //
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(rect.size.width / 2, 0, rect.size.width / 2, rect.size.height / 2);
    gradientLayer2.startPoint = CGPointMake(0, 1);
    gradientLayer2.endPoint = CGPointMake(1, 0);
    [gradientLayer2 setColors:@[(id)[UIColor whiteColor].CGColor, (id)[UIColor redColor].CGColor]];
    [layer addSublayer:gradientLayer2];
    //
    CAGradientLayer *gradientLayer3 = [CAGradientLayer layer];
    gradientLayer3.frame = CGRectMake(rect.size.width / 2, rect.size.height / 2, rect.size.width / 2, rect.size.height / 2);
    gradientLayer3.startPoint = CGPointMake(0, 0);
    gradientLayer3.endPoint = CGPointMake(1, 1);
    [gradientLayer3 setColors:@[(id)[UIColor whiteColor].CGColor, (id)[UIColor redColor].CGColor]];
    [layer addSublayer:gradientLayer3];
    //
    CAGradientLayer *gradientLayer4 = [CAGradientLayer layer];
    gradientLayer4.frame = CGRectMake(0, rect.size.height / 2, rect.size.width / 2, rect.size.height / 2);
    gradientLayer4.startPoint = CGPointMake(1, 0);
    gradientLayer4.endPoint = CGPointMake(0, 1);
    [gradientLayer4 setColors:@[(id)[UIColor whiteColor].CGColor, (id)[UIColor redColor].CGColor]];
    [layer addSublayer:gradientLayer4];
    
    // 3 创建圆环遮罩
//    CGFloat lineWidth = 20;
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
//    shapeLayer.lineWidth = lineWidth;
//    shapeLayer.strokeStart = 0.0;
//    shapeLayer.strokeEnd = 1.0;
//    shapeLayer.lineCap = kCALineCapRound;
//    shapeLayer.lineDashPhase = 0.8;
//    [layer setMask:shapeLayer];
//
//    // 4
//    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:(rect.size.width - lineWidth * 2) / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
//    gradientLayer1.shadowPath = bezierPath.CGPath;
//    gradientLayer2.shadowPath = bezierPath.CGPath;
//    shapeLayer.path = bezierPath.CGPath;
}



@end
