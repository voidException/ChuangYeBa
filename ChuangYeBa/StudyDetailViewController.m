//
//  StudyDetailViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyDetailViewController.h"

static NSString *articleCellIndentifier = @"ArticleCell";
static NSString *mediaCellIndentifer = @"MediaCell";
static NSString *commentCellIndentifier = @"CommentCell";

// 测试文章
static NSString *artical = @"那些年错过的大雨 那些年错过的爱情 好想拥抱你 拥抱错过的勇气 曾经想征服全世界 到最后回首才发现 这世界滴滴点点全部都是你 那些年错过的大雨 那些年错过的爱情 好想告诉你 告诉你我没有忘记 那天晚上满天星星 平行时空下的约定 再一次相遇我会紧紧抱着你 紧紧抱着你 那些年错过的大雨 那些年错过的爱情 好想拥抱你 拥抱错过的勇气 曾经想征服全世界 到最后回首才发现 这世界滴滴点点全部都是你 那些年错过的大雨 那些年错过的爱情 好想告诉你 告诉你我没有忘记 那天晚上满天星星 平行时空下的约定 再一次相遇我会紧紧抱着你 紧紧抱着你 那些年错过的大雨 那些年错过的爱情 好想拥抱你 拥抱错过的勇气 曾经想征服全世界 到最后回首才发现 这世界滴滴点点全部都是你 那些年错过的大雨 那些年错过的爱情 好想告诉你 告诉你我没有忘记 那天晚上满天星星 平行时空下的约定 那些年错过的大雨 那些年错过的爱情 好想拥抱你 拥抱错过的勇气 曾经想征服全世界 到最后回首才发现/n 这世界滴滴点点全部都是你 那些年错过的大雨 那些年错过的爱情 好想告诉你 告诉你我没有忘记 那些年错过的大雨 那些年错过的爱情 好想拥抱你 拥抱错过的勇气 曾经想征服全世界 到最后回首才发现 这世界滴滴点点全部都是你 那些年错过的大雨 那些年错过的爱情 好想告诉你 告诉你我没有忘记 那天晚上满天星星 平行时空下的约定 再一次相遇我会紧紧抱着你 紧紧抱着你 那些年错过的大雨 那些年错过的爱情 好想拥抱你 拥抱错过的勇气 曾经想征服全世界 到最后回首才发现 这世界滴滴点点全部都是你 那些年错过的大雨 那些年错过的爱情 好想告诉你 告诉你我没有忘记 那天晚上满天星星 平行时空下的约定 再一次相遇我会紧紧抱着你 紧紧抱着你 那些年错过的大雨 那些年错过的爱情 好想拥抱你 拥抱错过的勇气 曾经想征服全世界 到最后回首才发现 这世界滴滴点点全部都是你 那些年错过的大雨 那些年错过的爱情 好想告诉你 告诉你我没有忘记 那天晚上满天星星 平行时空下的约定 那些年错过的大雨 那些年错过的爱情";

@interface StudyDetailViewController ()

@end

@implementation StudyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"userComment" ofType:@"plist"];
    self.userComment = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    
    
    // 响应键盘弹出的通知
    // self.tabBarController.tabBar.hidden = YES;
    
#warning tabBar的弹出有bug，等详细需求提供后再修复
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    // 初始化委托对象
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.toolbar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

// 键盘出现后调整视图
-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.origin.y = currentFrame.origin.y - change ;
    self.view.frame = currentFrame;
}

// 键盘消失后调整视图
-(void)keyboardWillDisappear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.origin.y = currentFrame.origin.y + change ;
    self.view.frame = currentFrame;
}

// 点击发送后响应的动作
- (IBAction)clickOnSendButton:(id)sender {
    if (![self.textInputBar.text isEqual:nil]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"Me", @"userName", self.textInputBar.text, @"comment", nil];
        
        [self.tableView beginUpdates];
        [self.userComment insertObject:dic atIndex:0];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationBottom];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView endUpdates];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        //[self.tableView scrollsToTop]
        
    }
    if (self.textInputBar.isFirstResponder) {
        [self.textInputBar resignFirstResponder];
    }
}


#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 有文章、视频/图片、评论为3
    // 有文章、评论为2
    // 应该由服务器回复得知
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == ArticleSection || section == MediaSection) {
        return 1;
    }
    else {
        return self.userComment.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ArticleSection) {
        return [self articleCellForRowAtIndexPath:indexPath];
    }
    else if (indexPath.section == MediaSection) {
        return [self mediaCellForRowAtIndexPath:indexPath];
    }
    else {
        return [self commentCellForRowAtIndexPath:indexPath];
    }
}

- (ArticleCell *)articleCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCell *articleCell = (ArticleCell *)[self.tableView dequeueReusableCellWithIdentifier:articleCellIndentifier];
    articleCell.title.text = @"第一篇实验文章";
    articleCell.article.text = artical;
    return articleCell;
}

- (MediaCell *)mediaCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MediaCell *mediaCell = (MediaCell *)[self.tableView dequeueReusableCellWithIdentifier:mediaCellIndentifer];
    return mediaCell;
}


- (CommentCell *)commentCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *commentCell = (CommentCell *)[self.tableView dequeueReusableCellWithIdentifier:commentCellIndentifier];
    NSDictionary *dic = self.userComment[indexPath.row];
    commentCell.userName.text = [dic objectForKey:@"userName"];
    commentCell.comment.text = [dic objectForKey:@"comment"];
    return commentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ArticleSection) {
        NSString *message = artical;
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                     NSParagraphStyleAttributeName: paragraphStyle};
        
        CGFloat width = CGRectGetWidth(tableView.frame)-(kAvatarSize*2.0 + 10);
        
        CGRect bounds = [message boundingRectWithSize:CGSizeMake(width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        
        
        
        if (message.length == 0) {
            return 0.0;
        }
        
        CGFloat height = roundf(CGRectGetHeight(bounds)+kAvatarSize);
        
        if (height < kMinimumHeight) {
            height = kMinimumHeight;
        }
        NSLog(@"Cell width = %f height = %f",width, height);
        return height + 37;

    } else if (indexPath.section == MediaSection){
        // 需要自适应计算
        return 120;
    } else {
        return 60;
    }

}




@end
