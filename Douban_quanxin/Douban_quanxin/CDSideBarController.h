//
//  CDSideBarController.h
//  Douban
//
//  Created by lk1 on 16/5/4.
//  Copyright © 2016年 唐家文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//添加一个协议，协议可以继承和被继承；协议中的方法有@optional和@requirel两种
@protocol CDSideBarControllerDelegate <NSObject>

-(void)menuButtonClicked:(int)index;

@end

@interface CDSideBarController : NSObject
{
    UIView* _backgroundMenuView;//背景菜单View
    UIButton* _menuButton;//菜单button
    NSMutableArray* _buttonList;//button列表
}
@property(nonatomic,retain)UIColor* menuColor;//菜单颜色
@property(nonatomic,assign)BOOL isOpen;//打开状态
//设置代理
@property(nonatomic,weak)id<CDSideBarControllerDelegate>delegate;

+(CDSideBarController *)sharedInstanceWithImages:(NSArray*)images;//初始化sharedInstance图片数组
+(CDSideBarController *)sharedInstance;//初始化单例
- (CDSideBarController*)initWithImages:(NSArray*)buttonList;//初始化图片按钮
- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position;//通过位置来插入button到View中
- (void)dismissMenu;//释放菜单

@end
