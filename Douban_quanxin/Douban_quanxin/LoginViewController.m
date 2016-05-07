//
//  LoginViewController.m
//  Douban
//
//  Created by YANG on 16/5/5.
//  Copyright © 2016年 唐家文. All rights reserved.
//

#import "LoginViewController.h"
#import "NetworkManager.h"
#import <UIImageView+AFNetworking.h>
@interface LoginViewController ()
{
    NSMutableString* captchaID;//验证码ID
    NetworkManager* networkManager;//单例
    AppDelegate* appDelegate;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate=[UIApplication sharedApplication].delegate;
    networkManager=[NetworkManager new];
    networkManager.delegate=(id)self;
    //初始化图片点击事件
    UITapGestureRecognizer* singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadCaptchaImage)];
    //设置为单击
    [singleTap setNumberOfTapsRequired:1];
    self.captchaImageView.userInteractionEnabled=YES;
    [self.captchaImageView addGestureRecognizer:singleTap];
}
//View将要出现时
-(void)viewWillAppear:(BOOL)animated
{
    //加载验证码
    [self loadCaptchaImage];
    [super viewWillAppear:animated];
}
//加载验证码图片事件
-(void)loadCaptchaImage
{
    [networkManager loadCaptchaImage];
}
- (IBAction)submitButtonTapped:(UIButton *)sender
{
    //获取输入的信息
    NSString* username=_username.text;
    NSString* password=_password.text;
    NSString* captcha=_captcha.text;
    //登录验证
    [networkManager LoginwithUsername:username Password:password Captcha:captcha RememberOnorOff:@"off"];
}
//取消按钮的事件
- (IBAction)cancelButtonTapped:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backgroundTap:(id)sender
{
    //取消第一响应者的身份
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    [_captcha resignFirstResponder];
}
//代理实现 协议DoubanDelegate中的方法
-(void)loginSuccess
{
    [_delegate setUserInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//通过url来获取验证码图片
-(void)setCaptchaImageWithURLInString:(NSString *)url
{
    [self.captchaImageView setImageWithURL:[NSURL URLWithString:url]];
}

@end
