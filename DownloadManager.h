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

@class DownloadManager;
@protocol DownloadManagerDelegate <NSObject>

- (void)downloadManagerFinishedOneTask:(DownloadTask *)downloadTask;
- (void)downloadManagerTaskStateChange:(DownloadTask *)downloadTask forState:(NSNumber *)state;

@end

@interface DownloadManager : NSObject <DownloadTaskDelegate>

/**
 *  当前的下载队列信息
 */
@property (nonatomic, strong) NSMutableDictionary *taskInfos;

/**
 *  已经下载好的信息
 */
@property (nonatomic, strong) NSMutableArray *downloadedTaskInfos;

/**
 *  下载管理器委托
 */
@property (nonatomic, weak) id <DownloadManagerDelegate> delegate;

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
- (void)startTaskWithArticleId:(NSNumber *)articleId;

/**
 *  根据文章ID删除一个下载任务
 *
 *  @param articleId 文章ID
 */
- (void)deleteTaskWithArticleId:(NSNumber *)articleId;

/**
 *  根据文章ID重试一个任务
 *
 *  @param articleId 文章ID
 */
- (void)retryTaskWithArticleId:(NSNumber *)articleId;

/**
 *  删除一篇已经下载的文章
 *
 *  @param index 文章在文章数组中的Index
 */
- (void)deleteDownloaedArticleAtIndex:(NSInteger)index;


@end
