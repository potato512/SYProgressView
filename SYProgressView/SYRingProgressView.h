//
//  SYRingProgressView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/11/15.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//  https://github.com/potato512/SYProgressView

#import "SYProgressView.h"

@interface SYRingProgressView : SYProgressView

/// 减少的角度 直接传度数 如30
@property (nonatomic, assign) CGFloat reduceAngle;

/// 进度（值范围0.0~1.0，默认0.0）
@property (nonatomic, assign) CGFloat progress;

@end
