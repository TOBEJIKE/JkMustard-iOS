//
//  CBImagesCell.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBImagesCell.h"
#import "CBNewsModel.h"

@implementation CBImagesCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ImagesCell";
    CBImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (cell == nil) {
        cell = [[CBImagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //标题
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, ScreenWidth-16, 20)];
        if (ScreenWidth == 320) {
            titleL.font = [UIFont systemFontOfSize:15];
        }else{
            titleL.font = [UIFont systemFontOfSize:16];
        }
        [self addSubview:titleL];
        self.titleL = titleL;
        //标签
        UILabel * typeL = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleL.frame)+20, 30, 15)];
        typeL.layer.borderColor = MainThemeColor.CGColor;
        typeL.layer.masksToBounds = YES;
        typeL.layer.cornerRadius = 3;
        typeL.layer.borderWidth = 1;
        typeL.textAlignment = 1;
        typeL.text = @"原创";
        typeL.font = [UIFont systemFontOfSize:10];
        typeL.textColor = MainThemeColor;
        [self addSubview:typeL];
        //来源
        UILabel * sourceL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(typeL.frame)+20, CGRectGetMaxY(titleL.frame)+20, 50, 15)];
        typeL.textAlignment = 1;
        sourceL.text = @"人民日报";
        sourceL.font = [UIFont systemFontOfSize:10];
        sourceL.textColor = [UIColor darkGrayColor];
        [self addSubview:sourceL];
        //阅读数
        CGFloat x = CGRectGetMaxX(sourceL.frame)+10;
        CGFloat y = CGRectGetMaxY(titleL.frame)+20;
        CGFloat w = 100;
        CGFloat h = 15;
        UILabel *countL = [[UILabel alloc]init];
        countL.frame = CGRectMake(x, y, w, h);
        countL.textAlignment = NSTextAlignmentCenter;
        countL.font = [UIFont systemFontOfSize:10];
        countL.textColor = [UIColor darkGrayColor];
        [self addSubview:countL];
        self.countL = countL;
        //删除按钮
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-40, CGRectGetMaxY(titleL.frame)+20, 20, 20)];
        [button setImage:[UIImage imageNamed:@"cell_delete@3x"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.deleteB = button;
        //image1
        CGFloat imageY = CGRectGetMaxY(typeL.frame)+10;
        CGFloat imageW = (ScreenWidth-40)/3;
        CGFloat imageH = 0.7*imageW;
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, imageY, imageW, imageH)];
        imageview.backgroundColor = [UIColor grayColor];
        [self addSubview:imageview];
        self.Image1 = imageview;
        //image2
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+10, imageY, imageW, imageH)];
        image2.backgroundColor = [UIColor grayColor];
        [self addSubview:image2];
        self.Image2 = image2;
        //image3
        UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image2.frame)+10, imageY, imageW, imageH)];
        image3.backgroundColor = [UIColor grayColor];
        [self addSubview:image3];
        self.Image3 = image3;
        //分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(image2.frame) + 10, ScreenWidth, 4)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
    }
    return self;
}
- (void)setDataModel:(CBNewsModel *)dataModel{
    _dataModel = dataModel;
    self.titleL.text = self.dataModel.title;
    [self.Image1 sd_setImageWithURL:[NSURL URLWithString:self.dataModel.list_img1_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.Image2 sd_setImageWithURL:[NSURL URLWithString:self.dataModel.list_img2_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.Image3 sd_setImageWithURL:[NSURL URLWithString:self.dataModel.list_img3_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}
+ (NSString *)idForRow:(CBNewsModel *)NewsModel{
    return @"ImagesCell";
}
+ (CGFloat)heightForRow:(CBNewsModel *)NewsModel{
    return 90+(ScreenWidth-40)/3*0.7;
}
- (void)btnclick{
    NSLog(@"点击删除");
}
@end
