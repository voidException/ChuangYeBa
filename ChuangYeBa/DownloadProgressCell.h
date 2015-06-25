//
//  DownloadProgressCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/6/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfo;
@class ArticleInfo;
@interface DownloadProgressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) ArticleInfo *articleInfo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)addDownloadTaskWithArticleId:(NSNumber *)articleId;

@end
