//
//  CBAlbumFrame.h
//  mustard
//
//  Created by chinabyte on 2017/8/18.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPictureModel;

@interface CBAlbumFrame : NSObject

@property (nonatomic , strong) CBPictureModel * pictureModel;
//题目
@property (nonatomic , assign) CGRect titleF;
//图片
@property (nonatomic , assign) CGRect coverF;
//cell的高度
@property (nonatomic , assign) CGFloat cellH;
@end
