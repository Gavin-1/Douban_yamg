//
//  SongInfo.m
//  DouBanFM_mine
//
//  Created by lk1 on 16/5/3.
//  Copyright © 2016年 lk1. All rights reserved.
//

#import "SongInfo.h"

static SongInfo *currentSong;//当前的歌曲
static int currentSongIndex;//当前歌曲的下标

@implementation SongInfo

+ (instancetype)currentSong
{
    if (!currentSong)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            currentSong = [[SongInfo alloc] init];
        });
    }
    return currentSong;
}

+ (void)setCurrentSong:(SongInfo *)songInfo
{
    currentSong = songInfo;
}

+ (NSInteger)currentSongIndex
{
    return currentSongIndex;
}

+ (void)setCurrentSongIndex:(int)songIndex
{
    currentSongIndex = songIndex;
}


@end
