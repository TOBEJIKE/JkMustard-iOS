//
//  CBVideoCell.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBVideoCell.h"
#import "CBVideoModel.h"
#import "CBVideoModelFrame.h"

@interface CBVideoCell ()

@end

@implementation CBVideoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"videoCell";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CBVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CBVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //图片
        UIImageView *imageview = [[UIImageView alloc]init];
        [self.contentView addSubview:imageview];
        self.imageview = imageview;
        //题目背景
        UIImageView *imgBgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        imgBgTop.image = [UIImage imageNamed:@"video_top_shadow.png"];
        [self.contentView addSubview:imgBgTop];
        //题目
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = HEXColor(@"ffffff");
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        //播放按钮图片
        UIImageView *playcoverImage = [[UIImageView alloc]init];
        [self.contentView addSubview:playcoverImage];
        playcoverImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayView)];
        [playcoverImage addGestureRecognizer:tap];
        self.playcoverImage = playcoverImage;
        //时长
        UILabel *lengthLabel = [[UILabel alloc]init];
        lengthLabel.textColor = HEXColor(@"ffffff");
        lengthLabel.backgroundColor = RGBA(1, 1, 1,0.3);
        lengthLabel.textAlignment = NSTextAlignmentCenter;
        lengthLabel.layer.cornerRadius = 10;
        lengthLabel.layer.masksToBounds = YES;
        lengthLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:lengthLabel];
        self.lengthLabel = lengthLabel;
        //来源图标
        UIImageView *playImage = [[UIImageView alloc] init];
        playImage.layer.cornerRadius = 12;
        playImage.layer.masksToBounds = YES;
        [self.contentView addSubview:playImage];
        self.playImage = playImage;
        //来源文字
        UILabel *lbSource = [[UILabel alloc] init];
        lbSource.font = [UIFont systemFontOfSize:13];
        lbSource.textColor = HEXColor(@"333333");
        [self.contentView addSubview:lbSource];
        self.playcountLabel = lbSource;
        //时间
        UILabel *ptimeLabel = [[UILabel alloc]init];
        ptimeLabel.textColor = HEXColor(@"797979");
        ptimeLabel.font = [UIFont systemFontOfSize:13];
        ptimeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:ptimeLabel];
        self.ptimeLabel = ptimeLabel;
        //分割线
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = RGBA(239, 239, 244, 1);
        [self.contentView addSubview:lineV];
        self.lineV = lineV;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setVideodataframe:(CBVideoModelFrame *)videodataframe{
    _videodataframe = videodataframe;
    CBVideoModel * videodata = _videodataframe.videodata;
    //背景图片
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:videodata.video_img_url]];
    self.imageview.frame = _videodataframe.coverF;
    //题目
    NSString *str = [videodata.title stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    self.titleLabel.text = str;
    self.titleLabel.frame = _videodataframe.titleF;
    //播放按钮
    self.playcoverImage.image = [UIImage imageNamed:@"video_play_btn"];
    self.playcoverImage.frame = _videodataframe.playF;
    //时长
    self.lengthLabel.text = [self convertTime:1778];
    self.lengthLabel.frame = _videodataframe.lengthF;
    //来源图片
    [self.playImage sd_setImageWithURL:[NSURL URLWithString:@"http://vimg2.ws.126.net/image/snapshot/2015/11/V/A/VBGA5DAVA.jpg"]];
    self.playImage.frame = _videodataframe.playImageF;
    //来源
    self.playcountLabel.text = videodata.source;
    self.playcountLabel.frame = _videodataframe.playCountF;
    //时间
    self.ptimeLabel.text = @"2017";
    self.ptimeLabel.frame = _videodataframe.ptimeF;
    
    self.lineV.frame = _videodataframe.lineVF;
}
//时间转换
- (NSString *)convertTime:(CGFloat)second{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [fmt setDateFormat:@"HH:mm:ss"];
    } else {
        [fmt setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [fmt stringFromDate:d];
    return showtimeNew;
}
- (void)tapPlayView{
    self.playcoverImage.hidden = YES;
    if ([self.ttDelegate respondsToSelector:@selector(CBVideosCell:didClickPlayButton:)]) {
        [self.ttDelegate CBVideosCell:self didClickPlayButton:YES];
    }
}

@end
