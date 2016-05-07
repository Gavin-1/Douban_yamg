//
//  DFMPlaylist.h
//  Douban
//
//  Created by lk on 16/5/4.
//  Copyright © 2016年 唐家文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFMPlaylist : NSObject
//可变数组song，应该是存放歌曲用的
//播放列表
@property (nonatomic, copy) NSMutableArray *song;
@end
