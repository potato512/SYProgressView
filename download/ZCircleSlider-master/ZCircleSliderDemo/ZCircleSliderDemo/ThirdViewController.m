//
//  ThirdViewController.m
//  ZCircleSliderDemo
//
//  Created by zhangshaoyu on 2018/11/28.
//  Copyright © 2018年 Jixin. All rights reserved.
//

#import "ThirdViewController.h"
#import "ZCircleSlider.h"
#import "DefaultDefine.h"

@interface ThirdViewController ()

@property (nonatomic, strong) ZCircleSlider *circleSlider;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)setUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    CGFloat size = 300.0;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, scrollView.frame.size.width, 44.0)];
    [scrollView addSubview:label];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"重复，顺时针，逆时针";
    
    UIView *currentView = label;
    
    ZCircleSlider *circleSlider = [[ZCircleSlider alloc] initWithFrame:CGRectMake((scrollView.frame.size.width - size) / 2, (currentView.frame.origin.y + currentView.frame.size.height), size, size)];
    [scrollView addSubview:circleSlider];
    circleSlider.value = 0.0;
    circleSlider.backgroundColor = [UIColor yellowColor];
    circleSlider.minimumTrackTintColor = [UIColor redColor];
    circleSlider.maximumTrackTintColor = [UIColor greenColor];
    circleSlider.backgroundTintColor = [UIColor blueColor];
    circleSlider.thumbTintColor = [UIColor redColor];
    circleSlider.circleBorderWidth = 8.0;
    circleSlider.thumbRadius = 30;
    circleSlider.thumbExpandRadius = 40;
    circleSlider.circleRadius = size / 2.0;
    circleSlider.showValue = YES;
    circleSlider.canRepeat = YES;
    circleSlider.canCounterClockWise = YES;

    currentView = circleSlider;
    
    //
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (currentView.frame.origin.y + currentView.frame.size.height), scrollView.frame.size.width, 44.0)];
    [scrollView addSubview:label2];
    label2.textColor = [UIColor blackColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"重复，顺时针，不可逆时针";
    
    currentView = label2;
    
    ZCircleSlider *circleSlider2 = [[ZCircleSlider alloc] initWithFrame:CGRectMake((scrollView.frame.size.width - size) / 2, (currentView.frame.origin.y + currentView.frame.size.height), size, size)];
    [scrollView addSubview:circleSlider2];
    circleSlider2.value = 0.0;
    circleSlider2.circleRadius = size / 2.0;
    circleSlider2.thumbRadius = 30;
    circleSlider2.thumbExpandRadius = 40;
    circleSlider2.showValue = YES;
    circleSlider2.canRepeat = YES;
//    circleSlider2.canCounterClockWise = NO;
    
    currentView = circleSlider2;
    
    //
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (currentView.frame.origin.y + currentView.frame.size.height), scrollView.frame.size.width, 44.0)];
    [scrollView addSubview:label3];
    label3.textColor = [UIColor blackColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"不重复，顺时针，逆时针";
    
    currentView = label3;
    
    ZCircleSlider *circleSlider3 = [[ZCircleSlider alloc] initWithFrame:CGRectMake((scrollView.frame.size.width - size) / 2, (currentView.frame.origin.y + currentView.frame.size.height), size, size)];
    [scrollView addSubview:circleSlider3];
    circleSlider3.value = 0.0;
    circleSlider3.circleRadius = size / 2.0;
    circleSlider3.thumbRadius = 30;
    circleSlider3.thumbExpandRadius = 40;
    circleSlider3.showValue = YES;
    circleSlider3.canRepeat = NO;
    circleSlider3.canCounterClockWise = YES;
    
    currentView = circleSlider3;
    
    //
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (currentView.frame.origin.y + currentView.frame.size.height), scrollView.frame.size.width, 44.0)];
    [scrollView addSubview:label4];
    label4.textColor = [UIColor blackColor];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.text = @"不重复，顺时针，不可逆时针";
    
    currentView = label4;
    
    ZCircleSlider *circleSlider4 = [[ZCircleSlider alloc] initWithFrame:CGRectMake((scrollView.frame.size.width - size) / 2, (currentView.frame.origin.y + currentView.frame.size.height), size, size)];
    [scrollView addSubview:circleSlider4];
    circleSlider4.value = 0.0;
    circleSlider4.circleRadius = size / 2.0;
    circleSlider4.thumbRadius = 30;
    circleSlider4.thumbExpandRadius = 40;
    circleSlider4.showValue = YES;
    circleSlider4.canRepeat = NO;
    circleSlider4.canCounterClockWise = NO;
    circleSlider4.showGradient = YES;
    circleSlider4.colorsGradient = @[[UIColor whiteColor], [UIColor yellowColor], [UIColor redColor]];
    
    currentView = circleSlider4;
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, currentView.frame.origin.y + currentView.frame.size.height + 20.0);
}

@end
