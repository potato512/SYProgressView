//
//  ZCircleSlider.h
//  LoadingView
//
//  Created by ZhangBob on 24/05/2017.
//  Copyright © 2017 JixinZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 圆环形滑块，和UISlider类似，既可以显示进度又可以改变进度
 */
@interface ZCircleSlider : UIControl

@property (nullable, nonatomic, strong) UIColor *backgroundTintColor;   // 圆环的背景色（默认灰色）
@property (nullable, nonatomic, strong) UIColor *minimumTrackTintColor; // 圆环滑过的颜色（默认红色）
@property (nullable, nonatomic, strong) UIColor *maximumTrackTintColor; // 圆环加载进度的颜色，加载完成后就相当于圆环未滑过的颜色（默认黄色）

@property (nonatomic, assign) BOOL showGradient; // 进度颜色是否渐变（默认否）
@property (nonatomic, strong) NSArray <UIColor *> *colorsGradient; // 渐变颜色

@property (nonatomic, assign) CGFloat circleBorderWidth;    // 圆的宽度（默认5.0）
@property (nonatomic, assign) CGFloat circleRadius;     // 圆形进度条的半径（若未设置，则不会显示；默认减24，一般比view的宽高中最小者还要小24）

@property (nullable, nonatomic, strong) UIColor *thumbTintColor; // 滑块的颜色（默认黑色）
@property (nonatomic, assign) CGFloat thumbRadius;          //滑块正常的半径
@property (nonatomic, assign) CGFloat thumbExpandRadius;    //滑块放大的半径
@property (nonatomic, strong) UIImage *thumbImage; /// 滑块图标（默认无）
@property (nonatomic, assign) BOOL showThumb; // 是否显示滑块（默认显示）

@property (nonatomic, assign) BOOL showValue; // 是否显示进度（默认不显示）

@property (nonatomic, assign, readonly) BOOL interaction;   //点击在限定的区域为YES，否则为NO.
@property (nonatomic, assign) BOOL canRepeat;               //是否可以重复拖动。默认为NO，即只能转到360；否则任意角度。
@property (nonatomic, assign, getter=isCounterCloseWise) BOOL canCounterClockWise; /// 是否支持逆时针；默认不支持

@property (nonatomic, assign) float value;                  //slider当前的value
@property (nonatomic, assign) float loadProgress;           //slider加载的进度

@end
