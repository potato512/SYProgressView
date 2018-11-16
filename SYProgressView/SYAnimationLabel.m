//
//  SYAnimationLabel.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/11/16.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import "SYAnimationLabel.h"

@interface SYAnimationLabel ()

@property (nonatomic, strong) CADisplayLink *playLink;
@property (nonatomic, assign) NSInteger displayPerSecond;

@property (nonatomic, assign) CGFloat valueStart;
@property (nonatomic, assign) CGFloat valueEnd;

@property (nonatomic, assign) CGFloat valueLast;
@property (nonatomic, assign) CGFloat valueStep;

@property (nonatomic, copy) void (^complete)(UILabel *label, CGFloat value);

@end

@implementation SYAnimationLabel

#pragma mark - 方法

/**
 动画数字改变
 
 @param fromValue 开始数值
 @param toValue 结束数值
 @param duration 动画时间
 @param complete 完成回调
 */
- (void)animationTextStartValue:(CGFloat)fromValue endValue:(CGFloat)toValue duration:(CGFloat)duration complete:(void (^)(UILabel *label, CGFloat value))complete
{
    self.duration = duration;
    if (self.duration <= 0.0) {
        self.duration = 2.0;
    }
    self.displayPerSecond = 30;
    self.valueStart = fromValue;
    self.valueEnd = toValue;
    self.complete = [complete copy];
    
    self.valueLast = self.valueStart;
    self.valueStep = (self.valueEnd - self.valueStart)/(self.duration==0?1:(self.displayPerSecond*self.duration));
    
    if (self.playLink) {
        [self.playLink invalidate];
        self.playLink = nil;
    }
    self.playLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(countingAction)];
    if (@available(iOS 10.0, *)) {
        self.playLink.preferredFramesPerSecond = self.displayPerSecond;
    } else {
        // Fallback on earlier versions
        self.playLink.frameInterval = self.displayPerSecond;
    }
    [self.playLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.playLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
}

- (void)countingAction {
    self.valueLast += self.valueStep;
    
    if (self.valueStart < self.valueEnd) {
        if (self.valueLast >= self.valueEnd) {
            [self stopDisplayLink];
        }
    } else {
        if (self.valueLast <= self.valueEnd) {
            [self stopDisplayLink];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.complete) {
            self.complete(self, self.valueLast);
        }
    });
}

- (void)stopDisplayLink
{
    if (self.playLink) {
        [self.playLink invalidate];
        self.playLink = nil;
    }
    self.valueLast = self.valueEnd;
}

@end
