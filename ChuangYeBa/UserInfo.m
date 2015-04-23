//
//  StudentInfo.m
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "UserInfo.h"

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
        isPhotoUpload = NO_VALUE;
        tel = NO_VALUE;
    }
    return self;
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

@end
