//
//  SYRingProgressView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/11/15.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//  https://github.com/potato512/SYProgressView

#import "SYProgressView.h"

@interface SYRingProgressView : SYProgressView

/// 减少的角度（暂无效果；直接传度数 如30）
@property (nonatomic, assign) CGFloat reduceAngle;

/// 进度（值范围0.0~1.0，默认0.0）
@property (nonatomic, assign) CGFloat progress;

/// 滑块的颜色（默认黑色）
@property (nullable, nonatomic, strong) UIColor *thumbTintColor;
/// 滑块正常的半径
@property (nonatomic, assign) CGFloat thumbRadius;
/// 滑块放大的半径
@property (nonatomic, assign) CGFloat thumbExpandRadius;
/// 滑块图标（默认无）
@property (nonatomic, strong) UIImage *thumbImage;
/// 是否显示滑块（默认隐藏）
@property (nonatomic, assign) BOOL showThumb;
/// 是否可以重复拖动。默认为NO，即只能转到360；否则任意角度。
@property (nonatomic, assign) BOOL canRepeat;
/// 是否支持逆时针；默认不支持
@property (nonatomic, assign, getter=isCounterCloseWise) BOOL canCounterClockWise;

@end
