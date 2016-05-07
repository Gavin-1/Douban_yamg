//
//  DFMHotChannelsEntity.m
//  Douban
//
//  Created by lk on 16/5/4.
//  Copyright © 2016年 唐家文. All rights reserved.
//

#import "DFMHotChannelsEntity.h"
#import "ChannelInfo.h"
@implementation DFMHotChannelsEntity
//类方法，返回一个键值对，一个ChannelInfo类型的类
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"channels" : NSStringFromClass([ChannelInfo class]),
             };
}
@end
