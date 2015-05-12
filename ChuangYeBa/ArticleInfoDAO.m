//
//  ArticleInfoDAO.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/6.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ArticleInfoDAO.h"

#define FILE_NAME @"AriticleListCache.archive"
#define ARCHIVE_KEY @"ArticleList"

@implementation ArticleInfoDAO

static ArticleInfoDAO *sharedManager = nil;

+ (ArticleInfoDAO *)shareManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        [sharedManager createEditableCopyOfDatabaseIfNeeded];
    });
    return sharedManager;
}

- (void)createEditableCopyOfDatabaseIfNeeded {
    /*
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    
    BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
    if (!dbexits) {
        NSString *path = [self applicationDocumentsDirectoryFile];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSMutableData * theData = [NSMutableData data];
        NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc]
                                      initForWritingWithMutableData:theData];
        [archiver encodeObject:array forKey:ARCHIVE_KEY];
        [archiver finishEncoding];
        [theData writeToFile:path atomically:YES];
    }
     */
}

- (NSString *)applicationDocumentsDirectoryFile:(NSInteger)tag {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileNameWithTag = [FILE_NAME stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]];
    NSString *path = [documentDirectory stringByAppendingPathComponent:fileNameWithTag];
    return path;
}


//插入缓存方法
- (int)create:(NSMutableArray *)articleList tag:(NSInteger)tag {
    NSString *path = [self applicationDocumentsDirectoryFile:tag];
    NSMutableData *theData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                  initForWritingWithMutableData:theData];
    [archiver encodeObject:articleList forKey:ARCHIVE_KEY];
    [archiver finishEncoding];
    [theData writeToFile:path atomically:YES];
    return 0;
}

//删除Note方法
- (int)clean {
    NSInteger tag = 11;
    NSString *path = [self applicationDocumentsDirectoryFile:tag];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableData * theData = [NSMutableData data];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc]
                                  initForWritingWithMutableData:theData];
    [archiver encodeObject:array forKey:ARCHIVE_KEY];
    [archiver finishEncoding];
    [theData writeToFile:path atomically:YES];
    return 0;
}


//查询所有数据方法
-(NSMutableArray *)findAll:(NSInteger)tag {
    NSString *path = [self applicationDocumentsDirectoryFile:tag];
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    NSData * theData =[NSData dataWithContentsOfFile:path];
    if([theData length] > 0) {
        NSKeyedUnarchiver * archiver = [[NSKeyedUnarchiver alloc]
                                        initForReadingWithData:theData];
        listData = [archiver decodeObjectForKey:ARCHIVE_KEY];
        [archiver finishDecoding];
    }
    return listData;
}

@end
