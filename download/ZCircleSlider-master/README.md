# ZCircleSlider

## 一、圆环型滑块的设计
* 最近设计师设计了一个圆环型滑块，其作用和UISlider差不多，用于拖动改变播放音频的进度和指示音频的播放进度。
* 大概的样子如下图：
![图一 设计图](http://upload-images.jianshu.io/upload_images/2409226-4a19ac0071c373bc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
* 有如下的特点：
    * 滑动的响应区域为圆环上，并且靠近滑块；
    * 点击滑块时，滑块有一个放大的动画，手指离开屏幕时滑块恢复原来大小；
    * 当value=0%时，滑块不可以再逆时针滑动，当value=100%时，滑块不可以再顺时针滑动。
    * 最后我自己再加了一个设计，指示音频loading的进度(这样以来圆环就有了三层)。


## 二、成果展示Demo
* 重复拖动

	![1.重复拖动](https://github.com/JixinZhang/ZCircleSlider/blob/master/CircleSlider1.gif)

* 限定360度

	![2.限定360度](https://github.com/JixinZhang/ZCircleSlider/blob/master/CircleSlider2.gif)

## 三、接入使用
###1. 接入
直接将[我的项目中](https://github.com/JixinZhang/ZCircleSlider)ZCircleSlider文件夹中的`ZCircleSlider.h 和 ZCircleSlider.m`拖到项目中即可

### 2.使用

```
//ZCircleSlider的背景色是透明的，不会挡住下面View
- (ZCircleSlider *)circleSlider {
    if (!_circleSlider) {
        _circleSlider = [[ZCircleSlider alloc] initWithFrame:CGRectMake((kScreenWidth - 300) / 2.0, (kScreenHeight - 300) / 2.0, 300, 300)];
        //走过的进度的颜色
        _circleSlider.minimumTrackTintColor = kUIColorFromRGB(0x1482f0);
        //loading进度的颜色。如果loading = 1，即loading完成，那么也是圆环的颜色，同于backgroundTintColor
        _circleSlider.maximumTrackTintColor = kUIColorFromRGB(0xE62E2E);
        //圆环的颜色
        _circleSlider.backgroundTintColor = [UIColor colorWithWhite:0 alpha:0.2];
        //圆环的宽
        _circleSlider.circleBorderWidth = 5.0f;
        //圆形滑块的半径
        _circleSlider.thumbRadius = 8;
        //圆形滑块放大效果的半径
        _circleSlider.thumbExpandRadius = 12.5;
        //圆形滑块的颜色
        _circleSlider.thumbTintColor = [UIColor redColor];
        //圆环的半径
        _circleSlider.circleRadius = 260 / 2.0 + 2;
        //设定初始值value = 0
        _circleSlider.value = 0;
        //设定loadingProgress的初始值 = 0
        _circleSlider.loadProgress = 0;
        //开始点击，响应事件
        [_circleSlider addTarget:self
                          action:@selector(circleSliderTouchDown:)
                forControlEvents:UIControlEventTouchDown];
        //拖动过程中，响应事件
        [_circleSlider addTarget:self
                          action:@selector(circleSliderValueChanging:)
                forControlEvents:UIControlEventValueChanged];
        //拖动结束，响应事件
        [_circleSlider addTarget:self
                          action:@selector(circleSliderValueDidChanged:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _circleSlider;
}

#pragma mark - action

/*以下三个方法，都要添加对slider.interaction的判断。
 *因为虽然看起来是个圆环，但是响应手势的区域确实整个矩形的View
 *在内部添加了interaction这个属性用于限定响应区域
 */
- (IBAction)circleSliderTouchDown:(ZCircleSlider *)slider {
    if (!slider.interaction) {
        return;
    }
    
}

- (IBAction)circleSliderValueChanging:(ZCircleSlider *)slider {
    if (!slider.interaction) {
        return;
    }
    self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f",slider.value * 100];
    self.progressSlider.value = slider.value;
}

- (IBAction)circleSliderValueDidChanged:(ZCircleSlider *)slider {
    if (!slider.interaction) {
        return;
    }
    self.finalValueLabel.text = [NSString stringWithFormat:@"最终值：%.0f",slider.value * 100];
}

```

## 四、实现原理
简单来说就是，整个控件继承与UIControl，根据value，loadProgress的值改变重新绘制layer和改变thumb的位置；根据手势所在的位置，重新绘制layer和改变thumb的位置，并改变value。
### 1. 根据所给value绘制圆弧
circleSlider.value和circleSlider.loadProgress，都是绘制圆弧。

####1）在`- (void)drawRect:(CGRect)rect;`方法中绘制圆弧
在iOS中，圆的0弧度的位置是圆心(x,y)的正右侧(x+r,y)
这里我选择起始位置为-M_PI_2弧度，即圆心的正上方(x,y-r);
弧长对应的变量就是运动的点相对于起点旋转过的角度，而这个角度就等于`value／1.0 * 360`
下面给出了加载进度圆弧的绘制方法，value的圆弧绘制方法同理
```
- (void)drawRect:(CGRect)rect {
    //加载的进度
    UIBezierPath *loadPath = [UIBezierPath bezierPath];
    CGFloat loadStart = -M_PI_2;
    CGFloat loadCurre = loadStart + 2 * M_PI * self.loadProgress;
    
    [loadPath addArcWithCenter:self.drawCenter
                        radius:self.radius
                    startAngle:loadStart
                      endAngle:loadCurre
                     clockwise:YES];
    CGContextSaveGState(ctx);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetLineWidth(ctx, self.circleBorderWidth);
    CGContextSetStrokeColorWithColor(ctx, self.maximumTrackTintColor.CGColor);
    CGContextAddPath(ctx, loadPath.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
}
```
#### 2) 在值改变的时候重新绘制layer
在值改变的时候调用`setNeedsDisplay`方法重新绘制layer

```
- (void)setLoadProgress:(float)loadProgress {
    _loadProgress = loadProgress;
    [self setNeedsDisplay];
}

```

### 2.拖动控制，以及保证thumb(滑块的那个圆点)在圆弧上运动
**这里主要给出了解决的思路方法，具体的实现可到[Github](https://github.com/JixinZhang/ZCircleSlider/)中查看**

主要是在UIControl的以下三个方法上做文章：

```
//点击开始
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;

//拖动过程中
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;

//拖动结束
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
```

#### 1) 对于拖动控制，以及保证thumb在圆弧上运动可以通过以下这道数学题做抽象
```
1.设定平面直角坐标系原点为O(0,0)，向右为x轴的正方向，向下为y轴的正方向；--------(iOS的屏幕坐标系)
2.在坐标系中有一个已知的圆C(a,b)，半径为r；--------(圆环型Slider)
3.平面内任意一点S(m,n)；--------(点击的位置)
求：
	1）点S到圆C的最短距离是否小于44；（限定点击响应的区域为圆弧内外44个点的区域）
	2）线段SC与圆的交点T(xT,yT)；(thumb的位置，肯定在圆弧上)
	3）线段ST的距离是否小于44；（限定点击开始时的响应区域为以thumb圆心，半径为44的圆以内）

```

#### 2) 对于当value=0%时，滑块不可以再逆时针滑动，当value=100%时，滑块不可以再顺时针滑动。

```
1. 平面内一个圆C半径为r，其圆心位于坐标系原点，即C(0,0)，圆弧上有一点T(x,y);
2. 坐标系可分为第一、二、三和四象限。
	1）那么当点T相对于起始点(0,-r)，顺时针转过的角度<60度时，禁止移动到第二，三，四象限；
	2）当点T相对于起始点(0,-r)，顺时针转过角度>300度时，禁止移动到第一，二，三象限；

```

### 如果觉得这个ZCircleSlider还不错请随手给个Star吧
