//
//  DownloadTableViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/6/7.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadTableViewController : UITableViewController

+ (DownloadTableViewController *)sharedDownloadController;

- (void)addDownloadTaskWithArticleId:(NSNumber *)articleId;

@end
