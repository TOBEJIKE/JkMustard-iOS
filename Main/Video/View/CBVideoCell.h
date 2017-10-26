//
//  CBVideoCell.h
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBVideoModelFrame,CBVideoCell;
@protocol CBVideoCellDelegate <NSObject>

- (void)CBVideosCell:(CBVideoCell *)cell didClickPlayButton:(BOOL)play; // 点击了播放按钮

@end

@interface CBVideoCell : UITableViewCell

@property (nonatomic,strong)CBVideoModelFrame * videodataframe;

@property (nonatomic , weak) UILabel *      titleLabel;
@property (nonatomic , weak) UIImageView *  imageview;
@property (nonatomic , weak) UIImageView *  playcoverImage;
@property (nonatomic , weak) UILabel *      lengthLabel;
@property (nonatomic , weak) UIImageView *  playImage;
@property (nonatomic , weak) UILabel *      playcountLabel;
@property (nonatomic , weak) UILabel *      ptimeLabel;
@property (nonatomic , weak) UIView *       lineV;
@property (nonatomic , weak) id<CBVideoCellDelegate> ttDelegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
