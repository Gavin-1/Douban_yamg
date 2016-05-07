//
//  DFMUpChannelsEntity.m
//  Douban
//
//  Created by lk on 16/5/4.
//  Copyright © 2016年 唐家文. All rights reserved.
//

#import "DFMUpChannelsEntity.h"
#import "ChannelInfo.h"

@implementation DFMUpChannelsEntity
//类方法，返回一个键值对，一个ChannelInfo类型的类
//不需要声明一个对象(实例)就可以直接调用的方法，通常是有返回值的。
//注意和@property@interface@implementation的联系和区分
+(NSDictionary*)objectClassInArray
{
    return @{@"channels":NSStringFromClass([ChannelInfo class]),};
}
@end 
