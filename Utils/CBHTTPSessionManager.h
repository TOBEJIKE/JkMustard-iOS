//
//  CBHTTPSessionManager.h
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBHTTPSessionManager : NSObject

+ (void)post:(NSString *)requestURL
              params:(NSMutableDictionary *)parmas
             success:(void (^)(id data))success
                fail:(void (^)(NSError *error))fail;

@end
