//
//  DownloadTaskInfo.m
//  ChuangYeBa
//
//  Created by Developer on 15/7/1.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "DownloadTaskInfo.h"

@implementation DownloadTaskInfo

- (instancetype)initWithArticleId:(NSNumber *)articleId {
    self = [super init];
    if (self) {
        _taskId = articleId;
        _articleInfo = nil;
        _state = @2;
        _totalBytesRead = @0;
        _totalBytesExpectedToRead = @0;
    }
    return self;
}

- (instancetype)initWithDownloadTask:(DownloadTask *)downloadTask {
    self = [super init];
    if (self) {
        _articleInfo = downloadTask.articleInfo;
        _taskDate = downloadTask.date;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self =[super init]) {
        _taskId = [aDecoder decodeObjectForKey:@"taskId"];
        _articleInfo = [aDecoder decodeObjectForKey:@"articleInfo"];
        _state = [aDecoder decodeObjectForKey:@"state"];
        _totalBytesRead = [aDecoder decodeObjectForKey:@"totalBytesRead"];
        _totalBytesExpectedToRead = [aDecoder decodeObjectForKey:@"totalBytesExpectedToRead"];
        _taskDate = [aDecoder decodeObjectForKey:@"taskDate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_taskId forKey:@"taskId"];
    [aCoder encodeObject:_articleInfo forKey:@"articleInfo"];
    [aCoder encodeObject:_state forKey:@"state"];
    [aCoder encodeObject:_totalBytesRead forKey:@"totalBytesRead"];
    [aCoder encodeObject:_totalBytesExpectedToRead forKey:@"totalBytesExpectedToRead"];
    [aCoder encodeObject:_taskDate forKey:@"taskDate"];
}


@end
