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
#import "StudyContentCell.h"
#import "DownloadManager.h"
#import "DownloadTask.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <NYSegmentedControl.h>
#import "GlobalDefine.h"

static NSString *downloadCellIdentifier = @"DownloadCell";
static NSString *contentCellIdentifier = @"ContentCell";

@interface DownloadTableViewController () <DownloadManagerDelegate>

@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) ArticleInfo *selectedArticleInfo;
@property (strong, nonatomic) NSMutableDictionary *downloadingDic;
@property (strong, nonatomic) NSMutableArray *downloadedArr;
@property (strong, nonatomic) NYSegmentedControl *segmentedControl;

@end

@implementation DownloadTableViewController


- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _userInfo = [UserInfo loadUserInfoFromLocal];
    DownloadManager *manager = [DownloadManager shareManager];
    manager.delegate = self;
    _downloadingDic = manager.taskInfos;
    _downloadedArr = manager.downloadedTaskInfos;
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 当从下载点入文章返回时会执行两次viewWillAppear,增加此判断防止出现分段控件的闪烁
    if (self.segmentedControl.alpha == 0.f) {
        [self.segmentedControl setAlpha:0.0];
    }
    [self.navigationController.navigationBar addSubview:self.segmentedControl];
    [UIView animateWithDuration:0.3 animations:^{
        [self.segmentedControl setAlpha:1.0];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        [_segmentedControl setAlpha:0.0];
    } completion:^(BOOL finished) {
        [_segmentedControl removeFromSuperview];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Method
- (void)initUI {
    // 初始化TableView的属性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"DownloadProgressCell" bundle:nil] forCellReuseIdentifier:downloadCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"StudyContentCell" bundle:nil] forCellReuseIdentifier:contentCellIdentifier];
    
    // 初始化新导航条分段控件
    NSArray *segmentedTitle = @[@"已下载", @"正在下载"];
    _segmentedControl = [[NYSegmentedControl alloc] initWithItems:segmentedTitle];
    
    _segmentedControl.titleTextColor = [UIColor whiteColor];
    _segmentedControl.titleFont = [UIFont systemFontOfSize:16.0f];
    _segmentedControl.selectedTitleTextColor = [UIColor CYBBlueColor];
    _segmentedControl.selectedTitleFont = [UIFont systemFontOfSize:16.0f];
    _segmentedControl.segmentIndicatorBackgroundColor = [UIColor whiteColor];
    _segmentedControl.backgroundColor = [UIColor clearColor];
    _segmentedControl.borderWidth = 1.0f;
    _segmentedControl.segmentIndicatorBorderWidth = 0.0f;
    _segmentedControl.segmentIndicatorInset = 0.0f;
    _segmentedControl.segmentIndicatorBorderColor = [UIColor whiteColor];
    [_segmentedControl sizeToFit];
    _segmentedControl.cornerRadius = CGRectGetHeight(_segmentedControl.frame) / 2.0f;
    _segmentedControl.borderColor = [UIColor whiteColor];
    if (iPhone4 || iPhone5) {
        _segmentedControl.frame = CGRectMake(0, 0, 200, 32);
    } else {
        _segmentedControl.frame = CGRectMake(0, 0, 230, 32);
    }
    _segmentedControl.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 21.5);
    _segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(doSomethingInSegment:) forControlEvents:UIControlEventValueChanged];
    
    // 返回按钮
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backButtonIcon"] landscapeImagePhone:nil style:UIBarButtonItemStyleDone target:self action:@selector(clickOnBackButton:)];
    self.navigationItem.leftBarButtonItem = btn;
}

#pragma mark - Action
- (void)doSomethingInSegment:(NYSegmentedControl *)seg {
    [self.tableView reloadData];
}

