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
#import "ChartView.h"

@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) SYLineProgressView *lineProgress;
@property (nonatomic, strong) SYLineProgressView *lineProgress2;
@property (nonatomic, strong) SYWaveProgressView *waveProgress;
@property (nonatomic, strong) SYPieProgressView *pieProgress;
@property (nonatomic, strong) SYRingProgressView *ringProgress;
@property (nonatomic, strong) SYRingProgressView *ringProgress2;
@property (nonatomic, strong) SYRingProgressView *ringProgress3;
@property (nonatomic, strong) SYRingProgressView *ringProgress4;
@property (nonatomic, strong) SYRingProgressView *ringProgress5;

@property (nonatomic, strong) ChartView *chartView;

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
    CGFloat originXY = 20.0;
    
    self.lineProgress = [[SYLineProgressView alloc] initWithFrame:CGRectMake(originXY, originXY, (self.view.frame.size.width - originXY * 2), 20)];
    [self.view addSubview:self.lineProgress];
    self.lineProgress.layer.cornerRadius = 10;
    self.lineProgress.lineWidth = 2.0;
    self.lineProgress.lineColor = [UIColor redColor];
    self.lineProgress.progressColor = [UIColor yellowColor];
    self.lineProgress.defaultColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.lineProgress.label.textColor = [UIColor greenColor];
    self.lineProgress.label.hidden = NO;
    self.lineProgress.animationText = YES;
    [self.lineProgress initializeProgress];
    
    UIView *currentView = self.lineProgress;
    
    self.lineProgress2 = [[SYLineProgressView alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + originXY), currentView.frame.size.width, currentView.frame.size.height)];
    [self.view addSubview:self.lineProgress2];
    self.lineProgress2.layer.cornerRadius = 10;
    self.lineProgress2.lineWidth = 2.0;
    self.lineProgress2.lineColor = [UIColor redColor];
    self.lineProgress2.progressColor = [UIColor redColor];
    self.lineProgress2.defaultColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.lineProgress2.label.textColor = [UIColor greenColor];
    self.lineProgress2.label.hidden = NO;
    self.lineProgress2.animationText = YES;
    self.lineProgress2.showGradient = YES;
    self.lineProgress2.colorsGradient = @[[UIColor greenColor], [UIColor redColor]];
    self.lineProgress2.showSpace = NO;
    self.lineProgress2.spaceWidth = 1.0;
    [self.lineProgress2 initializeProgress];
    
    currentView = self.lineProgress2;
    
    
    self.waveProgress = [[SYWaveProgressView alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + originXY), 120.0, 120.0)];
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
    
    self.pieProgress = [[SYPieProgressView alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + originXY), 100.0, 100.0)];
    [self.view addSubview:self.pieProgress];
    self.pieProgress.backgroundColor = [UIColor greenColor];
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
    
    //
    CGFloat sizeRing = (self.view.frame.size.width - originXY * 5) / 4;
    
    self.ringProgress = [[SYRingProgressView alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + originXY), sizeRing, sizeRing)];
    [self.view addSubview:self.ringProgress];
    self.ringProgress.backgroundColor = UIColor.clearColor;
    self.ringProgress.lineColor = [UIColor colorWithWhite:0.4 alpha:0.2];
    self.ringProgress.lineWidth = 12;
    self.ringProgress.lineRound = YES;
    self.ringProgress.isAnimation = YES;
    self.ringProgress.colorsGradient = @[UIColorWithHexadecimalString(@"#2B5FD5"), UIColorWithHexadecimalString(@"0x56DDEC")];
    self.ringProgress.showGradient = YES;
    [self.ringProgress initializeProgress];
