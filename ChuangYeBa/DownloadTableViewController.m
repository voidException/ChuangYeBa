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
#import "StudyNetworkUtils.h"
#import "StudyJsonParser.h"
#import <AFNetworking.h>
#import "DownloadProgressCell.h"
#import "ArticleInfoDAO.h"
#import "StudyDetailViewController.h"

static NSString *cellIdentifier = @"DownloadCell";

@interface DownloadTableViewController ()

@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) ArticleInfo *articleInfo;

@end

@implementation DownloadTableViewController


+ (DownloadTableViewController *)sharedDownloadController
{
    static DownloadTableViewController *sharedDTVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDTVC = [[self alloc] init];
    });
    
    return sharedDTVC;
}

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Method
- (void)addDownloadTaskWithArticleId:(NSNumber *)articleId {
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStudent" bundle:nil];
    StudyDetailViewController *sdVC = [storyboard instantiateViewControllerWithIdentifier:@"StudyDetailViewController"];
    [sdVC setValue:@78 forKey:@"articleId"];
    [self showViewController:sdVC sender:self];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell addDownloadTaskWithArticleId:@78];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
