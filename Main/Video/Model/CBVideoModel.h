//
//  CBVideoModel.h
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBVideoModel : NSObject
@property (nonatomic,copy)NSString * id;//视频
@property (nonatomic,copy)NSString * title;//标题
@property (nonatomic,copy)NSString * video_url;//视频文件
@property (nonatomic,copy)NSString * descriptionTitle;//描述
@property (nonatomic,copy)NSString * source;//来源
@property (nonatomic,copy)NSString * publish_time;//发布时间
@property (nonatomic,copy)NSString * create_time;//创建时间
@property (nonatomic,copy)NSString * update_time;//更新时间
@property (nonatomic,copy)NSString * read_total_num;//阅读数
@property (nonatomic,copy)NSString * comment_total_num;//评论数
@property (nonatomic,copy)NSString * like_total_num;//收藏数
@property (nonatomic,copy)NSString * origin_url;//收录url
@property (nonatomic,copy)NSString * video_type;//视频格式
@property (nonatomic,copy)NSString * video_img_url;//缩略图地址
@property (nonatomic,copy)NSString * video_size;//视频大小
@property (nonatomic,copy)NSString * width;//宽
@property (nonatomic,copy)NSString * height;//高
@property (nonatomic,copy)NSString * comment;
@property (nonatomic,copy)NSString * relation_video;//关联视频


////题目 中国游客的俄罗斯开坦克之旅
//@property (nonatomic , copy) NSString * title;
////描述
//@property (nonatomic , copy) NSString * Description;
////图片 http://vimg1.ws.126.net/image/snapshot/2016/5/O/0/VBMJ81MO0.jpg
//@property (nonatomic , copy) NSString * cover;
////时长 1778
//@property (nonatomic , assign) CGFloat length;
////播放数 212839
//@property (nonatomic , copy) NSString * playCount;
////时间 2016-05-20 12:22:05
//@property (nonatomic , copy) NSString * ptime;
////视频地址 http://flv3.bn.netease.com/videolib3/1605/20/oeInQ8123/SD/oeInQ8123-mobile.mp4
//@property (nonatomic , copy) NSString * mp4_url;
////播放来源title 军武次位面
//@property (nonatomic , copy) NSString * topicName;
////播放来源图片 http://vimg2.ws.126.net/image/snapshot/2015/11/V/A/VBGA5DAVA.jpg
//@property (nonatomic , copy) NSString * topicImg;
@end
