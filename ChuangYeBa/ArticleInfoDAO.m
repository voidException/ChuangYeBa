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
    });
    return sharedManager;
}

#pragma mark - Public Method
//插入缓存方法
- (void)create:(NSMutableArray *)articleList flieName:(NSString *)fileName {
    NSString *path = [self applicationDocumentsDirectoryFile:fileName];
    NSMutableData *theData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:theData];
    [archiver encodeObject:articleList forKey:ARCHIVE_KEY];
    [archiver finishEncoding];
    [theData writeToFile:path atomically:YES];
}

//删除Note方法
- (void)clean:(NSString *)fileName {
    fileName = [self applicationDocumentsDirectoryFile:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName]) {
        [fileManager removeItemAtPath:fileName error:nil];
    }
}


//查询所有数据方法
- (NSMutableArray *)findAll:(NSString *)fileName {
    NSString *path = [self applicationDocumentsDirectoryFile:fileName];
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


#pragma mark - Private Method
/**
 *  组装文件路径和名称
 *
 *  @param fileName 文件名
 *
 *  @return 返回document路径下加上文件名的完整路径
 */
- (NSString *)applicationDocumentsDirectoryFile:(NSString *)fileName {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:fileName];
    return path;
}

@end
