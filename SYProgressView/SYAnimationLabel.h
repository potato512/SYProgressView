//
//  SYAnimationLabel.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/11/16.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYAnimationLabel : UILabel

@property (nonatomic, assign) NSTimeInterval duration;

/**
 动画数字改变
 
 @param fromValue 开始数值
 @param toValue 结束数值
 @param duration 动画时间
 @param complete 完成回调
 */
- (void)animationTextStartValue:(CGFloat)fromValue endValue:(CGFloat)toValue duration:(CGFloat)duration complete:(void (^)(UILabel *label, CGFloat value))complete;

@end
