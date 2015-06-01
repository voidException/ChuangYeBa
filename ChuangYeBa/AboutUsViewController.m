//
//  AboutUsViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/13.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "AboutUsViewController.h"
#import "GlobalDefine.h"
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>

static NSString *serverIP = SERVER_IP;

@interface AboutUsViewController () <UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;

@end

@implementation AboutUsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestWebsite];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestWebsite {
    NSString *path = @"/startup/more/aboutUs";
    path = [serverIP stringByAppendingString:path];
    NSURL * url = [NSURL URLWithString:path];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
