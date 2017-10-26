//
//  CBAlbumFrame.m
//  mustard
//
//  Created by chinabyte on 2017/8/18.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBAlbumFrame.h"
#define VideoPadding 10
@implementation CBAlbumFrame
- (void)setPictureModel:(CBPictureModel *)pictureModel{
    _pictureModel = pictureModel;
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
    //cell高度
     _cellH = CGRectGetMaxY(_coverF);
}
@end
