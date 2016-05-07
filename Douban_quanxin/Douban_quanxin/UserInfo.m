//
//  UserInfo.m
//  Douban
//
//  Created by lkjy on 16/5/4.
//  Copyright © 2016年 李浙. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if(self =[super init])
    {
        //是否登录
        self.isNotLogin=[dictionary valueForKey:@"r"];
        
        //用户的信息
        NSDictionary* tempUserInfoDic=[dictionary valueForKey:@"user_info"];
        self.cookies=[tempUserInfoDic valueForKey:@"ck"];
        self.userID=[tempUserInfoDic valueForKey:@"id"];
        self.name=[tempUserInfoDic valueForKey:@"name"];
        
        
        //用户的播放记录
        NSDictionary* tempPlayRecordDic=[tempUserInfoDic valueForKey:@"paly_record"];
        self.banned=[NSString stringWithFormat:@"%@",[tempPlayRecordDic valueForKey:@"banned"]];
        self.liked=[NSString stringWithFormat:@"%@",[tempPlayRecordDic valueForKey:@"liked"]];
        self.played=[NSString stringWithFormat:@"%@",[tempPlayRecordDic valueForKey:@"played"]];
        
    }
    return self;
}
//解码
-(id)initWithCoder:(NSCoder* )aDcoder
{
    if(self=[super init])
    {
        self.isNotLogin=[aDcoder decodeObjectForKey:@"isNotLogin"];
        self.cookies=[aDcoder decodeObjectForKey:@"cookies"];
        self.userID=[aDcoder decodeObjectForKey:@"userID"];
        self.name=[aDcoder decodeObjectForKey:@"name"];
        self.banned=[aDcoder decodeObjectForKey:@"banned"];
        self.liked=[aDcoder decodeObjectForKey:@"liked"];
        self.played=[aDcoder decodeObjectForKey:@"played"];
    }
    return self;
}
//编码(把这个东西写到磁盘的文件上)
-(void)encodeWithCoder:(NSCoder *)aCoder{
               //把谁编码               //根据什么关键字
    [aCoder encodeObject:_isNotLogin forKey:@"isNotLogin"];
    [aCoder encodeObject:_cookies forKey:@"cookies"];
    [aCoder encodeObject:_userID forKey:@"userID"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_banned forKey:@"banned"];
    [aCoder encodeObject:_liked forKey:@"liked"];
    [aCoder encodeObject:_played forKey:@"played"];
}

- (void)archiverUserInfo{
    //要把NSArray转化成NSData
    NSMutableData *data = [[NSMutableData alloc]init];
    //NSKeyedArchiver 基于关键字归档
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:@"userInfo"];
    [archiver finishEncoding];
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *appdelegatePath = [homePath stringByAppendingPathComponent:@"appdelegate.archiver"];
    //添加储存的文件名    本身返回一个BOOL类型的值，yes则文件写成功
    if ([data writeToFile:appdelegatePath atomically:YES]) {
        NSLog(@"UesrInfo存储成功");
    }
}









@end
