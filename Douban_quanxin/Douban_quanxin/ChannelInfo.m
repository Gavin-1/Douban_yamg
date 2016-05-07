//
//  ChannelInfo.m
//  Douban
//
//  Created by YANG on 16/5/3.
//  Copyright © 2016年 唐家文. All rights reserved.
//

#import "ChannelInfo.h"
/**
 *  创建ChannelInfo类继承自NSObject
    
 1.属性赋值
 2.设置当前频道
 3.通过数组来存放频道列表，实现频道列表的实时更新
 
 
 */

static ChannelInfo *currentChannel;/**<当前的频道*/
static NSArray *channelsTitleArray;/**<频道列表数组*/

@implementation ChannelInfo
//初始化赋值，通过字典的键值对，对属性赋值
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.ID = [dictionary objectForKey:@"id"];
        self.name = [dictionary objectForKey:@"name"];
    }
    return self;
}

+ (NSMutableArray *)channels
{
    //利用多线程，创建一个单例模式，用来上传频道数组
    static NSMutableArray *channels;//
    static dispatch_once_t onceToken;//只执行一次的任务
    dispatch_once(&onceToken, ^{
        channels = [NSMutableArray array];
    });
    return channels;
}
//保证在当前频道
+ (instancetype)currentChannel
{
    if (!currentChannel)
    {
        currentChannel = [[self alloc] init];
    }
    return currentChannel;
}
//更新当前的频道
+ (void)updateCurrentCannel:(ChannelInfo *)channel
{
    currentChannel = channel;
}
//用数组存放频道的标题列表
+ (NSArray *)channelsTitleArray
{
    if (!channelsTitleArray) {
        channelsTitleArray = [NSArray array];
    }
    return channelsTitleArray;
}
//更新频道库（数组）
+ (void)updateChannelsTitleArray:(NSArray *)array{
    channelsTitleArray = array;
}
//key值的替换
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

@end
