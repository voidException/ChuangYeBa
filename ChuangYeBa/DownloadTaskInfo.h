//
//  DownloadTaskInfo.h
//  ChuangYeBa
//
//  Created by Developer on 15/7/1.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleInfo.h"
#import "DownloadTask.h"

@interface DownloadTaskInfo : NSObject <NSCoding>

- (instancetype)initWithArticleId:(NSNumber *)articleId;

//- (instancetype)initWithDownloadTask:(DownloadTask *)downloadTask;

/**
 *  当前下载的编号，TaskId即为下载文章的编号（articleInfo.articleId可能为空）
 */
@property (strong, nonatomic) NSNumber *taskId;

/**
 *  当前下载的文章的文章号
 */
@property (strong, nonatomic) ArticleInfo *articleInfo;

/**
 *  当前下载的状态，0为成功，1为暂停，2为取消
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
 *  添加任务的时间
 */
@property (strong, nonatomic) NSDate *taskDate;

@end
