//
//  CBNewsModel.h
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBNewsModel : NSObject
@property (nonatomic,strong)NSString * id;
@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSString * source;
@property (nonatomic,strong)NSString * publish_time;
@property (nonatomic,strong)NSString * create_time;
@property (nonatomic,strong)NSString * update_time;
@property (nonatomic,strong)NSString * list_img1_url;
@property (nonatomic,strong)NSString * list_img2_url;
@property (nonatomic,strong)NSString * list_img3_url;
@property (nonatomic,strong)NSString * read_total_num;
@property (nonatomic,strong)NSString * comment_total_num;
@property (nonatomic,strong)NSString * like_total_num;
@property (nonatomic,strong)NSString * keyword;
@property (nonatomic,strong)NSString * content;
@property (nonatomic,assign)int layout;
@end
