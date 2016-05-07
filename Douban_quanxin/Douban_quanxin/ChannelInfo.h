//
//  ChannelInfo.h
//  Douban
//
//  Created by YANG on 16/5/3.
//  Copyright © 2016年 唐家文. All rights reserved.
//哈哈哈uu

#import <Foundation/Foundation.h>
//用枚举定义变量，可直接使用，不用初始化，简洁
typedef NS_ENUM(NSUInteger, DFMChannelType)
{
    DFMChannelTypeReccommend = 1,//频道列表  推荐、上升、热门
    DFMChannelTypeUpTrending,
    DFMChannelTypeHot,
};

@interface ChannelInfo : NSObject

@property (nonatomic, copy) NSString *ID;//频道的ID
@property (nonatomic, copy) NSString *name;//频道的name
//初始化赋值
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
//
+ (NSMutableArray *)channels;

+ (instancetype)currentChannel;//当前的频道
+ (void)updateCurrentCannel:(ChannelInfo *)channel;//更新当前频道

//用数组存放频道的标题列表
+ (NSArray *)channelsTitleArray;
+ (void)updateChannelsTitleArray:(NSArray *)array;//更新当前频道的title
@end