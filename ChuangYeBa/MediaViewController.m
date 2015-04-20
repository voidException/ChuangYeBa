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
#import <MediaPlayer/MediaPlayer.h>

#define SERVER_IP

@interface MediaViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *insideView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (nonatomic) NSNumber *mediaType;

@end

@implementation MediaViewController
@synthesize mediaType;


#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *buttonTemp = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 340, 200)];
    buttonTemp.titleLabel.text = @"textButton";
    [buttonTemp addTarget:self action:@selector(clickOnButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonTemp];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    if ([mediaType integerValue]) {
        [self downloadLongImage:nil];
    } else {
        [self loadVideo:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private Method
- (void)initUI {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.insideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.insideView];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.insideView addSubview:self.imageView];
    
    self.imageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressImage)];
    [self.imageView addGestureRecognizer:longPress];
    //[self.navigationController.navigationBar setHidden:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - Action
- (void)clickOnButton {
    [self loadVideo:nil];
}

- (void)longPressImage {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 视频读取相关
- (void)loadVideo:(NSString *)videoName {
    if (_moviePlayer == nil) {
        //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_IP,videoName]];
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *moviePath = [bundle pathForResource:@"YY"
                                               ofType:@"mp4"];
        NSLog(@"%@", moviePath);
        
        
        NSURL *url = [NSURL fileURLWithPath:moviePath];
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

- (void) playbackFinished4MoviePlayerController: (NSNotification*) notification
{
    NSLog(@"使用MPMoviePlayerController播放完成.");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_moviePlayer stop];
    [_moviePlayer.view removeFromSuperview];
    _moviePlayer = nil;
}


-(void)doneButtonClick:(NSNotification*)aNotification
{
    NSLog(@"退出全屏.");
    if (_moviePlayer.playbackState == MPMoviePlaybackStateStopped)
    {
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 长图读取相关
- (void)downloadLongImage:(NSString *)imageName{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://ww1.sinaimg.cn/bmiddle/70e0a133jw1eraqxhurxaj20c83ig47c.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        NSString *aPath = [NSString stringWithFormat:@"%@/Documents/70e0a133jw1eraqxhurxaj20c83ig47c.jpg", NSHomeDirectory()];
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:aPath];
        NSLog(@"w = %f, h = %f", image.size.width, image.size.height);
        CGSize size = image.size;
        
        float height = size.height * self.view.frame.size.width / size.width;
        self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageView setImage:image];
    }];
    [downloadTask resume];

}


@end
