//
//  ViewController.m
//  STLoopProgressView
//
//  Created by tangjr on 6/12/16.
//  Copyright © 2016 saitjr. All rights reserved.
//

#import "ViewController.h"
#import "STLoopProgressView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet STLoopProgressView *loopProgressView;
- (IBAction)sliderValueChanged:(UISlider *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 300, 300)];
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
    progresslayer.frame = CGRectMake(0.0, 0.0, 300, 300);
    progresslayer.backgroundColor = [UIColor greenColor].CGColor;
    //  添加渐变色到创建的 UIView 上去
    gradientLayer.mask = progresslayer;
    [myView.layer addSublayer:gradientLayer];

    
    //
    self.loopProgressView.persentage = 0.0;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.loopProgressView.persentage = sender.value;
}

@end
