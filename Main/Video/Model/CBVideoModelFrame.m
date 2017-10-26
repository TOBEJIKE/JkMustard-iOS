//
//  CBVideoModelFrame.m
//  mustard
//
//  Created by chinabyte on 2017/8/18.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBVideoModelFrame.h"
#define VideoPadding 10

@implementation CBVideoModelFrame
- (void)setVideodata:(CBVideoModel *)videodata{
    _videodata = videodata;
    //图片
    CGFloat coverX = 0;
    CGFloat coverY = 0;
    CGFloat coverW = ScreenWidth;
    CGFloat coverH = coverW * 0.56;
    _coverF = CGRectMake(coverX, coverY, coverW, coverH);
    //题目
    CGFloat titleX = VideoPadding;
    CGFloat titleY = VideoPadding;
    CGFloat titleW = ScreenWidth - 2*VideoPadding;
    CGFloat titleH = 40;
    _titleF = CGRectMake(titleX, titleY, titleW, titleH);
    //播放暂停按钮
    CGFloat playW = 50;
    CGFloat playH = 50;
    CGFloat playX = coverW/2 - 25;
    CGFloat playY = coverH/2 - 25;
    _playF = CGRectMake(playX, playY, playW, playH);
    //时长
    CGFloat lengthW = 40;
    CGFloat lengthH = 20;
    CGFloat lengthX = ScreenWidth - lengthW - 5;
    CGFloat lengthY = CGRectGetMaxY(_coverF) - lengthH - 5;
    _lengthF = CGRectMake(lengthX, lengthY, lengthW, lengthH);
    //播放来源图片
    CGFloat playImageX = VideoPadding;
    CGFloat playImageY = CGRectGetMaxY(_coverF) + 8;
    CGFloat playImageW = 24;
    CGFloat playImageH = 24;
    _playImageF = CGRectMake(playImageX, playImageY, playImageW, playImageH);
    //播放来源文字
    CGFloat playcountX = CGRectGetMaxX(_playImageF) + 5;
    CGFloat playcountY = CGRectGetMaxY(_coverF);
    CGFloat playcountW = 100;
    CGFloat playcountH = 40;
    _playCountF = CGRectMake(playcountX, playcountY, playcountW, playcountH);
    //时间
    CGFloat ptimeW = 45;
    CGFloat ptimeH = 40;
    CGFloat ptimeX = ScreenWidth - ptimeW - 5;
    CGFloat ptimeY = CGRectGetMaxY(_coverF);
    _ptimeF = CGRectMake(ptimeX, ptimeY, ptimeW, ptimeH);
    //灰块
    CGFloat lineW = ScreenWidth;
    CGFloat lineH = 5;
    CGFloat lineX = 0;
    CGFloat lineY = CGRectGetMaxY(_ptimeF);
    _lineVF = CGRectMake(lineX, lineY, lineW, lineH);
    
    _cellH = CGRectGetMaxY(_lineVF);
}

@end
