//
//  NSString+JKExtension.h
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JKExtension)
// 计算字符串size
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;

- (NSAttributedString *)attributedStringWithFont:(UIFont *)font color:(UIColor *)color;

+ (NSString *)videosListTimeStringWithLength:(CGFloat)length;
+ (instancetype)playerTimeStringWithProgress:(double)progress;

// 计算文件大小
- (unsigned long long)fileSize;

// 将十六进制的编码转为emoji字符
+ (NSString *)emojiWithIntCode:(int)intCode;

// 将十六进制的编码转为emoji字符
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;
- (NSString *)emoji;

// 是否为emoji字符
- (BOOL)isEmoji;



// 内存计算
- (NSString *)stringWithCacheSize:(NSUInteger)size;


//判断中英混合的的字符串长度
+ (int)convertToInt:(NSString*)strtemp;

// 字符串是否是中文
- (BOOL)isChinese;

@end
