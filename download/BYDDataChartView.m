//
//  BYDDataChartView.m
//  BYDi
//
//  Created by XM on 2018/4/2

#import "BYDDataChartView.h"


#define btnW 8
#define BottowH 80

@interface BYDDataChartView ()<UIScrollViewDelegate>
{
    CGFloat _xMargin;//X轴方向的偏移
    CGFloat _yMargin;//Y轴方向的偏移
    CGPoint _lastPoint;//最后一个坐标点
    
    NSInteger _countY; //y轴增值个数
    CGFloat _leftTitleW;
    
    UIImage *_pointImage;
    UIImage *_selectedPointImage;
}

@property (nonatomic,strong)UIScrollView *chartScrollView;
@property (nonatomic,strong)UIView *lineView;//背景横线
@property (nonatomic,strong)UIView *curveView;//曲线
@property (nonatomic,strong)NSMutableArray <UIButton *>*points;//数据源btn
@property (nonatomic, strong)NSMutableArray *detailLabelArr;


@property (nonatomic, strong) UILabel *titleLForX;
@property (nonatomic, strong) UILabel *titleLForY;


@property (nonatomic,strong)CAShapeLayer *shapeLayer;
@property (nonatomic,strong)CALayer *baseLayer;

@property (nonatomic,copy)void(^block)(NSString *value, NSInteger index);

@property (nonatomic,assign)ChartViewFromStyle fromStyle;

@end

@implementation BYDDataChartView

- (instancetype)initWithFrame:(CGRect)frame chartViewFromStyle:(ChartViewFromStyle)fromStyle  dataSourceY:(NSArray<NSString *>*)dataSourceY{
    if (self = [super initWithFrame:frame]) {
        self.points = [NSMutableArray array];
        self.detailLabelArr = [NSMutableArray array];
        self.fromStyle = fromStyle;
        _lineColor = [UIColor colorWithRed:65/255.0 green:156/255.0 blue:187/255.0 alpha:1];
        
        _countY = MAX(dataSourceY.count, 2);
//        _dataSource = [NSMutableArray array];
//        _dataSource = [NSMutableArray arrayWithArray:dataSource];
        
        _dataArrOfY = dataSourceY;
        
//        [self resetLeftDataSource];
        
        CGFloat marginWidth = (frame.size.width-_leftTitleW - 60)/6;
        _xMargin = marginWidth;
        
        [self addDetailViews];
        
        if (_dataSource != nil) {
            [self resetUIAndData];
        }
        
        
        if (dataSourceY.count > 0) {
            _leftTitleW = [dataSourceY.firstObject boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kFont(kFontName_PF_Re, 14)} context:nil].size.width + 2;
        }
        
        if (_leftTitleW < 30) {
            _leftTitleW = 30;
        }

        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame countFoyY:(NSInteger)countY {
    
    return [self initWithFrame:frame chartViewFromStyle:ChartViewFromStyleNone dataSourceY:@[@"100",@"80",@"60",@"40",@"20",@"0"]];
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    return [self initWithFrame:frame countFoyY:7];
}

-(void)addDetailViews{
    
    self.chartScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(_leftTitleW + 5, 0, self.bounds.size.width-_leftTitleW, self.bounds.size.height)];
    self.chartScrollView.contentOffset = CGPointMake(0, 0);
    self.chartScrollView.backgroundColor = [UIColor clearColor];
    self.chartScrollView.delegate = self;
    self.chartScrollView.showsHorizontalScrollIndicator = NO;
    self.chartScrollView.pagingEnabled = YES;
    self.chartScrollView.contentSize = CGSizeMake(self.bounds.size.width*2, 0);
    
    [self addSubview:self.lineView];
    [self addSubview:self.chartScrollView];
    
    [self.chartScrollView addSubview:self.curveView];
    [self addBackGroundLines];
    
    [self.lineView addSubview:self.titleLForX];
    [self.lineView addSubview:self.titleLForY];
    
    self.backgroundColor = [UIColor whiteColor];
}

