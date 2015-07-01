//
//  DownloadManager.m
//  Demo4
//
//  Created by Developer on 15/6/30.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager

+ (DownloadManager *)shareManager {
    static DownloadManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        DownloadTaskInfoDAO *dao = [DownloadTaskInfoDAO shareManager];
        NSMutableDictionary *dataList = [dao findTaskInfos];

        if (dataList) {
            _taskInfos = dataList;
        } else {
            _taskInfos = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)startWithArticleId:(NSNumber *)articleId {
    DownloadTask *aTask = [[DownloadTask alloc] init];
    [aTask setDownloadTaskWithArticleId:articleId success:^{
        NSLog(@"DownloadManager Success");
    } failure:^(NSError *error) {
        NSLog(@"DownloadManager Failure");
    }];
    
    DownloadTaskInfoDAO *dao = [DownloadTaskInfoDAO shareManager];
    [dao addTaskInfo:aTask forKey:articleId];
    
    [_taskInfos setObject:aTask forKey:articleId];
}


- (void)deleteWithArticleId:(NSNumber *)articleId {
    DownloadTask *aTask = [_taskInfos objectForKey:articleId];
    [aTask stopDownloadTaskWithArticleId:articleId];
    [_taskInfos removeObjectForKey:articleId];
    DownloadTaskInfoDAO *dao = [DownloadTaskInfoDAO shareManager];
    [dao deleteTaskInfo:nil forKey:articleId];
}

@end
