//
//  CommentInfo.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/28.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject

@property (strong, nonatomic) NSNumber *commentId;
@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *commentTime;
@property (copy, nonatomic) NSString *userName;
@property (strong, nonatomic) NSNumber *userId;
@property (copy, nonatomic) NSString *userPhotoPath;

@end