//重置数据源
- (void)resetLeftDataSource {
    
//    __block CGFloat max = [_dataSource.firstObject floatValue];
//    __block CGFloat min = [_dataSource.firstObject floatValue];
//
//    [_dataSource enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.doubleValue > max) {
//            max = obj.doubleValue;
//        }
//        if (obj.doubleValue < min) {
//            min = obj.floatValue;
//        }
//    }];
//    //
//    min = 0;
//    CGFloat average = (max - min) / (_countY - 1.0);
//
//    if (average - (int)average > 0.5) {
//        average += 1;
//    }
//
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i < _countY; i ++) {
//        NSString *str = [NSString stringWithFormat:@"%.0lf", min + i * (int)average];
//        [array insertObject:str atIndex:0];
//
//
//    }
//
//    if (array.count > 0) {
//        _leftTitleW = [array.firstObject boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kFont(kFontName_PF_Re, 14)} context:nil].size.width + 2;
//    }
//
//    if (_leftTitleW < 30) {
//        _leftTitleW = 30;
//    }

//    _dataArrOfY = [array copy];
    

}

//重置UI
- (void)resetUIAndData {
    
    NSInteger page = _dataSource.count / 7 + 1;
    
    if (_dataSource.count > 7) {
        self.chartScrollView.scrollEnabled = YES;
        CGRect frame = _curveView.frame;
        frame.size.width *= page;
        _chartScrollView.contentSize = CGSizeMake(self.bounds.size.width * page, 0);
        _curveView.frame = frame;
    }else {
        self.chartScrollView.scrollEnabled = NO;
    }
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    [_baseLayer removeFromSuperlayer];
    [_shapeLayer removeFromSuperlayer];
    _shapeLayer = nil;
    [_curveView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
    }];
    
    [self addDataPoints];//添加点
    [self addLeftBezierPoint];//添加连线
    [self addLeftViews];
    [self addBottomViews];
}

