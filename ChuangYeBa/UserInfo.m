//
//  StudentInfo.m
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "UserInfo.h"
#import "GlobalDefine.h"

#define NO_VALUE @"NO_VALUE"

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

- (void)saveUserInfoToLocal {
    if (self) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:self];
        [ud setObject:udObject forKey:@"userInfo"];
        [ud synchronize];
    }
}

- (void)deleteUserInfoFromLocal {
    if (self) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud removeObjectForKey:@"userInfo"];
        [ud synchronize];
    }
}

- (void)setPhotoPathWithStorageURL:(NSString *)key {
    NSString *url = STORAGE_URL;
    NSString *str = [NSString stringWithFormat:@"%@%@", url, key];
    self.photoPath = str;
}

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
}

#pragma mark - Copying delegate

- (id)copyWithZone:(NSZone *)zone {
    UserInfo *copy = [[[self class] allocWithZone:zone] init];
    copy.name = self.name;
    copy.userId = self.userId;
    copy.userNo = self.userNo;
    copy.school = self.school;
    copy.major = self.major;
    copy.classNo = self.classNo;
    copy.department = self.department;
    copy.college = self.college;
    copy.universityNo = self.universityNo;
    copy.universityName = self.universityName;
    copy.sex = self.sex;
    copy.inCollegeDate = self.inCollegeDate;
    copy.email = self.email;
    copy.password = self.password;
    copy.photoPath = self.photoPath;
    copy.isPhotoUpload = self.isPhotoUpload;
    copy.tel = self.tel;
    return copy;
}

@end
