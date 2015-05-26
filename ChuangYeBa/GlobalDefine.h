//
//  GlobalDefine.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/17.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#ifndef ChuangYeBa_GlobalDefine_h
#define ChuangYeBa_GlobalDefine_h

#import <UIKit/UIKit.h>

#endif

// 家里的地址
//#define SERVER_IP @"http://192.168.1.9:8080/"
// 云的地址
#define SERVER_IP @"http://123.56.112.178:8080"
// 公司的地址
//#define SERVER_IP @"http://10.174.89.44:8080/"
// 启航的地址
//#define SERVER_IP @"http://192.168.1.102:8080/"
// 错误的地址
//#define SERVER_IP @"http://123.56.112./"

#define STORAGE_URL @"http://7xizdh.com2.z0.glb.qiniucdn.com/"

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size): NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size): NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size): NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size): NO)

#define CYBBlueColor colorWithRed:44.0/255 green:149.0/255 blue:255.0/255 alpha:1
#define CYBRedColor colorWithRed:236.0/255 green:80.0/255 blue:80.0/255 alpha:1.0


