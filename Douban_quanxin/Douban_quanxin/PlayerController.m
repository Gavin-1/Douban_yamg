//
//  PlayerController.m
//  Douban
//
//  Created by lk on 16/5/4.
//  Copyright © 2016年 唐家文. All rights reserved.
//

#import "PlayerController.h"
#import "SongInfo.h"
@interface PlayerController()
{
    //全局变量
    AppDelegate*appDelegate;
    // NetworkManager *networkManager;
}
@end
@implementation PlayerController

-(instancetype)init
{
    if (self=[super init])
    {
        //这个，我还真解释不好。谁加一下解释。
        appDelegate=[[UIApplication sharedApplication]delegate];
        //networkManager = [[NetworkManager alloc]init];
    }
    //发布当播放结束或用户退出播放。开始播放。
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startPlay) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    //当网络加载状态变化时，初始化歌曲。
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initSongInfomation) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    return self;
}

+ (instancetype)sharedInstance
{
    static PlayerController *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
//初始化歌曲，代理
-(void)initSongInfomation
{
    [self.songInfoDelegate initSongInfomation];
}

-(void)startPlay{
    @try {
        //判断语句，如果当前歌曲下标大于或等于FM列表歌曲的（下标-1）那就进行一下操作
        if ([SongInfo currentSongIndex] >= ((int)[[PlayerController sharedInstance].playList.song count]-1)) {
            //[networkManager loadPlaylistwithType:@"p"];
        }
        else{
            [SongInfo setCurrentSongIndex:[SongInfo currentSongIndex] + 1];
            [SongInfo setCurrentSong:[[PlayerController sharedInstance].playList.song objectAtIndex:[SongInfo currentSongIndex]]];
            
            [self setContentURL:[NSURL URLWithString:[[SongInfo currentSong] valueForKey:@"url"]]];
            //从当前队列中播放项目，如果可能的话，恢复暂停播放。
            [self play];
        }
    }
    //@try @catch @throw这三个IOS不经常用，想了解的自己查一下。
    @catch (NSException *exception) {
    }
}


#pragma mark - PlayerButtonTask
//点击下一曲事件，按照豆瓣算法，需要重新载入播放列表
-(void)pauseSong
{
    //暂停播放
    [self pause];
}
-(void)restartSong{
    [self play];
}
//需要导入NetworkManager.h，等人。
//-(void)likeSong{
//    [networkManager loadPlaylistwithType:@"r"];
//}
//-(void)dislikesong{
//    [networkManager loadPlaylistwithType:@"u"];
//}
//-(void)deleteSong{
//    [networkManager loadPlaylistwithType:@"b"];
//}
//-(void)skipSong{
//    [networkManager loadPlaylistwithType:@"s"];
//}


@end