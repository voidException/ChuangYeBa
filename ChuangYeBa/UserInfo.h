//
//  StudentInfo.h
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject <NSCoding, NSCopying>

// 学生老师共有的数据表参数
@property (copy, nonatomic) NSNumber *userId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *userNo;
@property (copy, nonatomic) NSString *major;
@property (copy, nonatomic) NSString *school;
@property (copy, nonatomic) NSString *classNo;
@property (copy, nonatomic) NSString *department;
@property (copy, nonatomic) NSString *college;
@property (copy, nonatomic) NSString *universityNo;
@property (copy, nonatomic) NSString *universityName;
@property (copy, nonatomic) NSString *sex;
@property (strong, nonatomic) NSDate *inCollegeDate;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *photoPath;
@property (copy, nonatomic) NSNumber *isPhotoUpload;
@property (copy, nonatomic) NSNumber *roomno;

// 只要老师才有的数据
@property (copy, nonatomic) NSString *tel;

// 非数据表参数
@property (copy, nonatomic) NSString *passwordConfirm;

- (instancetype)initWithUserDefault;


+ (UserInfo *)loadUserInfoFromLocal;

+ (void)saveUserInfoToLocal:(UserInfo *)userInfo;

+ (void)deleteUserInfoFromLocal;


- (id)initWithCoder:(NSCoder *)aDecoder;

- (void)encodeWithCoder:(NSCoder *)aCoder;

// Setter
- (void)setPhotoPathWithStorageURL:(NSString *)key;

@end
