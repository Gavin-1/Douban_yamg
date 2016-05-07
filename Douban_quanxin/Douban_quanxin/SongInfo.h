//
//  SongInfo.h
//  DouBanFM_mine
//
//  Created by lk1 on 16/5/3.
//  Copyright © 2016年 lk1. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  豆瓣中存放歌曲的所有信息等等
 */
@interface SongInfo : NSObject

@property (nonatomic, assign) NSInteger index;//歌曲的下标

@property (nonatomic, copy) NSString *title;//歌名

@property (nonatomic, copy) NSString *artist;//歌手名

@property (nonatomic, copy) NSString *picture;//图片名

@property (nonatomic, copy) NSString *length;//歌的时间长度

@property (nonatomic, copy) NSString *like;//喜欢的歌曲（小红心）

@property (nonatomic, copy) NSString *url;//路径

@property (nonatomic, copy) NSString *sid;//歌曲的id号

+ (instancetype) currentSong;//当前歌曲

+ (void)setCurrentSong:(SongInfo *)songInfo;//获取当前歌曲

+ (NSInteger) currentSongIndex;//当前歌曲下标

+ (void)setCurrentSongIndex:(int)songIndex;//获取当前歌曲下标



@end
