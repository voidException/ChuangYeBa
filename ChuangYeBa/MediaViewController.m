//
//  MediaViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/19.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "MediaViewController.h"
#import <AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/UIButton+AFNetworking.h>
#import <SDWebImageManager.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QiniuSDK.h>
#import "ArticleInfo.h"
#import <MBProgressHUD.h>

#define SERVER_IP

@interface MediaViewController () <MBProgressHUDDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *insideView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) ArticleInfo *articleInfo;
@property (nonatomic) BOOL isClickOnDone;

@end

@implementation MediaViewController
@synthesize isClickOnDone;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    isClickOnDone = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    if (!isClickOnDone) {
        // ArticleType = 2 为长图文章 = 3为视频文章 = 1为纯文字文章
        if ([_articleInfo.articleType integerValue] == 72) {
            // 加载下载长图
            [self downloadLongImage:_articleInfo.realURL];
        } else {
            [self loadVideo:_articleInfo.realURL];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initUI {
    self.view.backgroundColor = [UIColor blackColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.insideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.insideView];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.insideView addSubview:self.imageView];
    self.imageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressImage)];
    [self.scrollView addGestureRecognizer:longPress];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - Action
- (void)longPressImage {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 视频读取相关
- (void)loadVideo:(NSString *)videoName {
    if (_moviePlayer == nil) {
        NSURL *url = [NSURL URLWithString:videoName];
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        //_moviePlayer.view.frame = self.view.frame;
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        _moviePlayer.controlStyle = MPMovieControlStyleDefault;
        [self.view addSubview:_moviePlayer.view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackFinished4MoviePlayerController:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doneButtonClick:)
                                                     name:MPMoviePlayerWillExitFullscreenNotification
                                                   object:nil];
    }
    
    
    [_moviePlayer play];
    [_moviePlayer setFullscreen:YES animated:NO];

}

- (void)playbackFinished4MoviePlayerController: (NSNotification *) notification {
    // 结束后暂停
}


-(void)doneButtonClick:(NSNotification*)aNotification {

    if (_moviePlayer.playbackState == MPMoviePlaybackStateStopped)
    {
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
    }
    isClickOnDone = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 长图读取相关
- (void)downloadLongImage:(NSString *)imageName {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.color = [UIColor grayColor];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.labelText = @"正在加载";
    [HUD show:YES];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:imageName] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        HUD.progress = (float)receivedSize/expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            HUD.tag = 1;
            [HUD hide:YES];
            CGSize size = image.size;
            float height = size.height * self.view.frame.size.width / size.width;
            self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
            self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
            
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageView setImage:image];
        } else {
            HUD.tag = 0;
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.animationType = MBProgressHUDAnimationZoomIn;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errormark"]];
            HUD.labelText = @"网络出错了>_<";
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        }
    }];
}

#pragma MBProgressHUD delegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (hud.tag == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
