//
//  NetworkUtils.m
//  Demo4
//
//  Created by Developer on 15/6/30.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "DownloadTask.h"
#import "UserInfo.h"


@implementation DownloadTask



- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self =[super init]) {
        _taskId = [aDecoder decodeObjectForKey:@"taskId"];
        _articleInfo = [aDecoder decodeObjectForKey:@"articleInfo"];
        _state = [aDecoder decodeObjectForKey:@"state"];
        _totalBytesRead = [aDecoder decodeObjectForKey:@"totalBytesRead"];
        _totalBytesExpectedToRead = [aDecoder decodeObjectForKey:@"totalBytesExpectedToRead"];
        _operation = [aDecoder decodeObjectForKey:@"operation"];
        _date = [aDecoder decodeObjectForKey:@"taskDate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_taskId forKey:@"taskId"];
    [aCoder encodeObject:_articleInfo forKey:@"articleInfo"];
    [aCoder encodeObject:_state forKey:@"state"];
    [aCoder encodeObject:_totalBytesRead forKey:@"totalBytesRead"];
    [aCoder encodeObject:_totalBytesExpectedToRead forKey:@"totalBytesExpectedToRead"];
    [aCoder encodeObject:_operation forKey:@"operation"];
    [aCoder encodeObject:_date forKey:@"taskDate"];
}

- (void)dealloc {
    
}


#pragma mark - Public method
- (void)setDownloadTaskWithArticleId:(NSNumber *)articleId success:(void (^)())success failure:(void (^)(NSError *))failure {
    
    _taskId = articleId;
    _totalBytesExpectedToRead = @0;
    _totalBytesRead = @1;
    // 状态为0，正在连接
    self.state = @0;
    
    UserInfo *userInfo = [UserInfo loadUserInfoFromLocal];
    [StudyNetworkUtils requestArticleDetailWithToken:userInfo.email userId:userInfo.userId articleId:articleId andCallback:^(id obj) {
        if (!obj) {
            /**
             *  执行failure块
             */
            _state = @2;
            if (failure) {
                NSError *error;
                failure(error);
            }

        }
        else {
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            if ([error isEqual: @1]) {
               
                _articleInfo = [StudyJsonParser parseArticleInfo:[dic objectForKey:@"article"]];
                // 记录开始下载的时间
                _date = [NSDate date];
                // 初始化上一秒大小变量
                _lastSecondSize = 0;
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *aSavePath = documentDirectory;
                NSString *aFileName = [NSString stringWithFormat:@"media-%@",_articleInfo.articleId];
                NSString *aExtension = [_articleInfo.realURL pathExtension];
                //检查本地文件是否已存在
                NSString *fileName = [NSString stringWithFormat:@"%@/%@.%@",aSavePath, aFileName, aExtension];
                
                
                ArticleInfoDAO *dao = [ArticleInfoDAO shareManager];
                NSString *articleFileName = [NSString stringWithFormat:@"OfflineArticles%@.archive", _articleInfo.articleId];
                NSMutableArray *articles = [[NSMutableArray alloc] init];
                articles = [dao findAll:articleFileName];
                /**
                 *  用文章的本地化文件判断是否已经下载了
                 */
                if (articles.count) {
#ifdef DEBUG
                    NSLog(@"媒体已经存在");
#endif
                    // 状态为2（取消或者暂停）
                    self.state = @2;
                    return;
                } else {
                   // 创建附件存储目录
                    if (![fileManager fileExistsAtPath:aSavePath]) {
                        [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    // 下载附件
                    NSURL *url = [[NSURL alloc] initWithString:_articleInfo.realURL];
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    _operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    _operation.inputStream   = [NSInputStream inputStreamWithURL:url];
                    _operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
                    
                    /**
                     *  避免retain cycle
                     */
                    DownloadTask __weak *weakSelf = self;
                    
                    //下载进度控制
                    [_operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
#ifdef DEBUG
                        //NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
#endif
                        weakSelf.totalBytesRead = [NSNumber numberWithLongLong:totalBytesRead];
                        weakSelf.totalBytesExpectedToRead = [NSNumber numberWithLongLong:totalBytesExpectedToRead];
                        
                        //计算一秒中的速度
                        long long thisSecondSize = totalBytesRead - weakSelf.lastSecondSize;
                        //获取当前时间
                        NSDate *currentDate = [NSDate date];
                        //当前时间和上一秒时间做对比，大于等于一秒就去计算
                        if ([currentDate timeIntervalSinceDate:_date] >= 1) {
                            //时间差
                            double time = [currentDate timeIntervalSinceDate:weakSelf.date];
                            //计算速度
                            long long speed = (long long)thisSecondSize/time;
                            //把速度转成KB或M
                            weakSelf.speed = [weakSelf formatByteCount:speed];
                            //维护变量，把现在的接受大小记录为上一秒的大小，便于计算
                            weakSelf.lastSecondSize = totalBytesRead;
                            NSLog(@"date = %@, speed = %@", currentDate, weakSelf.speed);
                            //维护变量，记录这次计算的时间
                            weakSelf.date = currentDate;
                        }
                        
                        if (weakSelf.initProgress != nil) {
                            weakSelf.initProgress(totalBytesRead, totalBytesExpectedToRead);
                        }
                    }];
                    //已完成下载
                    [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef DEBUG
                        NSLog(@"下载完成");
#endif
                        // 下载成功，保存下载文件的路径 
                        weakSelf.articleInfo.realURL = [NSString stringWithFormat:@"%@.%@", aFileName, aExtension];
                        NSMutableArray *articles = [[NSMutableArray alloc] init];
                        // 从文章列表中读出全部文章，然后加入新的文章并且保存
                        ArticleInfoDAO *dao = [ArticleInfoDAO shareManager];
                        NSString *articleFileName = [NSString stringWithFormat:@"OfflineArticles%@.archive", weakSelf.articleInfo.articleId];
                        articles = [dao findAll:articleFileName];
#warning 可能有逻辑问题，待改进
                        [articles insertObject:weakSelf.articleInfo atIndex:0];
                        [dao create:articles flieName:articleFileName];
                        /**
                         *  执行success块
                         */
                        if(success) {
                            success();
                        }
                        // 设置状态为3
                        weakSelf.state = @3;
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef DEBUG
                        NSLog(@"下载失败%@", [error localizedDescription]);
#endif
                        // 下载失败删除下载文件
                        if ([fileManager fileExistsAtPath:fileName]) {
                            [fileManager removeItemAtPath:fileName error:nil];
                        }
                        
                        if (weakSelf.taskFailed != nil) {
                            weakSelf.taskFailed();
                        }
                        /**
                         *  执行failure块
                         */
                        weakSelf.state = @2;
                        if (failure) {
                            failure(error);
                        }
                                            }];
                    [_operation start];
                    // 设置状态为1，表示开始下载
                    self.state = @1;
                }
            }
        }
    }];
}


- (void)setState:(NSNumber *)state {
    _state = state;
    [self.delegate downloadTask:self forState:_state];
}

- (NSString *)mediaPath {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *aSavePath = documentDirectory;
    NSString *aFileName = [NSString stringWithFormat:@"media-%@",_articleInfo.articleId];
    NSString *aExtension = [_articleInfo.realURL pathExtension];
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.%@",aSavePath, aFileName, aExtension];
    return fileName;
}

- (void)deleteDownloadTaskWithArticleId:(NSNumber *)articleId {
    // 取消下载请求
    if (_operation.isExecuting) {
        [_operation cancel];
    }
    // 状态为2（取消或错误）
    self.state = @2;
    // 删除已经下载的文件
    NSString *aSavePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *aFileName = [NSString stringWithFormat:@"media-%@", articleId];
    NSString *aExtension = [_articleInfo.realURL pathExtension];
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.%@",aSavePath, aFileName, aExtension];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName]) {
        [fileManager removeItemAtPath:fileName error:nil];
    }
    
    ArticleInfoDAO *dao = [ArticleInfoDAO shareManager];
    NSString *articleFileName = [NSString stringWithFormat:@"OfflineArticles%@.archive", _articleInfo.articleId];
    [dao clean:articleFileName];
}

- (void)stopDownloadTaskWithArticleId:(NSNumber *)articleId {
    [_operation cancel];
}


#pragma mark - Private Method
/**
 *  转换data的大小为NSString类型，同时带上单位符号
 *
 *  @param size data大小
 *
 *  @return 带KB符号的String类型
 */
- (NSString *)formatByteCount:(long long)size
{
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}

@end
