//
//  LoginViewController.h
//  Douban
//
//  Created by YANG on 16/5/5.
//  Copyright © 2016年 唐家文. All rights reserved.
//唐

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "NetworkManager.h"
#import "AppDelegate.h"
#import "ProtocolClass.h"

@interface LoginViewController : UIViewController<DoubanDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *captchaImageView;//验证码图片View
@property (weak, nonatomic) IBOutlet UITextField *username;//用户名
@property (weak, nonatomic) IBOutlet UITextField *password;//密码
@property (weak, nonatomic) IBOutlet UITextField *captcha;//验证码
@property (weak, nonatomic)id<DoubanDelegate>delegate;//设置代理
- (IBAction)submitButtonTapped:(UIButton *)sender;//点击登录按钮
- (IBAction)cancelButtonTapped:(UIButton *)sender;//点击取消按钮
- (IBAction)backgroundTap:(id)sender;//点击背景

@end