//    [self performSelector:@selector(ringShow) withObject:nil afterDelay:1.0];
    currentView = self.ringProgress;
    //
    self.ringProgress2 = [[SYRingProgressView alloc] initWithFrame:CGRectMake((currentView.frame.origin.x + currentView.frame.size.width + originXY), currentView.frame.origin.y, sizeRing, sizeRing)];
    [self.view addSubview:self.ringProgress2];
    self.ringProgress2.backgroundColor = UIColor.clearColor;
    self.ringProgress2.lineColor = [UIColor colorWithWhite:0.4 alpha:0.2];
    self.ringProgress2.lineWidth = 12;
    self.ringProgress2.lineRound = YES;
    self.ringProgress2.isAnimation = YES;
    self.ringProgress2.colorsGradient = @[UIColorWithHexadecimalString(@"#2B5FD5"), UIColorWithHexadecimalString(@"0x56DDEC")];
    self.ringProgress2.showGradient = YES;
    self.ringProgress2.isClockwise = NO;
    self.ringProgress2.startAngle = 270;
    self.ringProgress2.endAngle = -90.0;
    [self.ringProgress2 initializeProgress];
    currentView = self.ringProgress2;
    //
    self.ringProgress3 = [[SYRingProgressView alloc] initWithFrame:CGRectMake((currentView.frame.origin.x + currentView.frame.size.width + originXY), currentView.frame.origin.y, sizeRing, sizeRing)];
    [self.view addSubview:self.ringProgress3];
    self.ringProgress3.backgroundColor = UIColor.clearColor;
    self.ringProgress3.lineColor = [UIColor colorWithWhite:0.4 alpha:0.2];
    self.ringProgress3.lineWidth = 12;
    self.ringProgress3.lineRound = YES;
    self.ringProgress3.isAnimation = YES;
    self.ringProgress3.colorsGradient = @[UIColorWithHexadecimalString(@"#2B5FD5"), UIColorWithHexadecimalString(@"0x56DDEC")];
    self.ringProgress3.showGradient = YES;
    self.ringProgress3.startAngle = -20.0;
    self.ringProgress3.endAngle = 200.0;
    [self.ringProgress3 initializeProgress];
    currentView = self.ringProgress3;
    //
    self.ringProgress4 = [[SYRingProgressView alloc] initWithFrame:CGRectMake((currentView.frame.origin.x + currentView.frame.size.width + originXY), currentView.frame.origin.y, sizeRing, sizeRing)];
    [self.view addSubview:self.ringProgress4];
    self.ringProgress4.backgroundColor = UIColor.clearColor;
    self.ringProgress4.lineColor = [UIColor colorWithWhite:0.4 alpha:0.2];
    self.ringProgress4.lineWidth = 12;
    self.ringProgress4.lineRound = YES;
    self.ringProgress4.isAnimation = YES;
    self.ringProgress4.colorsGradient = @[UIColorWithHexadecimalString(@"#2B5FD5"), UIColorWithHexadecimalString(@"0x56DDEC")];
    self.ringProgress4.showGradient = YES;
//    self.ringProgress4.isClockwise = NO;
    self.ringProgress4.startAngle = -220.0;
    self.ringProgress4.endAngle = 40.0;
    [self.ringProgress4 initializeProgress];
    
    currentView = self.ringProgress;
    
    //
    self.ringProgress5 = [[SYRingProgressView alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + originXY), 100.0, 100.0)];
    [self.view addSubview:self.ringProgress5];
    self.ringProgress5.backgroundColor = UIColor.clearColor;
    self.ringProgress5.lineColor = [UIColor colorWithWhite:0.4 alpha:0.2];
    self.ringProgress5.lineWidth = 12;
    self.ringProgress5.lineRound = YES;
    self.ringProgress5.isAnimation = YES;
    self.ringProgress5.progressColor = UIColor.purpleColor;
    [self.ringProgress5 initializeProgress];
    
    currentView = self.ringProgress5;
    
    
//    self.chartView = [[ChartView alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + originXY), 100.0, 100.0)];
//    [self.view addSubview:self.chartView];
//    self.chartView.progress = 0.3;
//
//
//
//    currentView = self.chartView;
    
    self.sliderView = [[UISlider alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + originXY), (self.view.frame.size.width - currentView.frame.origin.x * 2), 10)];
    [self.view addSubview:self.sliderView];
    self.sliderView.value = 0.0;
    [self.sliderView addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
}

- (void)sliderClick:(UISlider *)slider
{
    CGFloat value = slider.value;
    
    self.progress = value;
    self.lineProgress.progress = self.progress;
    self.lineProgress2.progress = self.progress;
    self.waveProgress.progress = self.progress;
    self.pieProgress.progress = self.progress;
    self.ringProgress.progress = self.progress;
    self.ringProgress2.progress = self.progress;
    self.ringProgress3.progress = self.progress;
    self.ringProgress4.progress = self.progress;
    self.ringProgress5.progress = self.progress;
    
    self.chartView.progress = self.progress;
}

static CGFloat ring = 0.2;
- (void)ringShow
{
    if (ring > 1.0) {
        return;
    }
    self.ringProgress.progress = ring;
    ring += 0.1;
    [self performSelector:@selector(ringShow) withObject:nil afterDelay:1.0];
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
    self.lineProgress2.progress = self.progress;
    self.waveProgress.progress = self.progress;
    self.pieProgress.progress = self.progress;
    self.ringProgress.progress = self.progress;
    self.ringProgress2.progress = self.progress;
    self.ringProgress3.progress = self.progress;
    self.ringProgress4.progress = self.progress;
    self.ringProgress5.progress = self.progress;
    
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
    self.lineProgress2.progress = self.progress;
    self.waveProgress.progress = self.progress;
    self.pieProgress.progress = self.progress;
    self.ringProgress.progress = self.progress;
    self.ringProgress2.progress = self.progress;
    self.ringProgress3.progress = self.progress;
    self.ringProgress4.progress = self.progress;
    self.ringProgress5.progress = self.progress;
    
    if (self.progress >= 1.0) {
        [self stopTimer];
        return;
    }
}

@end
