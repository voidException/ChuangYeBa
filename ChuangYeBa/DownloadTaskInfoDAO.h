//
//  DownloadTaskInfoDAO.h
//  ChuangYeBa
//
//  Created by Developer on 15/7/1.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadTask.h"

@interface DownloadTaskInfoDAO : NSObject

/**
 *  返回下载列表数据访问对象
 *
 *  @return 下载列表的单例
 */
+ (DownloadTaskInfoDAO *)shareManager;

/**
 *  添加一条新的下载任务信息
 *
 *  @param downloadTaskInfo 待添加的下载任务信息
 */
- (void)addTaskInfo:(DownloadTask *)downloadTask forKey:(NSNumber *)key;

/**
 *  删除一条下载任务信息
 *
 *  @param key 下载任务的KEY
 */
- (void)deleteTaskInfoWithKey:(NSNumber *)key;

/**
 *  查询下载任务列表
 *
 *  @return 返回当前存储的下载任务列表
 */
- (NSMutableDictionary *)findTaskInfos;


@end
