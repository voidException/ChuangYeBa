//
//  StudyContentViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyContentViewController.h"

@interface StudyContentViewController ()

@end

@implementation StudyContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    // 增加下啦刷新
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        NSLog(@"load refresh");
        [self.tableView.header endRefreshing];
    }];
    [self.tableView.legendHeader beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - UITableViewDataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 发送通知
    NSLog(@"send notif");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowStudyDetail" object:self userInfo:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *studyContentCellIndentifier = @"StudyContentCell";
    StudyContentCell *studyContentCell = [tableView dequeueReusableCellWithIdentifier:studyContentCellIndentifier];
    studyContentCell.titleLabel.text = @"什么是生涯";
    //studyContentCell.mainImage.image = [UIImage imageNamed:@"USA.png"];
    studyContentCell.introductionLabel.text = @"大学生生涯是职业生涯积累也是一个过程……";
    return studyContentCell;
}

@end
