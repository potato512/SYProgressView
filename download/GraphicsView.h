//
//  GraphicsView.h
//  Demo
//
//  Created by zhangshaoyu on 2018/12/4.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GraphicsView : UIView

@end

NS_ASSUME_NONNULL_END


/*
 iOS开发系列--打造自己的“美图秀秀”
 http://www.cnblogs.com/kenshincui/p/3959951.html#!comments
 
 
 
 在iOS中绘图一般分为以下几个步骤：
 
 1.获取绘图上下文
 2.创建并设置路径
 3.将路径添加到上下文
 4.设置上下文状态
 5.绘制路径
 6.释放路径
 图形上下文CGContextRef代表图形输出设备（也就是绘制的位置），包含了绘制图形的一些设备信息，Quartz 2D中的所有对象最终都必须绘制到图形上下文。这样一来，我们在绘制图形时就不必关心具体的设备信息，统一了代码编写方式（在Quartz 2D中的绘图上下文可以是位图Bitmap、PDF、窗口Window、层Layer、打印对对象Printer）。
 
 绘制我们需要的内容
 5.1 绘制路径
 
 首先需要我们画出路径 -> 指定起始点到另一个点, 然后两点之间可以使用直线或者曲线来连接, 就形成了一条路径, 例如使用下面的函数来实现
 
 ```
 
 CGContextMoveToPoint() -> 指定起始点或者移动到新的点
 CGContextAddLineToPoint() -> 从当前的点到指定的点之间画一条线
 CGContextAddArc() -> 圆弧
 CGContextAddArcToPoint() -> 会在当前点和指定点与坐标系平行的直线做切线画圆弧
 CGContextAddCurveToPoint() -> 画曲线(bezier)
 CGContextClosePath() -> 将起始点和结束点连接起来形成封闭的路径
 CGContextAddEllipseInRect() -> 椭圆
 ```
 
 然后设置需要绘制的路径的属性 -> 设置颜色,透明度,宽度, 绘制模式...例如使用如下的函数来实现
 
 ```
 
 
 
 CGContextSetLineWidth() -> 线宽度
 CGContextSetLineJoin() -> 线的连接点的样式
 CGContextSetLineCap() -> 端点的样式
 CGContextSetLineDash() -> 虚线
 CGContextSetStrokeColorWithColor() -> stroke模式时的颜色
 CGContextSetFillColorWithColor() -> fill模式时的颜色
 ```
 * 绘制内容, 注意会涉及到两种方式: fill 和 stroke, 这里解释一下两者的区别
 
 
 当使用stroke方式   -> "描边"即只绘制路径
 
 
 
 当使用fill方式"填充"即绘制路径包括的所有区域(所有路径都会被当作closePath处理)
 
 Filling有两种模式
 nonzero winding number(默认) -> 如果两个路径有重叠的时候, 绘制方向相同的话, 那么重叠部分的绘制可能不是我们希望的
 even-odd -> 不受绘制方向的影响
 CGContextEOFillPath
 CGContextFillPath
 CGContextFillRect
 CGContextFillRects
 CGContextFillEllipseInRect
 
 作者：ZeroJ
 链接：https://www.jianshu.com/p/bf7ebe563469
 來源：简书
 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
 
 */
