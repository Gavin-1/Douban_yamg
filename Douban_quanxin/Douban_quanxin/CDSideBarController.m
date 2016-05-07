//
//  CDSideBarController.m
//  Douban
//
//  Created by lk1 on 16/5/4.
//  Copyright © 2016年 唐家文. All rights reserved.
//

#import "CDSideBarController.h"
static CDSideBarController* sharedInstance;//单例
@implementation CDSideBarController

//@synthesize自动产生setter和getter方法
@synthesize menuColor=_menuColor;
@synthesize isOpen=_isOpen;

#pragma mark------Singleton（单例）
/**
 *  在objective-c中要实现一个单例类，至少需要做以下四个步骤：
 　　1、为单例对象实现一个静态实例，并初始化，然后设置成nil，
 　　2、实现一个实例构造方法检查上面声明的静态实例是否为nil，如果是则新建并返回一个本类的实例，
 　　3、重写allocWithZone方法，用来保证其他人直接使用alloc和init试图获得一个新实例的时候不
       产生一个新实例，
 　　4、适当实现allocWitheZone，copyWithZone，release和autorelease。
 */
+(CDSideBarController *)sharedInstanceWithImages:(NSArray*)images
{
    //整个片断在程序运行过程中只执行一遍
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedInstance=[[CDSideBarController alloc]initWithImages:images];
    });
    return sharedInstance;
}
+(CDSideBarController *)sharedInstance
{
    //判断sharedInstance是否为nil
    if(sharedInstance!=nil)
    {
        return sharedInstance;
    }
    return nil;
}
//实现allocWithZone方法
//为sharedInstance分配内存空间
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
    if(sharedInstance==nil)
    {
        sharedInstance=[super allocWithZone:zone];//初始化sharedInstance
    }
    });
    return sharedInstance;
}

#pragma mark------init
- (CDSideBarController*)initWithImages:(NSArray*)images
{
    //menuButton的设置
    _menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _menuButton.bounds=CGRectMake(0, 0, 40, 40);
    [_menuButton setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    //创建backgroundMenuView（右侧菜单）
    _backgroundMenuView=[UIView new];
    //设置右侧菜单的颜色
    _menuColor=[UIColor whiteColor];
    //右侧菜单中buttonList中button的个数
    _buttonList=[[NSMutableArray alloc]initWithCapacity:images.count];
    
    int index=0;
    //遍历图片数组
    for(UIImage* image in [images copy])
    {
        UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
        //给每个button添加图片
        [button setImage:image forState:UIControlStateNormal];
        //设置每个button的位置
        button.frame=CGRectMake(20, 50+(80*index), 50, 50);
        button.tag=index;
        //设置button的移动
        button.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 70, 0);
        [button addTarget:self action:@selector(onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        //添加到buttonList中
        [_buttonList addObject:button];
        ++index;
    }
    return self;
}
- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position
{
    //menuButton的位置
    _menuButton.frame=CGRectMake(position.x, position.y, _menuButton.bounds.size.width, _menuButton.bounds.size.height);
    //添加menuButton
    [view addSubview:_menuButton];
    //添加手势   单击时释放右侧菜单
    UITapGestureRecognizer* singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMenu)];
    singleTap.cancelsTouchesInView=NO;
    //给View添加单击手势
    [view addGestureRecognizer:singleTap];
    
    //遍历buttonList
    for(UIButton* button in _buttonList)
    {
        //把buttonList中的button添加到backgroudMenuView中
        [_backgroundMenuView addSubview:button];
    }
    //backgroudMenuView的设置
    _backgroundMenuView.frame=CGRectMake(view.frame.size.width, 0, 90, view.frame.size.height);
    _backgroundMenuView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
    //添加backgroudMenuView
    [view addSubview:_backgroundMenuView];
}
#pragma mark------MenuButton action
//释放选中的button瞬间的Animation
-(void)dissmissMenuWithSelection:(UIButton*)button
{
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.2f initialSpringVelocity:10.0f options:0 animations:^{
        //放缩
        button.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
    } completion:^(BOOL finished) {
        [self dismissMenu];
    }];
}
//释放右侧菜单
- (void)dismissMenu
{
    if(_isOpen)
    {
        //关闭
        _isOpen=!_isOpen;
        [self performDismissAnimation];
    }
}
-(void)showMenu
{
    //先判断右侧菜单是否打开了
    if(!_isOpen)
    {
        //打开
        _isOpen=!_isOpen;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
    }
}
//点击菜单按钮中的button
-(void)onMenuButtonClick:(UIButton*)button
{
    if([self.delegate respondsToSelector:@selector(menuButtonClicked:)])
    {
        //通过tag来确定点击的是哪个button
        [self.delegate menuButtonClicked:(int)button.tag];
    }
    [self dissmissMenuWithSelection:button];
}
#pragma mark-----Animation
//释放右侧菜单瞬间的Animation
-(void)performDismissAnimation
{
    [UIView animateWithDuration:0.4f animations:^{
        //menuButton显示
        _menuButton.alpha=1.0f;
        _menuButton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        
        //backgroungMenuView消失
        _backgroundMenuView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIButton* button in _buttonList)
        {
            //button消失
            [UIView animateWithDuration:0.4f animations:^{
                button.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 70, 0);
            }];
        }
    });
}
//打开右侧菜单瞬间的Animation
-(void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4f animations:^{
            //menuButton消失
            _menuButton.alpha=0;
            _menuButton.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
            
            //backgroungMenuView显示
            _backgroundMenuView.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
        }];
    });
    for (UIButton* button in _buttonList)
    {
        //沉睡
        [NSThread sleepForTimeInterval:0.02f];
        //异步线程     将代码块添加到主队列中（dispath向主队列加一个异步的block，调用diapatch的线程不等待dispatch执行完）
        dispatch_async(dispatch_get_main_queue(), ^{
            //button弹出时的Animation
            [UIView animateWithDuration:0.3f delay:0.3f usingSpringWithDamping:0.7f initialSpringVelocity:10.0f options:0 animations:^{
                button.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
            } completion:nil];
        });
    }
}

@end
