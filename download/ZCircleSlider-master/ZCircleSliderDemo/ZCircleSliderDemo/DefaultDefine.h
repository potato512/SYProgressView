//
//  DefaultDefine.h
//  ZCircleSliderDemo
//
//  Created by ZhangBob on 01/06/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#ifndef DefaultDefine_h
#define DefaultDefine_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//十六进制色值
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* DefaultDefine_h */
