//
//  NetworkManager.h
//  Douban
//
//  Created by lk on 16/5/4.
//  Copyright © 2016年 唐家文. All rights reserved.
//主要功能：向服务器请求数据
#import <Foundation/Foundation.h>
#import "ProtocolClass.h"

@interface NetworkManager : NSObject

@property (weak, nonatomic)id<DoubanDelegate>delegate;
@property (nonatomic) NSMutableString *captchaID;

+ (instancetype)sharedInstancd;

-(instancetype)init;

//通过ur路劲来获取频道
-(void)setChannel:(NSUInteger)channelIndex withURLWithString:(NSString *)urlWithString;

-(void)LoginwithUsername:(NSString *)username//用户名
                Password:(NSString *)password//密码
                 Captcha:(NSString *)captcha//验证码
         RememberOnorOff:(NSString *)rememberOnorOff;

-(void)logout;

-(void)loadCaptchaImage;//加载验证码图片

-(void)loadPlaylistwithType:(NSString *)type;//加载播放列表的类型
@end

