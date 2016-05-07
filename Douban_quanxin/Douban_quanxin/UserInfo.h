//
//  UserInfo.h
//  Douban
//
//  Created by lkjy on 16/5/4.
//  Copyright © 2016年 李浙 All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  本类是存放的是用户信息
 */
@interface UserInfo : NSObject
@property(nonatomic,copy)NSString* isNotLogin;//用户是否登录
@property(nonatomic,copy)NSString* cookies;//缓存？？？
@property(nonatomic,copy)NSString*   userID;//用户ID
@property(nonatomic,copy)NSString* name;//用户名
@property(nonatomic,copy)NSString* banned;//禁止播放的记录
@property(nonatomic,copy)NSString* liked;//用户添加喜欢的记录
@property(nonatomic,copy)NSString* played;//用户播放过的记录
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
-(void)archiverUserInfo;


@end
