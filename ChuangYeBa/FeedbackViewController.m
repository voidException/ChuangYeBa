//
//  FeedbackViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/19.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "FeedbackViewController.h"
#import "GlobalDefine.h"
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>

static NSString *serverIP = SERVER_IP;

@interface FeedbackViewController () <UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestWebsite];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)requestWebsite {
    NSString *path = @"/startup/more/advise";
    path = [serverIP stringByAppendingString:path];
    NSURL * url = [NSURL URLWithString:path];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}



@end
