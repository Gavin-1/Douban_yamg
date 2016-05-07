//
//  UserInfoViewController.h
//  Douban
//
//  Created by YANG on 16/5/5.
//  Copyright © 2016年 唐家文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIKit+AFNetworking.h>
#import "LoginViewController.h"
#import "NetworkManager.h"
#import "AppDelegate.h"
#import "ProtocolClass.h"
//杨先环，洋相
/**
 *  本类是用户信息的逻辑处理
 */
@interface UserInfoViewController : UIViewController<DoubanDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *loainImage;/**<登录图片*/
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;/**<用户名*/

@property (weak, nonatomic) IBOutlet UILabel *playedLabel;/**<播放的曲目*/
@property (weak, nonatomic) IBOutlet UILabel *likedLabel;/**<喜欢的歌曲*/
@property (weak, nonatomic) IBOutlet UILabel *bannedLabel;/**<禁止播放*/
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;/**<注销按钮*/

//响应注销按钮
- (IBAction)logoutButtonTapped:(UIButton *)sender;

//建立用户信息
-(void)setUserInfo;
//注销成功
-(void)logoutSuccess;

@end
