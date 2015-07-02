//
//  DownloadManager.m
//  Demo4
//
//  Created by Developer on 15/6/30.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "DownloadManager.h"

static NSString *downloadedListFileName = @"downloaedList";

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
        // 正在下载的队列
        DownloadTaskInfoDAO *dao = [DownloadTaskInfoDAO shareManager];
        
        NSMutableDictionary *dataList = [dao findTaskInfos];
        if (dataList) {
            _taskInfos = dataList;
        } else {
            _taskInfos = [[NSMutableDictionary alloc] init];
        }
        
        // 已经下载的队列
        ArticleInfoDAO *infoDao = [ArticleInfoDAO shareManager];
        NSMutableArray *downloadedList = [infoDao findAll:downloadedListFileName];
        if (downloadedList) {
            _downloadedTaskInfos = downloadedList;
        } else {
            _downloadedTaskInfos = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)startTaskWithArticleId:(NSNumber *)articleId {
    __block DownloadTask *aTask = [[DownloadTask alloc] init];
    aTask.delegate = self;
    DownloadTask __weak *weakTask = aTask;
    [aTask setDownloadTaskWithArticleId:articleId success:^{
        // 下载成功后，将添加已经下载的列表到保存的文章列表当中
        [_downloadedTaskInfos insertObject:weakTask.articleInfo atIndex:0];
        [[ArticleInfoDAO shareManager] create:_downloadedTaskInfos flieName:downloadedListFileName];
        // 下载成功后，将下载队列中的下载任务删除
        [_taskInfos removeObjectForKey:weakTask.articleInfo.articleId];
        [[DownloadTaskInfoDAO shareManager] deleteTaskInfoWithKey:weakTask.articleInfo.articleId];
        // 执行下载完成委托
        [self.delegate downloadManagerFinishedOneTask:weakTask];
    } failure:^(NSError *error) {
        // 下载失败后将当前的下载状态保存到DownloadTaskInfoDAO
        NSLog(@"DownloadManager Failure");
        DownloadTaskInfoDAO *dao = [DownloadTaskInfoDAO shareManager];
        [dao addTaskInfo:weakTask forKey:articleId];
    }];
    DownloadTaskInfoDAO *dao = [DownloadTaskInfoDAO shareManager];
    // 先寻找是否已经有任务信息，如果有，则把原来的信息传递给信的任务信息
    NSMutableDictionary *dic = [dao findTaskInfos];
    DownloadTask *oldTask = [dic objectForKey:articleId];
    if (oldTask) {
        aTask.articleInfo = oldTask.articleInfo;
    }
    [dao addTaskInfo:aTask forKey:articleId];
    [_taskInfos setObject:aTask forKey:articleId];
}

- (void)retryTaskWithArticleId:(NSNumber *)articleId {
    
}

- (void)deleteTaskWithArticleId:(NSNumber *)articleId {
    DownloadTask *aTask = [_taskInfos objectForKey:articleId];
    [aTask deleteDownloadTaskWithArticleId:articleId];
    [_taskInfos removeObjectForKey:articleId];
    DownloadTaskInfoDAO *dao = [DownloadTaskInfoDAO shareManager];
    [dao deleteTaskInfoWithKey:articleId];
}

- (void)deleteDownloaedArticleAtIndex:(NSInteger)index {
    // 删除媒体文件
    [self deleteDownloaedMediaAtIndex:index];
    // 删除文章数组中的文章
    ArticleInfoDAO *dao = [ArticleInfoDAO shareManager];
    NSMutableArray *array = [dao findAll:downloadedListFileName];
    [array removeObjectAtIndex:index];
    // 重新创建文章数组
    [dao create:array flieName:downloadedListFileName];
}

/**
 *  删除文章对应的媒体文件
 *
 *  @param index 带删除媒体的文章index
 */
- (void)deleteDownloaedMediaAtIndex:(NSInteger)index {
    ArticleInfoDAO *dao = [ArticleInfoDAO shareManager];
    NSMutableArray *array = [dao findAll:downloadedListFileName];
    ArticleInfo *articleInfo = array[index];
    NSString *fileName = articleInfo.realURL;
    NSString *aSavePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    fileName = [NSString stringWithFormat:@"%@/%@", aSavePath, fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName]) {
        [fileManager removeItemAtPath:fileName error:nil];
    }
    NSString *articleFileName = [NSString stringWithFormat:@"OfflineArticles%@.archive", articleInfo.articleId];
    [dao clean:articleFileName];
}

- (void)downloadTask:(DownloadTask *)downloadTask forState:(NSNumber *)state {
    [self.delegate downloadManagerTaskStateChange:downloadTask forState:state];
}

@end
