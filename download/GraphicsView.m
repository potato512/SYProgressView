//
//  GraphicsView.m
//  Demo
//
//  Created by zhangshaoyu on 2018/12/4.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import "GraphicsView.h"

@implementation GraphicsView

- (void)drawRect:(CGRect)rect
{
//    [self drawLine:rect];
    
//    [self drawGraphics:rect];
    
//    [self drawCircle:rect];
    
//    [self drawImage:rect];
    
//    [self drawArc:rect];
    
    [self drawRing:rect];
}

// 画线
- (void)drawLine:(CGRect)rect
{
    // 方法1
    // 获取上下文画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置起点
    CGContextMoveToPoint(context, 0.0, 0.0);
    // 设置终点
    CGContextAddLineToPoint(context, rect.size.width - 20.0, rect.size.height - 20.0);
    // 线条颜色
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    // 线条宽度
    CGContextSetLineWidth(context, 5.0);
    // 连接点样式
    CGContextSetLineJoin(context, kCGLineJoinRound);
    // 端点样式
    CGContextSetLineCap(context, kCGLineCapRound);
    // 虚线
    /*
     context – 上下文
     phase - 表示在第一个虚线绘制的时候跳过多少个点
     lengths – 指明虚线是如何交替绘制，具体看例子
     count – lengths数组的长度
     */
    CGFloat lengths[] = {10, 5};
    CGContextSetLineDash(context, 0, lengths, 1);
    
    // 渲染（一定不能忘）
    CGContextStrokePath(context);
    
    
    // 方法2
//    // 1.创建一条可绘制路径
//    CGMutablePathRef path = CGPathCreateMutable();
//    // 2. 把绘图信息添加到路径中
//    CGPathMoveToPoint(path, NULL, 0.0, 0.0);
//    CGPathAddLineToPoint(path, NULL, 0.0, rect.size.height / 2);
//    CGPathAddLineToPoint(path, NULL, rect.size.width / 2, rect.size.height);
//    // 3.把路径添加到上下文画布中
//    // 获取上下文画布
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddPath(context, path);
//    // 渲染（一定不能忘）
//    CGContextStrokePath(context);
}

// 画图
- (void)drawGraphics:(CGRect)rect
{
    // 获取上下文画布
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // 添加绘图路径
//    CGContextMoveToPoint(context, 10.0, 10.0);
//    CGContextAddLineToPoint(context, rect.size.width - 10.0, 10.0);
//    CGContextAddLineToPoint(context, rect.size.width - 10.0, rect.size.height - 10.0);
//    CGContextAddLineToPoint(context, 10.0, rect.size.height - 10.0);
//    CGContextMoveToPoint(context, 10.0, 10.0);
//    // 3 设置描边颜色和填充颜色
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
//    // 4 绘图
//    CGContextDrawPath(context, kCGPathFillStroke);
//    // 渲染（一定不能忘）
//    CGContextStrokePath(context);
    
    
    // 获取上下文画布
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // 添加一个矩形
//    CGContextAddRect(context, rect);
//    // 填充色
//    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
//    // 4 绘图
//    CGContextDrawPath(context, kCGPathFillStroke);
//    // 渲染（一定不能忘）
//    CGContextStrokePath(context);
    
    
    
    
    
    // 获取上下文画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 添加一个椭圆
    CGContextAddEllipseInRect(context, CGRectMake(0.0, 0.0, rect.size.width, rect.size.height / 2));
    // 填充色
    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
    // 4 绘图 kCGPathFill 填充无边框；kCGPathEOFill 填充无边框；kCGPathStroke 无填充有边框；kCGPathFillStroke 有填充有边框；kCGPathEOFillStroke 有填充有边框
    CGContextDrawPath(context, kCGPathEOFillStroke);
    // 渲染（一定不能忘）
    CGContextStrokePath(context);
}

// 画图片
- (void)drawImage:(CGRect)rect
{
    // 获取上下文画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef image;
    UIImage *img = [UIImage imageNamed:@"001"];
    image = CGImageRetain(img.CGImage);
    //
    CGFloat origin = 20;
    CGRect imageRect = CGRectMake(origin, origin, rect.size.width - origin * 2, rect.size.height - origin * 2);
    
    CGContextDrawImage(context, imageRect, image);
    // 渲染（一定不能忘）
    CGContextStrokePath(context);
}

