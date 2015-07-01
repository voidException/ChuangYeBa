//
//  DownloadTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/6/7.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "DownloadTableViewController.h"
#import "UserInfo.h"
#import "ArticleInfo.h"

#import "DownloadProgressCell.h"
#import "StudyDetailViewController.h"

#import "DownloadManager.h"
#import "DownloadTask.h"

#import <SDWebImage/UIImageView+WebCache.h>

static NSString *cellIdentifier = @"DownloadCell";

@interface DownloadTableViewController ()

@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) ArticleInfo *articleInfo;
@property (strong, nonatomic) NSMutableDictionary *downloadingDic;

@end

@implementation DownloadTableViewController


- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"离线下载";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _userInfo = [UserInfo loadUserInfoFromLocal];
    [self.tableView registerNib:[UINib nibWithNibName:@"DownloadProgressCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    DownloadManager *manager = [DownloadManager shareManager];
    _downloadingDic = manager.taskInfos;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStudent" bundle:nil];
    StudyDetailViewController *sdVC = [storyboard instantiateViewControllerWithIdentifier:@"StudyDetailViewController"];
    NSArray *arr = [_downloadingDic allKeys];
    [sdVC setValue:arr[indexPath.row] forKey:@"articleId"];
    [self showViewController:sdVC sender:self];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_downloadingDic count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *arr = [_downloadingDic allValues];
    
    __block DownloadTask *aTask = arr[indexPath.row];
    cell.titleLabel.text = aTask.articleInfo.title;
    [cell.mainImage sd_setImageWithURL:[NSURL URLWithString:aTask.articleInfo.miniPhotoURL] placeholderImage:[UIImage imageNamed:@"studyContentPlaceholderSmall"]];
    cell.mainImage.image = [UIImage imageNamed:@"studyContentPlaceholderSmall"];
    DownloadTask __weak *weakTask = aTask;
    aTask.initProgress = ^(long long totalBytesRead, long long totalBytesExpectedToRead){
        float progress = (float)totalBytesRead / totalBytesExpectedToRead;
        cell.progressView.progress = progress;
        cell.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
        cell.sizeLabel.text = [NSString stringWithFormat:@"%.1f M / %.1f M", totalBytesRead / pow(10, 6), totalBytesExpectedToRead / pow(10, 6)];
        cell.speedLabel.text = [NSString stringWithFormat:@"%@/S", weakTask.speed];
    };
    
    aTask.taskFailed = ^(){
        NSLog(@"块属性——下载失败");
    };
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *arr = [_downloadingDic allKeys];
        [[DownloadManager shareManager] deleteWithArticleId:arr[indexPath.row]];
        [_downloadingDic removeObjectForKey:arr[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
