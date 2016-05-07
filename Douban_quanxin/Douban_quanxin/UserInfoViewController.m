//
//  UserInfoViewController.m
//  Douban

//
//  Created by YANG on 16/5/5.
//  Copyright © 2016年 唐家文. All rights reserved.
//hh

#import "UserInfoViewController.h"
#include "CDSideBarController.h"

@interface UserInfoViewController ()
{
    NetworkManager* networkManager;//定义一个网络管理者
    UIStoryboard* mainStorboard;
    AppDelegate* appDelegate;
}

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mainStorboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //访问AppDelegate
    appDelegate=[[UIApplication sharedApplication]delegate];
    //给登陆图片添加手势
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loainImageTapped)];
    // 单击响应
    [singleTap setNumberOfTapsRequired:1];//singleTap有一次点击就会响应
    self.loainImage.userInteractionEnabled=YES;//允许交互
    [self.loainImage addGestureRecognizer:singleTap];//loainImage添加手势动作
    
    networkManager=[[NetworkManager alloc]init];
    networkManager.delegate=(id)self;//系统本身的协议
    
     
    
    
}
//界面即将出现
-(void)viewWillAppear:(BOOL)animated
{
    [self viewWillAppear:animated];
    //界面即将出现时，调用setUserInfo，将用户信息显示出来
    [self setUserInfo];
    
}

-(void)viewDidLayoutSubviews
{
    //即将布局子视图
    [super viewWillLayoutSubviews];
    //圆角化
    _loainImage.layer.cornerRadius=_loainImage.frame.size.width/2.0;
    if (!_loainImage.clipsToBounds) {
        _loainImage.clipsToBounds=YES;//省略视图的范围
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//登录图片的响应方法，实现见面跳转

-(void)loainImageTapped
{
    //通过故事面板找到对应的信息
    LoginViewController* loginVC=[mainStorboard instantiateViewControllerWithIdentifier:@"loginVC"];
    loginVC.delegate=(id)self;
    //加载CDSideBarController，释放右侧的菜单
    [[CDSideBarController sharedInstance] dismissMenu];
    //将loginVC设置为当前的界面
    [self presentViewController:loginVC animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(IBAction)logoutButtonTapped:(UIButton *)sender
{
    //提示框
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登出" message:@"您确定要登出么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertView show];


}
//
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            //退出登录
            [networkManager logout];
        default:
            break;
    }
}
-(void)setUserInfo{
    //用户已经存在
    if (appDelegate.userInfo.cookies)
    {
        //通过userID，获取用户上传的登陆图片
        [_loainImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img3.douban.com/icon/ul%@-1.jpg",appDelegate.userInfo.userID]]];
        _loainImage.userInteractionEnabled = NO;//忽略交互
        //获取用户的登陆信息
        _usernameLabel.text = appDelegate.userInfo.name;
        _playedLabel.text = appDelegate.userInfo.played;
        _likedLabel.text = appDelegate.userInfo.liked;
        _bannedLabel.text = appDelegate.userInfo.banned;
        _logoutButton.hidden = NO;//不隐藏
    }
    //用户不存在时，界面显示的内容
    else{
        [_loainImage setImage:[UIImage imageNamed:@"login"]];
        _loainImage.userInteractionEnabled = YES;
        _usernameLabel.text = @"";
        _playedLabel.text = @"0";
        _likedLabel.text = @"0";
        _bannedLabel.text = @"0";
        _logoutButton.hidden = YES;
    }
}
//注销成功后，调用setUserInfo来决定显示界面
-(void)logoutSuccess
{
    [self setUserInfo];
}


@end
