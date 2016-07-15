

#ifndef Method_h
#define Method_h

#define FHRGBcolor (r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:0.2];

#endif /* Method_h */

#ifdef DEBUG // 处于开发阶段
#define HWLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define HWLog(...)
#endif

// RGB颜色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define HWRandomColor HWColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"
#import "UIWindow+Extension.h"