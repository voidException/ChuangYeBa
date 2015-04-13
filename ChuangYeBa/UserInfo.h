//
//  StudentInfo.h
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *studentNo;
@property (strong, nonatomic) NSString *major;
@property (strong, nonatomic) NSString *school;
@property (strong, nonatomic) NSString *classNo;
@property (strong, nonatomic) NSString *department;
@property (strong, nonatomic) NSString *college;
@property (strong, nonatomic) NSString *universityNo;
@property (strong, nonatomic) NSString *universityName;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSDate *inCollegeDate;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *passwordConfirm;
@property (strong, nonatomic) NSString *photoPath;
@property BOOL isPhotoUpload;

- (id)initWithCoder:(NSCoder *)aDecoder;

- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
