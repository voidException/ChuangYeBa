//
//  DownloadProgressCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/6/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "DownloadProgressCell.h"
#import "StudyNetworkUtils.h"
#import "StudyJsonParser.h"
#import <AFNetworking.h>
#import "ArticleInfoDAO.h"

@implementation DownloadProgressCell

- (void)awakeFromNib {
    _userInfo = [UserInfo loadUserInfoFromLocal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addDownloadTaskWithArticleId:(NSNumber *)articleId {
    [StudyNetworkUtils requestArticleDetailWithToken:_userInfo.email userId:_userInfo.userId articleId:articleId andCallback:^(id obj) {
        if (obj) {
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            if ([error isEqual: @1]) {
                _articleInfo = [StudyJsonParser parseArticleInfo:[dic objectForKey:@"article"]];
                [self downloadMediaWithURL:_articleInfo.realURL];
            }
            
        }
    }];
}

- (void)downloadMediaWithURL:(NSString *)stringURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *aSavePath = documentDirectory;
    NSString *aFileName = [NSString stringWithFormat:@"%@", _articleInfo.articleId];
    NSString *aExtension = [stringURL pathExtension];
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.%@",aSavePath, aFileName, aExtension];
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName]) {
#ifdef DEBUG
        NSLog(@"视频已经存在");
#endif
    }else{
        //创建附件存储目录
        if (![fileManager fileExistsAtPath:aSavePath]) {
            [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //下载附件
        NSURL *url = [[NSURL alloc] initWithString:stringURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.inputStream   = [NSInputStream inputStreamWithURL:url];
        operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
        
        //下载进度控制
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
#ifdef DEBUG
            NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
#endif
            _progressView.progress = (float)totalBytesRead/totalBytesExpectedToRead;
        }];
        //已完成下载
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef DEBUG
            NSLog(@"下载完成");
#endif
            // 下载完成后保存
            _articleInfo.realURL = [NSString stringWithFormat:@"%@.%@", aFileName, aExtension];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObject:_articleInfo];
            ArticleInfoDAO *dao = [ArticleInfoDAO shareManager];
            NSInteger aTag = 10000 + [_articleInfo.articleId integerValue];
            [dao create:arr tag:aTag];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef DEBUG
            NSLog(@"下载失败%@", [error localizedDescription]);
#endif
        }];
        
        [operation start];
    }
}

@end