- (void)clickOnBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 只有在已下载中才可以打开文章
    if (_segmentedControl.selectedSegmentIndex == 0) {
        _selectedArticleInfo = _downloadedArr[indexPath.row];
        [self performSegueWithIdentifier:@"ShowStudyDetail" sender:self];
    } else {
        
        NSArray *keyArr = [_downloadingDic allKeys];
        NSArray *valueArr = [_downloadingDic allValues];
        DownloadTask *aTask = valueArr[indexPath.row];
        // 只有在错误状态或暂停状态（暂不支持）下才能重新开始任务
        if ([aTask.state isEqual:@2]) {
            [[DownloadManager shareManager] startTaskWithArticleId:keyArr[indexPath.row]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            return [_downloadedArr count];
            break;
        case 1:
            return [_downloadingDic count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        StudyContentCell *studyContentCell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
        ArticleInfo *article = _downloadedArr[indexPath.row];
        studyContentCell.titleLabel.text = article.title;
        
        NSString *path = article.miniPhotoURL;
        [studyContentCell.mainImage sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"studyContentPlaceholderSmall"]];
        
        studyContentCell.likeLabel.text = [NSString stringWithFormat:@"%@", article.likes];
        studyContentCell.commentLabel.text = [NSString stringWithFormat:@"%@", article.comments];
        
        // 如果副标题超过25个字符，则需要截断
        NSString *viceTitle = article.viceTitle;
        NSUInteger maxLength = 27;
        if (article.viceTitle.length > maxLength) {
            viceTitle = [article.viceTitle stringByReplacingCharactersInRange: NSMakeRange(maxLength, article.viceTitle.length - maxLength) withString:@"..."];
        }
        studyContentCell.introductionLabel.text = viceTitle;
        return studyContentCell;

    } else {
        DownloadProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadCellIdentifier];
        NSArray *arr = [_downloadingDic allValues];
        __block DownloadTask *aTask = arr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = aTask.articleInfo.title;
        [cell.mainImage sd_setImageWithURL:[NSURL URLWithString:aTask.articleInfo.miniPhotoURL] placeholderImage:[UIImage imageNamed:@"studyContentPlaceholderSmall"]];
        
        // 如果下载状态是正在连接情况下
        if ([aTask.state isEqual:@0]) {
            cell.state = DownloadCellStateFailed;
            
        }
        else if ([aTask.state isEqual:@2]) {
            cell.state = DownloadCellStateFailed;
            float progress = (float)[aTask.totalBytesRead longLongValue] / [aTask.totalBytesExpectedToRead longLongValue];
            cell.progressView.progress = progress;
            cell.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
        }
        // 如果下载状态是正在下载情况下
        else if ([aTask.state isEqual:@1]) {
            cell.state = DownloadCellStateDownloading;
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
        }
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_segmentedControl.selectedSegmentIndex == 0) {
            [[DownloadManager shareManager] deleteDownloaedArticleAtIndex:indexPath.row];
            [_downloadedArr removeObjectAtIndex:indexPath.row];
        } else {
            NSArray *arr = [_downloadingDic allKeys];
            [[DownloadManager shareManager] deleteTaskWithArticleId:arr[indexPath.row]];
            [_downloadingDic removeObjectForKey:arr[indexPath.row]];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Download Manager Delegate
- (void)downloadManagerFinishedOneTask:(DownloadTask *)downloadTask {
    // 当下载完成后重新加载一次下载管理器中的内容,并且重新加载TableView
    _downloadingDic = [DownloadManager shareManager].taskInfos;
    _downloadedArr = [DownloadManager shareManager].downloadedTaskInfos;
    [self.tableView reloadData];
}


- (void)downloadManagerTaskStateChange:(DownloadTask *)downloadTask forState:(NSNumber *)state {
    NSLog(@"in table view state change to %@", state);
    [self.tableView reloadData];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowStudyDetail"]) {
        UIViewController *destinationVC = segue.destinationViewController;
        [destinationVC setValue:_selectedArticleInfo.articleId forKey:@"articleId"];
    }
}


@end
