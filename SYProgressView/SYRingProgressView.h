//
//  SYRingProgressView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/11/15.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//  https://github.com/potato512/SYProgressView

#import "SYProgressView.h"

@interface SYRingProgressView : SYProgressView

/*
 1 defaultColor属性无效
 2 绝对值startAngle + 绝对值endAngle = 360时，满环
 3 绝对值startAngle + 绝对值endAngle < 360时，缺口环，根据需要设置
 */

/// 起始点（角度-360.0~360.0，默认-90.0）
@property (nonatomic, assign) CGFloat startAngle;
/// 结束点（角度-360.0~360.0，默认270.0）
@property (nonatomic, assign) CGFloat endAngle;
/// 是否顺时针（默认YES顺序针）
@property (nonatomic, assign) BOOL isClockwise;

/// 进度（值范围0.0~1.0，默认0.0）
@property (nonatomic, assign) CGFloat progress;

/// 环形拐点样式（直角，或圆角；默认直角）
@property (nonatomic, assign) BOOL lineRound;

@end
