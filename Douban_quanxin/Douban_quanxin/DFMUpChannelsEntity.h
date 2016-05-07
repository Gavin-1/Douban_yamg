//
//  DFMUpChannelsEntity.h
//  Douban
//
//  Created by lk on 16/5/4.
//  Copyright © 2016年 唐家文. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 与ChannelInfo中的枚举变量相对应，本类获取的是频道中关于上升趋势频道的信息
 *
 */
@interface DFMUpChannelsEntity : NSObject
//声明一个属性可变数组
@property (nonatomic, copy) NSMutableArray *channels;
@end
