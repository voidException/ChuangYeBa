//
//  StudentInfo.m
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "UserInfo.h"
#import "GlobalDefine.h"

#define NO_VALUE @""

@implementation UserInfo

@synthesize userId;
@synthesize name;
@synthesize userNo;
@synthesize major;
@synthesize school;
@synthesize classNo;
@synthesize department;
@synthesize college;
@synthesize universityNo;
@synthesize universityName;
@synthesize sex;
@synthesize inCollegeDate;
@synthesize email;
@synthesize password;
@synthesize photoPath;
@synthesize isPhotoUpload;
@synthesize tel;
@synthesize roomno;
- (id)init {
    self = [super init];
    if (self) {
        userId = [NSNumber numberWithInteger:0];
        name = NO_VALUE;
        userNo = NO_VALUE;
        major = NO_VALUE;
        school = NO_VALUE;
        classNo = NO_VALUE;
        department = NO_VALUE;
        college = NO_VALUE;
        universityNo= NO_VALUE;
        universityName = NO_VALUE;
        sex = NO_VALUE;
        email = NO_VALUE;
        password = NO_VALUE;
        photoPath = NO_VALUE;
        isPhotoUpload = @NO;
        tel = NO_VALUE;
        roomno = @"0";
    }
    return self;
}

- (instancetype)initWithUserDefault {
    self = [super init];
    if (self) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData *udObject = [ud objectForKey:@"userInfo"];
        self = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    }
    return self;
}

// 从本地读取用户信息。
+ (UserInfo *)loadUserInfoFromLocal {
    UserInfo *userInfo;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"userInfo"];
    userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    return userInfo;
}

// 保存用户信息到本地
+ (void)saveUserInfoToLocal:(UserInfo *)userInfo {
    if (userInfo) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        [ud setObject:udObject forKey:@"userInfo"];
        [ud synchronize];
    } else {
        
    }
}

// 删除本地的用户信息
+ (void)deleteUserInfoFromLocal {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"userInfo"];
    [ud synchronize];
}

#pragma Setter
- (void)setPhotoPathWithStorageURL:(NSString *)key {
    NSString *url = STORAGE_URL;
    NSString *str = [NSString stringWithFormat:@"%@%@", url, key];
    photoPath = str;
}

- (void)setPhotoPath:(NSString *)aPhotoPath {
    if ([aPhotoPath class] == [NSNull class]) {
        photoPath = @"";
    } else {
        photoPath = aPhotoPath;
    }
}

- (void)setSex:(NSString *)aSex {
    if ([aSex class] == [NSNull class]) {
        sex = @"女";
    } else {
        sex = aSex;
    }
}

- (void)setSchool:(NSString *)aSchool {
    if ([aSchool class] == [NSNull class]) {
        school = @"";
    } else {
        school = aSchool;
    }
}

- (void)setDepartment:(NSString *)aAepartment {
    if ([aAepartment class] == [NSNull class]) {
        department = @"";
    } else {
        department = aAepartment;
    }
}

- (void)setUniversityName:(NSString *)aUniversityName {
    if ([aUniversityName class] == [NSNull class]) {
        universityName = @"";
    } else {
        universityName = aUniversityName;
    }
}

- (void)setUniversityNo:(NSString *)aUniversityNo {
    if ([aUniversityNo class] == [NSNull class]) {
        universityNo = @"";
    } else {
        universityNo = aUniversityNo;
    }
}


#pragma Coding delegate
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self =[super init]) {
        userId = [aDecoder decodeObjectForKey:@"userId"];
        name = [aDecoder decodeObjectForKey:@"name"];
        userNo = [aDecoder decodeObjectForKey:@"userNo"];
        major = [aDecoder decodeObjectForKey:@"major"];
        school = [aDecoder decodeObjectForKey:@"school"];
        classNo = [aDecoder decodeObjectForKey:@"classNo"];
        department = [aDecoder decodeObjectForKey:@"department"];
        college = [aDecoder decodeObjectForKey:@"college"];
        universityNo = [aDecoder decodeObjectForKey:@"universityNo"];
        universityName = [aDecoder decodeObjectForKey:@"universityName"];
        sex = [aDecoder decodeObjectForKey:@"sex"];
        inCollegeDate = [aDecoder decodeObjectForKey:@"inCollegeDate"];
        email = [aDecoder decodeObjectForKey:@"email"];
        password = [aDecoder decodeObjectForKey:@"password"];
        photoPath = [aDecoder decodeObjectForKey:@"photoPath"];
        isPhotoUpload = [aDecoder decodeObjectForKey:@"isPhotoUpload"];
        tel = [aDecoder decodeObjectForKey:@"tel"];
        roomno = [aDecoder decodeObjectForKey:@"isAddedClass"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:userId forKey:@"userId"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:userNo forKey:@"userNo"];
    [aCoder encodeObject:major forKey:@"major"];
    [aCoder encodeObject:school forKey:@"school"];
    [aCoder encodeObject:classNo forKey:@"classNo"];
    [aCoder encodeObject:department forKey:@"department"];
    [aCoder encodeObject:college forKey:@"college"];
    [aCoder encodeObject:universityNo forKey:@"universityNo"];
    [aCoder encodeObject:universityName forKey:@"universityName"];
    [aCoder encodeObject:sex forKey:@"sex"];
    [aCoder encodeObject:inCollegeDate forKey:@"inCollegeDate"];
    [aCoder encodeObject:email forKey:@"email"];
    [aCoder encodeObject:password forKey:@"password"];
    [aCoder encodeObject:photoPath forKey:@"photoPath"];
    [aCoder encodeObject:isPhotoUpload forKey:@"isPhotoUpload"];
    [aCoder encodeObject:tel forKey:@"tel"];
    [aCoder encodeObject:roomno forKey:@"isAddedClass"];

}

#pragma mark - Copying delegate
- (id)copyWithZone:(NSZone *)zone {
    UserInfo *copy = [[[self class] allocWithZone:zone] init];
    copy.name = name;
    copy.userId = userId;
    copy.userNo = userNo;
    copy.school = school;
    copy.major = major;
    copy.classNo = classNo;
    copy.department = department;
    copy.college = college;
    copy.universityNo = universityNo;
    copy.universityName = universityName;
    copy.sex = sex;
    copy.inCollegeDate = inCollegeDate;
    copy.email = email;
    copy.password = password;
    copy.photoPath = photoPath;
    copy.isPhotoUpload = isPhotoUpload;
    copy.tel = tel;
    copy.roomno = roomno;
    return copy;
}

@end
