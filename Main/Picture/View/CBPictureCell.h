//
//  CBPictureCell.h
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBAlbumFrame;

@interface CBPictureCell : UITableViewCell

@property (nonatomic,strong) CBAlbumFrame * albumFrame;
@property (nonatomic , weak) UIImageView *  imageview;
@property (nonatomic , weak) UILabel *      titleLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
