//
//  CBImagesCell.h
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBNewsModel,CBImagesCell;

@interface CBImagesCell : UITableViewCell
@property (nonatomic,strong)CBNewsModel * dataModel;
//标题
@property (nonatomic,weak) UILabel * titleL;
//标签
@property (nonatomic,weak) UILabel * tagL;
//来源
@property (nonatomic,weak) UILabel * resourceL;
//阅读数
@property (nonatomic,weak) UILabel * countL;
//x号
@property (nonatomic,strong)UIButton * deleteB;
//第一张图片
@property (nonatomic,weak) UIImageView * Image1;
//第二张图片
@property (nonatomic,weak) UIImageView * Image2;
//第三张图片
@property (nonatomic,weak) UIImageView * Image3;
//类方法返回可重用的id
+ (NSString *)idForRow:(CBNewsModel *)NewsModel;
// 类方法返回行高
+ (CGFloat)heightForRow:(CBNewsModel *)NewsModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
