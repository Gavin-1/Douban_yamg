//
//  ChannelsTableViewController.h
//  Douban_quanxin
//
//  Created by lkjy on 16/5/5.
//  Copyright © 2016年 唐家文. All rights reserved.
//li

#import <UIKit/UIKit.h>
#import "ChannelInfo.h"
#import "ChannelsTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "NetworkManager.h"
#import "PlayerController.h"
#import "ProtocolClass.h"
@interface ChannelsTableViewController : UITableViewController
//设置万能指针指向代理
@property(nonatomic,weak)id <DoubanDelegate> delegate;
@property(nonatomic)NSMutableArray* channels;//
@property(nonatomic)NSArray* channelsTitle;//频道的Title
@property(nonatomic)NSArray* myChannels;//我的频道
@property(nonatomic)NSMutableArray* recommendChannels;//推荐频道
@property(nonatomic)NSMutableArray*upThredingChannels;//上升的频道
@property(nonatomic)NSMutableArray* hotChannels;//热门的频道


@end
