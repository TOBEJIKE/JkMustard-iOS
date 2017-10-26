//
//  JKPhotoView.h
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKPhoto,JKPhotoView;
@protocol JKPictureViewDelegate <NSObject>
- (void)pictureViewImageFinishLoad:(JKPhotoView *)pictureView;
- (void)pictureViewSingleTap:(JKPhotoView *)pictureView;
- (void)pictureViewLongPress:(JKPhotoView *)pictureView;
@end

@interface JKPhotoView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, strong) JKPhoto *photo;// 图片
@property (nonatomic, weak) id<JKPictureViewDelegate> jkDelegate;// 代理

@end
