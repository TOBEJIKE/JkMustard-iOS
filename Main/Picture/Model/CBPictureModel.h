//
//  CBPictureModel.h
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBPictureModel : NSObject
@property (nonatomic,copy)NSString * id;
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * source;
@property (nonatomic,copy)NSString * total_num;
@property (nonatomic,copy)NSString * origin_url;
@property (nonatomic,copy)NSString * publish_time;
@property (nonatomic,copy)NSString * create_time;
@property (nonatomic,copy)NSString * update_time;
@property (nonatomic,copy)NSString * read_total_num;
@property (nonatomic,copy)NSString * comment_total_num;
@property (nonatomic,copy)NSString * like_total_time;
@property (nonatomic,copy)NSString * comment;
@property (nonatomic,strong)NSArray * img_list;
@property (nonatomic,copy)NSString * thumbnail;
@end
