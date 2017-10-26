//
//  JKPhotoLoadingView.h
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKPhotoLoadingView : UIView
@property (nonatomic) float progress;
- (void)showLoading;
- (void)showFailure;
@end
