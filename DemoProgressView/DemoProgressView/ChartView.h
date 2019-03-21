//
//  ChartView.h
//  DemoProgressView
//
//  Created by zhangshaoyu on 2019/3/20.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChartView : UIView

@property (nonatomic, assign) CGFloat progress;

UIColor *UIColorWithHexadecimalString(NSString *color);

@end

NS_ASSUME_NONNULL_END
