//
//  FirstViewController.m
//  ZCircleSliderDemo
//
//  Created by ZhangBob on 01/06/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import "FirstViewController.h"
#import "ZCircleSlider.h"
#import "DefaultDefine.h"

@interface FirstViewController ()

@property (nonatomic, strong) ZCircleSlider *circleSlider;
@property (nonatomic, strong) UILabel *currentValueLabel;
@property (nonatomic, strong) UILabel *finalValueLabel;
@property (nonatomic, strong) UISlider *progressSlider;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.circleSlider];
    [self.view addSubview:self.currentValueLabel];
    [self.view addSubview:self.finalValueLabel];
    [self.view addSubview:self.progressSlider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ZCircleSlider *)circleSlider {
    if (!_circleSlider) {
        _circleSlider = [[ZCircleSlider alloc] initWithFrame:CGRectMake((kScreenWidth - 300) / 2.0, (kScreenHeight - 300) / 2.0, 300, 300)];
        _circleSlider.minimumTrackTintColor = kUIColorFromRGB(0x1482f0);
        _circleSlider.maximumTrackTintColor = [UIColor greenColor];
        _circleSlider.backgroundTintColor = [UIColor colorWithWhite:0 alpha:0.2];
        _circleSlider.circleBorderWidth = 5.0f;
        _circleSlider.thumbRadius = 6;
        _circleSlider.thumbExpandRadius = 12.5;
        _circleSlider.thumbTintColor = [UIColor redColor];
        _circleSlider.circleRadius = 290 / 2.0 + 2;
        _circleSlider.value = 0;
        _circleSlider.loadProgress = 0;
        _circleSlider.canRepeat = YES;
        [_circleSlider addTarget:self
                          action:@selector(circleSliderTouchDown:)
                forControlEvents:UIControlEventTouchDown];
        [_circleSlider addTarget:self
                          action:@selector(circleSliderValueChanging:)
                forControlEvents:UIControlEventValueChanged];
        [_circleSlider addTarget:self
                          action:@selector(circleSliderValueDidChanged:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _circleSlider;
}

- (UILabel *)currentValueLabel {
    if (!_currentValueLabel) {
        _currentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2.0, (kScreenHeight - 30) / 2.0, 100, 30)];
        _currentValueLabel.textAlignment = NSTextAlignmentCenter;
        _currentValueLabel.text = @"当前值：0";
    }
    return _currentValueLabel;
}

- (UILabel *)finalValueLabel {
    if (!_finalValueLabel) {
        _finalValueLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2.0, kScreenHeight - 90, 100, 30)];
        _finalValueLabel.textAlignment = NSTextAlignmentCenter;
        _finalValueLabel.text = @"最终值：0";
    }
    return _finalValueLabel;
}

- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(53, kScreenHeight - 30, kScreenWidth - 53 * 2, 18)];
        _progressSlider.backgroundColor = [UIColor clearColor];
        _progressSlider.minimumValue = 0;
        _progressSlider.maximumValue = 1;
        _progressSlider.value = 0;
        [_progressSlider addTarget:self
                            action:@selector(progressSliderValueChanging:)
                  forControlEvents:UIControlEventValueChanged];
        
        [_progressSlider addTarget:self
                            action:@selector(progressSliderValueDidChanged:)
                  forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _progressSlider;
}

#pragma mark - action

- (IBAction)circleSliderTouchDown:(ZCircleSlider *)slider {
    if (!slider.interaction) {
        return;
    }
    
}

- (IBAction)circleSliderValueChanging:(ZCircleSlider *)slider {
    if (!slider.interaction) {
        return;
    }
    self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f",slider.value * 100];
    self.progressSlider.value = slider.value;
}

- (IBAction)circleSliderValueDidChanged:(ZCircleSlider *)slider {
    if (!slider.interaction) {
        return;
    }
    self.finalValueLabel.text = [NSString stringWithFormat:@"最终值：%.0f",slider.value * 100];
}

- (IBAction)progressSliderValueChanging:(UISlider *)slider {
    self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f",slider.value * 100];
    self.circleSlider.value = slider.value;
    self.circleSlider.loadProgress = slider.value + 0.2;
}

- (IBAction)progressSliderValueDidChanged:(UISlider *)slider {
    self.progressSlider.value = slider.value;
    self.finalValueLabel.text = [NSString stringWithFormat:@"最终值：%.0f",slider.value * 100];
}

@end
