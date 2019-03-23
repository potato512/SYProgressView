//
//  SYProgressView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/11/15.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//  https://github.com/potato512/SYProgressView

#import <UIKit/UIKit.h>
#import "SYAnimationLabel.h"

@interface SYProgressView : UIView

/// 背景颜色（默认灰色）
@property (nonatomic, strong) UIColor *defaultColor;
/// 进度颜色（默认蓝色）
@property (nonatomic, strong) UIColor *progressColor;
/// 边框线条颜色（默认黑色）
@property (nonatomic, strong) UIColor *lineColor;
/// 边框线条大小（默认1.0）
@property (nonatomic, assign) CGFloat lineWidth;

/// 数值是否动画效果变化（默认无动画）
@property (nonatomic, assign) BOOL animationText;
/// 字体标签（默认字体黑色/居中显示/隐藏）
@property (nonatomic, strong) SYAnimationLabel *label;

/// 渐变颜色（默认：黄，红）
@property (nonatomic, strong) NSArray <UIColor *> *colorsGradient;
/// 是否渐变色样式（默认否）
@property (nonatomic, assign) BOOL showGradient;

/// 是否与边框有间距（默认无）
@property (nonatomic, assign) BOOL showSpace;
/// 间隔大小（默认0.0）
@property (nonatomic, assign) CGFloat spaceWidth;

/// 是否动效变换（默认否）
@property (nonatomic, assign) BOOL isAnimation;

/**
 初始化（设置属性后，最后必须调用一次）
 */
- (void)initializeProgress;

@end
