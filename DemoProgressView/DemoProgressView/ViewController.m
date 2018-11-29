//
//  ViewController.m
//  DemoProgressView
//
//  Created by zhangshaoyu on 2018/11/15.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "SYLineProgressView.h"
#import "SYWaveProgressView.h"
#import "SYPieProgressView.h"
#import "SYRingProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) SYLineProgressView *lineProgress;
@property (nonatomic, strong) SYWaveProgressView *waveProgress;
@property (nonatomic, strong) SYPieProgressView *pieProgress;
@property (nonatomic, strong) SYRingProgressView *ringProgress;

@property (nonatomic, strong) UISlider *sliderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *startItem = [[UIBarButtonItem alloc] initWithTitle:@"start" style:UIBarButtonItemStyleDone target:self action:@selector(startTimer)];
    UIBarButtonItem *stopItem = [[UIBarButtonItem alloc] initWithTitle:@"stop" style:UIBarButtonItemStyleDone target:self action:@selector(stopTimer)];
    self.navigationItem.rightBarButtonItems = @[stopItem, startItem];
    
    self.navigationItem.title = @"进度";
    
    [self setUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)setUI
{
    self.lineProgress = [[SYLineProgressView alloc] initWithFrame:CGRectMake(20.0, 20.0, (self.view.frame.size.width - 40.0), 20)];
    [self.view addSubview:self.lineProgress];
    self.lineProgress.layer.cornerRadius = 10;
    self.lineProgress.lineWidth = 2.0;
    self.lineProgress.lineColor = [UIColor redColor];
    self.lineProgress.progressColor = [UIColor redColor];
    self.lineProgress.defaultColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.lineProgress.label.textColor = [UIColor greenColor];
    self.lineProgress.label.hidden = NO;
    self.lineProgress.animationText = YES;
    self.lineProgress.showGradient = YES;
    self.lineProgress.colorsGradient = @[[UIColor greenColor], [UIColor redColor]];
    self.lineProgress.showSpace = NO;
    self.lineProgress.spaceWidth = 1.0;
    [self.lineProgress initializeProgress];
    
    UIView *currentView = self.lineProgress;
    
    self.waveProgress = [[SYWaveProgressView alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + 20.0), 120.0, 120.0)];
    [self.view addSubview:self.waveProgress];
    self.waveProgress.layer.cornerRadius = 60.0;
    self.waveProgress.backgroundColor = [UIColor greenColor];
    self.waveProgress.lineColor = [UIColor purpleColor];
    self.waveProgress.lineWidth = 3.0;
    self.waveProgress.progressColor = [UIColor redColor];
    self.waveProgress.defaultColor = [UIColor yellowColor];
    self.waveProgress.label.textColor = [UIColor greenColor];
    self.waveProgress.label.hidden = NO;
    self.waveProgress.showBorderline = YES;
    [self.waveProgress initializeProgress];
    
    currentView = self.waveProgress;
    
    self.pieProgress = [[SYPieProgressView alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + 20.0), 100.0, 100.0)];
    [self.view addSubview:self.pieProgress];
    self.pieProgress.lineColor = [UIColor purpleColor];
    self.pieProgress.lineWidth = 5.0;
    self.pieProgress.progressColor = [UIColor redColor];
    self.pieProgress.defaultColor = [UIColor yellowColor];
    self.pieProgress.label.textColor = [UIColor greenColor];
    self.pieProgress.label.hidden = NO;
    self.pieProgress.showBorderline = YES;
    self.pieProgress.showSpace = YES;
    self.pieProgress.spaceWidth = 2.0;
    [self.pieProgress initializeProgress];
    
    currentView = self.pieProgress;
    
    self.ringProgress = [[SYRingProgressView alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + 20.0), 100.0, 100.0)];
    [self.view addSubview:self.ringProgress];
    self.ringProgress.lineColor = [UIColor colorWithWhite:0.4 alpha:0.2];
    self.ringProgress.lineWidth = 10.0;
    self.ringProgress.progressColor = [UIColor redColor];
    self.ringProgress.defaultColor = [UIColor yellowColor];
    self.ringProgress.label.textColor = [UIColor greenColor];
    self.ringProgress.label.hidden = NO;
    self.ringProgress.reduceAngle = 50;
    [self.ringProgress initializeProgress];
    
    currentView = self.ringProgress;
    
    self.sliderView = [[UISlider alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + 20.0), (self.view.frame.size.width - currentView.frame.origin.x * 2), 10)];
    [self.view addSubview:self.sliderView];
    self.sliderView.value = 0.0;
    [self.sliderView addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
}

- (void)sliderClick:(UISlider *)slider
{
    CGFloat value = slider.value;
    
    self.progress = value;
    self.lineProgress.progress = self.progress;
    self.waveProgress.progress = self.progress;
    self.pieProgress.progress = self.progress;
    self.ringProgress.progress = self.progress;
}

#pragma mark - 定时器

- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)startTimer
{
    self.progress = 0.0;
    self.lineProgress.progress = self.progress;
    self.waveProgress.progress = self.progress;
    self.pieProgress.progress = self.progress;
    self.ringProgress.progress = self.progress;
    
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)stopTimer
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)progressChange
{
    CGFloat step = (arc4random() % 10 + 1) / 100.0;
    self.progress += step;
    NSLog(@"1 progress = %f", self.progress);
    if (self.progress > 1.1) {
        self.progress = 1.0;
    }
    NSLog(@"2 progress = %f", self.progress);
    self.sliderView.value = self.progress;
    self.lineProgress.progress = self.progress;
    self.waveProgress.progress = self.progress;
    self.pieProgress.progress = self.progress;
    self.ringProgress.progress = self.progress;
    if (self.progress >= 1.0) {
        [self stopTimer];
        return;
    }
}

@end
