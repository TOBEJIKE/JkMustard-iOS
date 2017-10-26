//
//  Header.h
//  mustard
//
//  Created by chinabyte on 2017/8/15.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#ifndef Header_h
#define Header_h


#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

/** 颜色 **/
#define MainThemeColor [UIColor colorWithRed:0 green:217/255.0 blue:202/255.0 alpha:1.0]
#define TabColor [UIColor colorWithRed:(93)/255.0 green:(93)/255.0 blue:(93)/255.0 alpha:1.0]
#define GrayColor [UIColor colorWithRed:(174)/255.0 green:(175)/255.0 blue:(175)/255.0 alpha:1.0]
#define HEXColor(colorString) [UIColor colorWithHexString:colorString]
#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//读取本地图片
#define SETPNGImage(file) [UIImage imageNamed:file]
#define SETImage(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

/** 按钮 **/
#define SETImageForImageView(imageView,file) [imageView setImage:SETPNGImage(file)]
#define AddBtnEvent(btn,target,selector)   [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside]
#define SETBtnImageNormal(btn,file)  [btn setImage:SETPNGImage(file) forState:UIControlStateNormal]
#define SETBtnImageHighlight(btn,file)  [btn setImage:SETPNGImage(file) forState:UIControlStateHighlighted]
#define SetImageForBtn(btn,imageStr) ([btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal])

/** 字体 **/
#define SystemFont(f) [UIFont systemFontOfSize:f]

/** 打印 **/
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


#endif /* Header_h */
