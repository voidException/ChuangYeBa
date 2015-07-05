//
//  NetworkUtils.h
//  Demo4
//
//  Created by Developer on 15/6/30.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleInfo.h"
#import "ArticleInfoDAO.h"
#import "StudyNetworkUtils.h"
#import <AFNetworking.h>
#import "StudyJsonParser.h"
#import "DownloadTaskInfo.h"

typedef void (^initProgress)(long long totalBytesRead, long long totalBytesExpectedToRead);

typedef void (^taskFailed)(void);

@class DownloadTask;
@protocol DownloadTaskDelegate <NSObject>

- (void)downloadTask:(DownloadTask *)downloadTask forState:(NSNumber *)state;

@end

@interface DownloadTask : NSObject <NSCoding>

/**
 *  下载任务的委托
 */
@property (weak, nonatomic) id <DownloadTaskDelegate> delegate;

/**
 *  当前下载的编号，TaskId即为下载文章的编号（articleInfo.articleId可能为空）
 */
@property (strong, nonatomic) NSNumber *taskId;

/**
 *  当前下载任务的文章信息
 */
@property (nonatomic, strong) ArticleInfo *articleInfo;

/**
 *  当前下载的状态，0为正在连接，1为正在下载，2为错误，3为成功，4为暂停（暂不支持）
 */
@property (strong, nonatomic) NSNumber *state;

/**
 *  当前已经下载的比特数
 */
@property (strong, nonatomic) NSNumber *totalBytesRead;

/**
 *  指定媒体的大小
 */
@property (strong, nonatomic) NSNumber *totalBytesExpectedToRead;

/**
 *  计算当前下载的时间节点，用于计算下载速度，同时记录下载完成时间
 */
@property (nonatomic, strong) NSDate *date;

/**
 *  下载的请求器
 */
@property (nonatomic, strong) __block AFHTTPRequestOperation *operation;

/**
 *  记录上一秒所下载的总大小
 */
@property (nonatomic, assign) long long lastSecondSize;

/**
 *  下载速度
 */
@property (nonatomic, strong) NSString *speed;

/**
 *  下载进度控制的块属性
 */
@property (copy) void (^initProgress)(long long totalBytesRead, long long totalBytesExpectedToRead);

/**
 *  处理任务失败的块属性
 */
@property (copy) taskFailed taskFailed;

/**
 *  获得媒体文件的存储路径
 *
 *  @return 媒体文件的存储路径
 */
- (NSString *)mediaPath;

/**
 *  启动一个下载文章任务
 *
 *  @param articleId 文章ID
 *  @param success   成功情况下的块语句
 *  @param failure   失败情况下的块语句
 */
- (void)setDownloadTaskWithArticleId:(NSNumber *)articleId
                             success:(void (^)())success
                             failure:(void (^)(NSError *error))failure;

/**
 *  删除一个下载文章任务并且删除已经下载的媒体
 *
 *  @param articleId 文章ID
 */
- (void)deleteDownloadTaskWithArticleId:(NSNumber *)articleId;

/**
 *  停止一个下载文章任务
 *
 *  @param articleId 停止一个文章的下载任务
 */
- (void)stopDownloadTaskWithArticleId:(NSNumber *)articleId;

@end
