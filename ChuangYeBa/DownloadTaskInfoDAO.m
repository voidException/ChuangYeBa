//
//  DownloadTaskInfoDAO.m
//  ChuangYeBa
//
//  Created by Developer on 15/7/1.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "DownloadTaskInfoDAO.h"

static NSString *fileName = @"DownloadTaskInfos";

static NSString *ARCHIVE_KEY = @"DownloadTaskInfos";

@implementation DownloadTaskInfoDAO

+ (DownloadTaskInfoDAO *)shareManager {
    static DownloadTaskInfoDAO *sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)addTaskInfo:(DownloadTask *)downloadTask forKey:(NSNumber *)key {
    if (downloadTask == nil) {
        return;
    }
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableData *theData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:theData];
    NSMutableDictionary *listData = [self findTaskInfos];
    [listData setObject:downloadTask forKey:key];
    [archiver encodeObject:listData forKey:ARCHIVE_KEY];
    [archiver finishEncoding];
    [theData writeToFile:path atomically:YES];
}

- (void)deleteTaskInfo:(DownloadTask *)downloadTask forKey:(NSNumber *)key {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableData *theData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:theData];
    NSMutableDictionary *listData = [self findTaskInfos];
    [listData removeObjectForKey:key];
    [archiver encodeObject:listData forKey:ARCHIVE_KEY];
    [archiver finishEncoding];
    [theData writeToFile:path atomically:YES];
}

- (NSMutableDictionary *)findTaskInfos {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableDictionary *listData = [[NSMutableDictionary alloc] init];
    NSData * theData =[NSData dataWithContentsOfFile:path];
    if([theData length] > 0) {
        NSKeyedUnarchiver * archiver = [[NSKeyedUnarchiver alloc]
                                        initForReadingWithData:theData];
        listData = [archiver decodeObjectForKey:ARCHIVE_KEY];
        [archiver finishDecoding];
    }
    return listData;
}

- (NSString *)applicationDocumentsDirectoryFile{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:fileName];
    return path;
}


@end
