//
//  DownloadManager.h
//  Demo4
//
//  Created by Developer on 15/6/30.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadTask.h"
#import "DownloadTaskInfoDAO.h"

@interface DownloadManager : NSObject

/**
 *  当前的下载队列信息
 */
@property (nonatomic, strong) NSMutableDictionary *taskInfos;

/**
 *  下载管理器
 *
 *  @return 下载管理器的单例对象
 */
+ (DownloadManager *)shareManager;

/**
 *  根据文章ID开始一个下载任务
 *
 *  @param articleId 文章ID
 */
- (void)startWithArticleId:(NSNumber *)articleId;

/**
 *  根据文章ID删除一个下载任务
 *
 *  @param articleId 文章ID
 */
- (void)deleteWithArticleId:(NSNumber *)articleId;


@end