//添加曲线动画
-(void)addLeftBezierPoint{
    
    if (_dataSource.count == 0) {
        return;
    }
    
    CGPoint p1 = self.points.firstObject.center;
    
    //曲线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    //遮罩层
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    
    for (int i = 0;i<self.points.count;i++ ) {
        if (i != 0) {
            
//            CGPoint prePoint  = CGPointMake(self.points[i-1].left, self.points[i].center.y);
//            CGPoint nowPoint =  CGPointMake(self.points[i].left, self.points[i].center.y);
//
            CGPoint prePoint = [[self.points objectAtIndex:i-1] center];
            CGPoint nowPoint = [[self.points objectAtIndex:i] center];
//
            if (i == self.points.count-1) {
                nowPoint = CGPointMake(self.points[i].right, self.points[i].center.y);
            }
            
            
            
            if (_style == ChatViewStyleSingleCurve || _style == ChatViewStyleMatrixCurve) {
                [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
                
                [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            }else {
                [beizer addLineToPoint:nowPoint];
                [bezier1 addLineToPoint:nowPoint];
            }
            
            if (i == self.points.count-1) {
                [beizer moveToPoint:nowPoint];//添加连线
                _lastPoint = nowPoint;
            }
        }
    }
    
    CGFloat bgViewHeight = self.lineView.bounds.size.height;
    
    //获取最后一个点的X值
    CGFloat _lastPointX = _lastPoint.x;
    
    //最后一个点对应的X轴的值
    CGPoint _lastPointX1 = CGPointMake(_lastPointX, bgViewHeight);
    
    [bezier1 addLineToPoint:_lastPointX1];
    
    //回到原点
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    
    [bezier1 addLineToPoint:p1];
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, self.curveView.bounds.size.height-30);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = [self getMaskColors];
    gradientLayer.locations = @[@(0.5f)];
    
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    _baseLayer = baseLayer;
    [self.curveView.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 2.0f;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(5, 0, 2*_lastPoint.x, self.curveView.bounds.size.height-0)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
    //*****************添加动画连线******************//
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = self.lineColor.CGColor;
    shapeLayer.lineWidth = 2;
    [self.curveView.layer addSublayer:shapeLayer];
    
    _shapeLayer = shapeLayer;
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration =2.0f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    for (UIButton *btn in self.points) {
        [self.curveView addSubview:btn];
    }
    
}

//创建点
-(void)addDataPoints {
    
    self.points = [NSMutableArray array];
    self.detailLabelArr = [NSMutableArray array];
    
    CGFloat height = self.lineView.bounds.size.height;
    
    if (_dataSource.count == 0) {
        return;
    }
    
    //初始点
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_dataSource];
    [arr insertObject:arr[0] atIndex:0];
    
    
    float tempMin = [arr[0] floatValue];
    
    tempMin = 0;
    
    //差值
    CGFloat dfValue = fabsf([self.dataArrOfY.firstObject floatValue] - [self.dataArrOfY.lastObject floatValue]);

    for (int i = 1; i<arr.count; i++) {

        if (dfValue == 0) {
            dfValue = 1;
        }
        
        CGFloat percent = ([arr[i] floatValue] - tempMin) * 1 / dfValue ;

        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((_xMargin)*i-_xMargin*0.7, height *(1 - percent) - btnW/2 , btnW, btnW)];
        
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = btnW/2;
        btn.layer.masksToBounds = YES;
        btn.userInteractionEnabled = NO;
        btn.tag = i;
        if (i == 0) {
            btn.hidden = YES;
        }else if ( i == arr.count - 1){
            
            btn.selected = YES;
        }
        
//        if (_pointImage == nil) {
//            _pointImage = [UIImage imageNamed:@"circle"];
//        }
//
//        if (_selectedPointImage == nil) {
//            _selectedPointImage = [UIImage imageNamed:@"point"];
//        }
//
        [btn setBackgroundImage:_pointImage forState:UIControlStateNormal];
        [btn setBackgroundImage:_selectedPointImage forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(pointBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        
        [self.points addObject:btn];
        
        /** 创建Label */
        UILabel * detailLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.curveView addSubview: detailLabel];
        detailLabel.tag = 200 + i;
        detailLabel.numberOfLines = 0;
        detailLabel.font = kFont(kFontName_PF_Re, 14);
        NSString *str = arr[i];
        CGSize textSize = [str boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil].size;;
        [detailLabel setFrame:CGRectMake((_xMargin)*i-_xMargin*0.7-textSize.width/2+btnW/2, height *(1 - percent)-30 , textSize.width, textSize.height)];
        detailLabel.text = str;
        detailLabel.backgroundColor = [UIColor colorWithRed:0.94f green:0.64f blue:0.27f alpha:1.00f];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.layer.cornerRadius =5;
        detailLabel.layer.masksToBounds = YES;
        detailLabel.textColor = [UIColor whiteColor];
        if (i == arr.count - 1) {
            detailLabel.hidden = YES;
//            detailLabel.hidden = NO;
        }else{
            detailLabel.hidden = YES;
        }
        [self.detailLabelArr addObject:detailLabel];
    }
    
    NSLog(@"a");
    
}

//y轴数据
-(void)addLeftViews{
    
    NSArray *leftArr = _dataArrOfY;
    
    for (int i = 0;i< _dataArrOfY.count ;i++ ) {
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, i*(_yMargin)+40-_yMargin/2, _leftTitleW, _yMargin)];
        leftLabel.font = kFont(kFontName_PF_Re, 14);
        leftLabel.textColor =[UIColor colorWithRed:0.61f green:0.61f blue:0.61f alpha:1.00f];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        
        CGFloat w = _leftTitleW;
        
        if (self.fromStyle == ChartViewFromStyleBehavior) {
            
            leftLabel.textColor = RGBCOLOR2B5FD5;
            
            if (i == 0) {
                NSString *str = [NSString stringWithFormat:@"%@(分)",_dataArrOfY[i]];
                NSAttributedString *atStr = [[NSAttributedString alloc] initWithString:str];
                
                leftLabel.attributedText =[atStr attributedText:@"(分)" font:kFont(kFontName_PF_Re, 12) color:UIColorHex(#868686)];
                w = w + 8*kScale;
            }else
            {
                
               leftLabel.text = leftArr[i];
               
            }
        }else
        {
            leftLabel.text = leftArr[i];
        }
        [leftLabel setVWidth:w];

        [self addSubview:leftLabel];
        
    }
}

//x轴数据
-(void)addBottomViews {
    
    if (_dataArrOfX.count == 0 || _dataArrOfX.count < _dataSource.count) {
        _dataArrOfX = [self datesForFirstFewDaysWithFormat:@"MM-dd"];
    }
    
    for (int i = 0;i< _dataArrOfX.count ;i++ ) {
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(5+_xMargin/2+i*_xMargin-_xMargin*0.7, (_countY - 1)*_yMargin + 3, _xMargin, 20)];
        leftLabel.font = kFont(kFontName_PF_Re, 14);
        leftLabel.tag = 1000+i;
        leftLabel.textColor = [UIColor colorWithRed:0.29f green:0.29f blue:0.29f alpha:1.00f];
        
        NSString *datStr =  _dataArrOfX[i];
        
        if (self.fromStyle == ChartViewFromStyleBehavior) {
            
            if ([datStr rangeOfString:@"\n"].location !=NSNotFound) {
                [leftLabel setHeight:40*kScale];
                leftLabel.numberOfLines = 2;
                NSAttributedString *atStr = [[NSAttributedString alloc] initWithString:datStr];
                
                NSString *lastLineStr = [datStr componentsSeparatedByString:@"\n"].lastObject;
               
                atStr = [atStr attributedText:lastLineStr font:kFont(kFontName_PF_Re, 12) color:[UIColor lightGrayColor]];

               leftLabel.attributedText =  [atStr attributedText:atStr.string color:nil font:nil space:0.0 rowSpace:-3*kScale bgColor:nil];
                //            leftLabel.attributedText = [datStr attri
            }
        }else
        {
            leftLabel.text = datStr;
        }

        
        
        leftLabel.textAlignment = NSTextAlignmentCenter;
//        if (i == _dataArrOfX.count-1) {
//            leftLabel.textColor = [UIColor colorWithRed:0.98f green:0.31f blue:0.29f alpha:1.00f];
//        }
        [_curveView addSubview:leftLabel];
        
        if (_style == ChatViewStyleMatrixCurve || _style == ChatViewStyleMatrixBroken) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(leftLabel.center.x - 0.5, 0, 1, _lineView.bounds.size.height)];
            label.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
            [_curveView addSubview:label];
            [_curveView sendSubviewToBack:label];
        }
    }
}

