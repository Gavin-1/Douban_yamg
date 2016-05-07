//
//  ProtocolClass.h
//  DouBanFM_mine
//
//  Created by lk1 on 16/5/3.
//  Copyright © 2016年 lk1. All rights reserved.
//

#import <Foundation/Foundation.h>
//添加协议
@protocol DoubanDelegate <NSObject>
@optional
//登陆界面delegate
-(void)setCaptchaImageWithURLInString:(NSString *)url;
-(void)loginSuccess;
-(void)logoutSuccess;

//播放列表delegate
-(void)reloadTableviewData;

//初始化歌曲delegate
-(void)initSongInfomation;

//初始化用户信息delegate
-(void)setUserInfo;

//通过下标点击按钮
-(void)menuButtonClicked:(int)index;

@end


@interface ProtocolClass : NSObject

@end
