//
//  CBPictureCell.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBPictureCell.h"
#import "CBPictureModel.h"
#import "CBAlbumFrame.h"

@implementation CBPictureCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"albumCell";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CBPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CBPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        //图片
        UIImageView *imageview = [[UIImageView alloc]init];
        [self.contentView addSubview:imageview];
        self.imageview = imageview;
        //题目
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}
- (void)setAlbumFrame:(CBAlbumFrame *)albumFrame{
    _albumFrame = albumFrame;
    CBPictureModel * picturedata = _albumFrame.pictureModel;
    //背景图片
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:picturedata.thumbnail]];
    self.imageview.frame = _albumFrame.coverF;
    //题目
    NSString *str = [picturedata.name stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    self.titleLabel.text = str;
    self.titleLabel.frame = _albumFrame.titleF;
}
@end