-(void)pointBtnAction:(UIButton *)sender{
    
    for (UIButton*btn in _points) {
        if (sender.tag == btn.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    
    for (int i = 0; i<self.dataArrOfX.count; i++) {
        UILabel *label = [self viewWithTag:1000+i];
        label.textColor = [UIColor colorWithRed:0.29f green:0.29f blue:0.29f alpha:1.00f];
    }
    UILabel *label = [self viewWithTag:1000+sender.tag-1];
    label.textColor = [UIColor colorWithRed:0.98f green:0.31f blue:0.29f alpha:1.00f];
    [self showDetailLabel:sender];
    
    if (_block) {
        _block(_dataSource[label.tag - 1000], label.tag - 1000);
    }
    
}

-(void)showDetailLabel:(UIButton *)sender{
    
    for (UILabel * label in _detailLabelArr) {
        if (sender.tag+200 == label.tag) {
            label.hidden = NO;
        }else{
            label.hidden = YES;
        }
    }
}

//背景线
-(void)addBackGroundLines {
    
    CGFloat magrginHeight = (_lineView.bounds.size.height)/ (_countY - 1);
    CGFloat labelWith = _lineView.bounds.size.width;
    _yMargin = magrginHeight;
    
    for (int i = 0;i< _countY ;i++ ) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, magrginHeight *i, labelWith, 1)];
        label.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        [_lineView addSubview:label];
    }
}

//日期
- (NSArray *)datesForFirstFewDaysWithFormat:(NSString *)format {
    NSMutableArray *aMArray = [NSMutableArray array];
    for (NSInteger i = _dataSource.count; i > 0; i --) {
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:-i * 24 * 3600];
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = format;
        [aMArray addObject:[formatter stringFromDate:date]];
    }
    return aMArray;
}

