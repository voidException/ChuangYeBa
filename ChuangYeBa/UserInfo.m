//
//  StudentInfo.m
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self =[super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.studentNo = [aDecoder decodeObjectForKey:@"studentNo"];
        self.major = [aDecoder decodeObjectForKey:@"major"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.school = [aDecoder decodeObjectForKey:@"school"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.studentNo forKey:@"studentNo"];
    [aCoder encodeObject:self.major forKey:@"major"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.school forKey:@"school"];
}

@end
