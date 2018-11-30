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

/// 环形拐点样式（直角，或圆角；默认直角）
@property (nonatomic, assign) BOOL lineRound;

@end