//获取遮罩颜色
- (NSArray *)getMaskColors {
    
    if (_maskColors.count <= 0) {
        _maskColors = @[self.lineColor];
    }
    
    NSArray *colors = @[[self getCGColorWithColor:_maskColors.firstObject alpha:0.7], [self getCGColorWithColor:_maskColors.lastObject alpha:0.0]];
    return colors;
}

- (id)getCGColorWithColor:(UIColor *)color alpha:(CGFloat)alpha {
    
    CGFloat red = 0.0, green = 0.0, blue = 0, al = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&al];
    return  (__bridge id)[UIColor colorWithRed:red green:green blue:blue alpha:alpha].CGColor;
}

- (void)pointDidTapedCompletion:(void (^)(NSString *, NSInteger))block {
    _block = block;
}

#pragma mark -- getter

-(UIView *)curveView{
    if (!_curveView) {
        _curveView = [[UIView alloc]initWithFrame:CGRectMake(5, 40, self.chartScrollView.bounds.size.width-5, self.chartScrollView.bounds.size.height)];
    }
    return _curveView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_chartScrollView.frame) , 0 + 40, self.chartScrollView.bounds.size.width - 5, self.chartScrollView.bounds.size.height-80)];
    }
    return _lineView;
}

- (UILabel *)titleLForY {
    if (!_titleLForY) {
        _titleLForY = [[UILabel alloc] initWithFrame:CGRectMake(-30, -30, 60, 20)];
        _titleLForY.font = [UIFont systemFontOfSize:10.0f];
        _titleLForY.textAlignment = kCTTextAlignmentCenter;
        _titleLForY.textColor = [UIColor lightGrayColor];
    }
    return _titleLForY;
}

- (UILabel *)titleLForX {
    if (!_titleLForX) {
        _titleLForX = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lineView.frame) - 90, CGRectGetMaxY(self.chartScrollView.frame) - _yMargin * 2 - 25, 60, 20)];
        _titleLForX.font = [UIFont systemFontOfSize:10.0f];
        _titleLForX.textAlignment = kCTTextAlignmentRight;
        _titleLForX.textColor = [UIColor lightGrayColor];
    }
    return _titleLForX;
}

- (void)setPointImage:(UIImage *)image pointselectedImage:(UIImage *)selectedImg {
    
    if ((image == _pointImage) && (selectedImg == _selectedPointImage)) {
        return;
    }
    _pointImage = image;
    _selectedPointImage = image;
    [self resetUIAndData];
}

- (void)setTitleForY:(NSString *)titleForY {
    _titleLForY.text = titleForY;
}

- (void)setTitleForX:(NSString *)titleForX {
    _titleLForX.text = titleForX;
}


-(void)setDataArrOfX:(NSArray *)dataArrOfX
{
    if (_dataArrOfX !=dataArrOfX) {
        
        _dataArrOfX = dataArrOfX;

    }
}

-(void)setDataSource:(NSMutableArray *)dataSource{
    
    if ([dataSource isEqualToArray:_dataSource] && !_reSetUIWhenSameData) {
        return;
    }
    
    _dataSource = dataSource;
    [self.chartScrollView setContentOffset:CGPointZero animated:NO];
//    [self resetLeftDataSource];
    [self resetUIAndData];
}

- (void)setStyle:(ChatViewStyle)style {
    if (style == _style) {
        return;
    }
    _style = style;
    [self resetUIAndData];

}

- (void)setLineColor:(UIColor *)lineColor {
    if (lineColor == _lineColor) {
        return;
    }
    
    if (_maskColors.count == 1 && _maskColors.firstObject == _lineColor) {
        _maskColors = nil;
    }
    
    _lineColor = lineColor;
    [self resetUIAndData];
}

- (void)setMaskColors:(NSArray<UIColor *> *)maskColors {
    
    if ([maskColors isEqual:_maskColors]) {
        return;
    }
    
    _maskColors = maskColors;
    [self resetUIAndData];
}


@end