// 画圆
- (void)drawCircle:(CGRect)rect
{
    // 方法1
//    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:rect];
//    [[UIColor blueColor] setFill];
//    [circle fill];
    
    // 方法2
    CGContextRef circle = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(circle, rect);
    CGContextSetFillColorWithColor(circle, [UIColor blueColor].CGColor);
    CGContextFillPath(circle);
    
    // 方法3
//    // 获取上下文画布
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // 添加一个圆形，或椭圆
//    CGContextAddEllipseInRect(context, rect);
//    // 填充色
//    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
//    // 4 绘图
//    CGContextDrawPath(context, kCGPathFillStroke);
//    // 渲染（一定不能忘）
//    CGContextStrokePath(context);
}


// 画弧
- (void)drawArc:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*
     CGContextAddArc(CGContextRef cg_nullable c, CGFloat x, CGFloat y, CGFloat radius, CGFloat startAngle, CGFloat endAngle, int clockwise)
     添加弧形对象
     x:中心点x坐标
     y:中心点y坐标
     radius:半径
     startAngle:起始弧度
     endAngle:终止弧度
     closewise:是否逆时针绘制，0则顺时针绘制
     */
    CGContextAddArc(context, rect.size.width / 2, rect.size.height / 2, rect.size.width / 2, 0.0, M_PI, 1);
    
    // 填充色
    [[UIColor greenColor] set];
    // 填充色
//    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    
    // 4 绘图 kCGPathFill 填充无边框；kCGPathEOFill 填充无边框；kCGPathStroke 无填充有边框；kCGPathFillStroke 有填充有边框；kCGPathEOFillStroke 有填充有边框
    CGContextDrawPath(context, kCGPathEOFillStroke);
    // 渲染（一定不能忘）
    CGContextStrokePath(context);
}


#pragma mark - 环

// 画环
- (void)drawRing:(CGRect)rect
{
//    CGPoint drawCenter = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
//    CGFloat circleRadius = rect.size.width - 24;
//    CGFloat radius = circleRadius;
//    CGPoint circleStartPoint = CGPointMake(drawCenter.x, drawCenter.y - circleRadius);
//
//
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
//    CGContextSetLineWidth(ctx, 3);
//    CGContextAddArc(ctx, drawCenter.x, drawCenter.y, radius, 0, 2 * M_PI, 0);
//    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.lineWidth = 5;
    // 圆环的颜色
    layer.strokeColor = [UIColor redColor].CGColor;
    // 背景填充色
    layer.fillColor = [UIColor clearColor].CGColor;
    // 设置半径为10
    CGFloat radius = rect.size.width / 2;
    //按照顺时针方向
    BOOL clockWise = true;
    //初始化一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:radius startAngle:(1.25*M_PI) endAngle:1.75f*M_PI clockwise:clockWise];
    layer.path = [path CGPath];
    [self.layer addSublayer:layer];
    
    //
    // 设置渐变颜色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = rect;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor greenColor] CGColor],(id)[[UIColor blueColor] CGColor],(id)[[UIColor brownColor] CGColor], nil]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [self.layer addSublayer:gradientLayer];
    [gradientLayer setMask:layer];
    
    
}


//更新小点的位置
-(CGRect)getEndPointFrameWithProgress:(float)progress
{
    CGFloat angle = M_PI*2.0*progress;//将进度转换成弧度
    float radius = self.bounds.size.width / 2; //(_backView.bounds.size.width-_lineWidth)/2.0;//半径
    int index = (angle)/M_PI_2;//用户区分在第几象限内
    float needAngle = angle - index*M_PI_2;//用于计算正弦/余弦的角度
    float x = 0,y = 0;//用于保存_dotView的frame
    switch (index) {
        case 0:
            NSLog(@"第一象限");
            x = radius + sinf(needAngle)*radius;
            y = radius - cosf(needAngle)*radius;
            break;
        case 1:
            NSLog(@"第二象限");
            x = radius + cosf(needAngle)*radius;
            y = radius + sinf(needAngle)*radius;
            break;
        case 2:
            NSLog(@"第三象限");
            x = radius - sinf(needAngle)*radius;
            y = radius + cosf(needAngle)*radius;
            break;
        case 3:
            NSLog(@"第四象限");
            x = radius - cosf(needAngle)*radius;
            y = radius - sinf(needAngle)*radius;
            break;
            
        default:
            break;
    }
    //为了让圆圈的中心和圆环的中心重合
    x -= (_redDot.bounds.size.width/2.0f - _lineWidth/2.0f);
    y -= (_redDot.bounds.size.width/2.0f - _lineWidth/2.0f);
    //更新圆环的frame
    CGRect rect = _redDot.frame;
    rect.origin.x = x;
    rect.origin.y = y;
    return  rect;
}



@end
