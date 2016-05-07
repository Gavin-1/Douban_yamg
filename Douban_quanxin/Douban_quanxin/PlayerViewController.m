//
//  PlayerViewController.m
//  Douban_quanxin
//
//  Created by lk on 16/5/6.
//  Copyright © 2016年 唐家文. All rights reserved.
//frfr

#import <QuartzCore/QuartzCore.h>


#import <AFNetworking/UIKit+AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
//#import <UIKit+AFNetworking.h>
//#import <UIImageView+WebCache.h>


#import <Masonry/Masonry.h>

#import <AFNetworking/AFNetworking.h>
#import <MediaPlayer/MediaPlayer.h>

#import "PlayerViewController.h"
#import "PlayerController.h"
#import "ChannelInfo.h"

#import "NetworkManager.h"
#import "ChannelsTableViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SongInfo.h"
#import "PlayerController.h"
#import "ProtocolClass.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGB(r,g,b) RGBA(r,g,b,1)

#define kGoldColor RGB(219, 196, 175)

@interface PlayerViewController ()<DoubanDelegate>
{
    BOOL isPlaying;
    NSTimer *timer;
    NSMutableString *totalTimeString;
}

@property (strong, nonatomic) UILabel *channelTitleLabel;/**<频道名称标签*/

@property (strong, nonatomic) UIImageView *albumCoverImage;/**<专辑封面图片*/
@property (strong, nonatomic) UIImageView *albumCoverMaskImage;/**<专辑相册封面图片*/

@property (strong, nonatomic) UIProgressView *timerProgressBar;/**<定时器的进度条*/
@property (strong, nonatomic) UILabel *timeLabel;/**<定时器标签*/

@property (strong, nonatomic) UILabel *songTitleLabel;/**<歌曲名称*/
@property (strong, nonatomic) UILabel *songArtistLabel;/**<歌手名*/

@property (strong, nonatomic) UIButton *pauseButton;/**<暂停按钮*/
@property (strong, nonatomic) UIButton *likeButton;/**<喜欢按钮*/
@property (strong, nonatomic) UIButton *deleteButton;/**<删除按钮*/
@property (strong, nonatomic) UIButton *skipButton;/**<跳过按钮*/

@end

@implementation PlayerViewController

#pragma mark - View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //用宏定义定义的颜色
    self.view.backgroundColor = RGB(239, 239, 244);
    
    [self p_addSubViews];
    [self p_configConstrains];
    [self p_loadPlaylist];
    [PlayerController sharedInstance].songInfoDelegate = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                             target:self
                                           selector:@selector(updateProgress)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.albumCoverImage.layer.cornerRadius = self.albumCoverImage.bounds.size.width/2.0;
    self.albumCoverImage.layer.masksToBounds = YES;
    [super viewDidAppear:animated];
    [self initSongInfomation];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Buttons
- (void)pauseButtonDidTapped:(UIButton *)sender {
    if (isPlaying) {
        isPlaying = NO;
        self.albumCoverImage.alpha = 0.2f;
        self.albumCoverMaskImage.image = [UIImage imageNamed:@"albumBlock2"];
        [[PlayerController sharedInstance] pauseSong];
        [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [timer setFireDate:[NSDate distantFuture]];
    }
    else{
        isPlaying = YES;
        self.albumCoverImage.alpha = 1.0f;
        self.albumCoverMaskImage.image = [UIImage imageNamed:@"albumBlock"];
        [[PlayerController sharedInstance] restartSong];
        [timer setFireDate:[NSDate date]];
        [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

- (void)skipButtonDidTapped:(UIButton *)sender{
    [timer setFireDate:[NSDate distantFuture]];
    [[PlayerController sharedInstance] pauseSong];
    if(isPlaying == NO){
        self.albumCoverImage.alpha = 1.0f;
        self.albumCoverMaskImage.image = [UIImage imageNamed:@"albumBlock"];
    }
    [[PlayerController sharedInstance] skipSong];
}

- (void)likeButtonDidTapped:(UIButton *)sender {
    if (![[SongInfo currentSong].like intValue]) {
        [SongInfo currentSong].like = @"1";
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
        [[PlayerController sharedInstance] likeSong];
    }
    else{
        [SongInfo currentSong].like = @"0";
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
}

- (void)deleteButtonDidTapped:(UIButton *)sender {
    if (isPlaying == NO) {
        isPlaying = YES;
        self.albumCoverImage.alpha = 1.0f;
        self.albumCoverMaskImage.image = [UIImage imageNamed:@"albumBlock"];
        [[PlayerController sharedInstance] restartSong];
        [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    [[PlayerController sharedInstance] deleteSong];
}

#pragma mark - SongInfomation
-(void)p_loadPlaylist{
    [[NetworkManager sharedInstancd] loadPlaylistwithType:@"n"];
}

-(void)initSongInfomation{
    isPlaying = YES;
    if (![self isFirstResponder]) {
        //远程控制
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
    }
    //重置旋转图片角度
    __weak __typeof(self) weakSelf = self;
    self.albumCoverImage.image = nil;
    [self.albumCoverImage sd_setImageWithURL:[NSURL URLWithString:[SongInfo currentSong].picture]
                            placeholderImage:nil
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       __strong __typeof(weakSelf) strongSelf = weakSelf;
                                       strongSelf.albumCoverImage.transform = CGAffineTransformMakeRotation(0.0);
                                   }];
    
    self.songArtistLabel.text = [SongInfo currentSong].artist;
    self.songTitleLabel.text = [SongInfo currentSong].title;
    self.channelTitleLabel.text = [NSString stringWithFormat:@"♪%@♪",[ChannelInfo currentChannel].name];
    
    //初始化timeLabel的总时间
    int TotalTimeSeconds = [[SongInfo currentSong].length intValue]%60;
    int TotalTimeMinutes = [[SongInfo currentSong].length intValue]/60;
    if (TotalTimeSeconds < 10) {
        totalTimeString = [NSMutableString stringWithFormat:@"%d:0%d",TotalTimeMinutes,TotalTimeSeconds];
    }
    else{
        totalTimeString = [NSMutableString stringWithFormat:@"%d:%d",TotalTimeMinutes,TotalTimeSeconds];
    }
    
    //初始化likeButon的图像
    if (![[SongInfo currentSong].like intValue]) {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
    else{
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
    }
    [timer setFireDate:[NSDate date]];
    [self configPlayingInfo];
}
//就是一个方法，里面说明了关于当前歌曲名的配置，和专辑封面图片的配置
- (void)configPlayingInfo
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        if ([SongInfo currentSong].title != nil) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[SongInfo currentSong].title
                     forKey:MPMediaItemPropertyTitle];
            [dict setObject:[SongInfo currentSong].artist
                     forKey:MPMediaItemPropertyArtist];
            UIImage *tempImage = _albumCoverImage.image;
            if (tempImage != nil) {
                [dict setObject:[[MPMediaItemArtwork alloc]initWithImage:tempImage] forKey:MPMediaItemPropertyArtwork];
            }
            [dict
             setObject:[NSNumber numberWithFloat:[[SongInfo currentSong].length floatValue]]
             forKey:MPMediaItemPropertyPlaybackDuration];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }
    }
}
//把子view加到self.view上
//这是个亮点，用数组加代码块添加view
- (void)p_addSubViews
{
    NSArray *subView = @[self.channelTitleLabel,
                         self.albumCoverImage,
                         self.albumCoverMaskImage,
                         self.timerProgressBar,
                         self.timeLabel,
                         self.songTitleLabel,
                         self.songArtistLabel,
                         self.pauseButton,
                         self.likeButton,
                         self.deleteButton,
                         self.skipButton];
    [subView enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [self.view addSubview:view];
    }];
}

//当前频道名以及对各种子view的约束
- (void)p_configConstrains
{
    UIView *superView = self.view;
    [self.channelTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(15);
        make.right.equalTo(superView).offset(-15);
        make.height.mas_equalTo(@40);
    }];
    //当前频道，专辑封面图片,定时器进度条的枚举对象使用块（相关约束）（具体的约束还要细看）
    //__block破坏了代码块的封装性，可以在外面进行修改。
    UIView __block *lastView = nil;
    [@[self.channelTitleLabel,
       self.albumCoverImage,
       self.timerProgressBar,] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
           [view mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(lastView ? lastView.mas_bottom : superView.mas_top).offset(30);
           }];
           lastView = view;
       }];
    
    lastView = nil;
    //暂停，喜欢，删除，跳过按钮的枚举对象使用块的相关约束.(具体的约束还要细看）
    [@[self.pauseButton,
       self.likeButton,
       self.deleteButton,
       self.skipButton,] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
           [view mas_makeConstraints:^(MASConstraintMaker *make) {
               make.bottom.equalTo(superView.mas_bottom).offset(-15);
               make.height.equalTo(view.mas_width);
               make.left.equalTo(lastView ? lastView.mas_right : superView.mas_left).offset(30);
           }];
           lastView = view;
       }];
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.mas_right).offset(-30);
        make.size.equalTo(@[self.pauseButton, self.likeButton, self.deleteButton]);
    }];
    
    lastView = nil;
    [@[self.songArtistLabel,self.songTitleLabel, self.timeLabel, self.timerProgressBar] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView).offset(15);
            make.right.equalTo(superView).offset(-15);
            make.bottom.equalTo(lastView ? lastView.mas_top : self.pauseButton.mas_top).offset(-15);
        }];
        lastView = view;
    }];
    
    [self.songArtistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@[self.songTitleLabel, self.timeLabel]);
    }];
    
    [self.albumCoverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.left.equalTo(superView).offset(20);
        make.right.equalTo(superView).offset(-20);
        make.width.equalTo(self.albumCoverImage.mas_height);
    }];
    
    [self.albumCoverMaskImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.left.top.equalTo(self.albumCoverImage);
    }];
}

#pragma mark - Getters
//当前频道名的设置
- (UILabel *)channelTitleLabel
{
    if (!_channelTitleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:27.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kGoldColor;
        _channelTitleLabel = label;
    }
    return _channelTitleLabel;
}
//专辑封面图片的设置
- (UIImageView *)albumCoverImage
{
    if (!_albumCoverImage) {
        UIImageView *imageView = [[UIImageView alloc]init];
        _albumCoverImage = imageView;
    }
    return _albumCoverImage;
}
//相册封面图片的相关设置
- (UIImageView *)albumCoverMaskImage
{
    if (!_albumCoverMaskImage) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"albumBlock"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseButtonDidTapped:)];
        [singleTap setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:singleTap];
        
        _albumCoverMaskImage = imageView;
    }
    return _albumCoverMaskImage;
}
//定时器的进度条的相关设置
- (UIProgressView *)timerProgressBar
{
    if (!_timerProgressBar) {
        _timerProgressBar = [UIProgressView new];
        //颜色
        _timerProgressBar.progressTintColor = kGoldColor;
    }
    return _timerProgressBar;
}
//定时器名
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kGoldColor;
        _timeLabel = label;
    }
    return _timeLabel;
}
//歌曲名
- (UILabel *)songTitleLabel
{
    if (!_songTitleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:22.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kGoldColor;
        _songTitleLabel = label;
    }
    return _songTitleLabel;
}
//歌手名
- (UILabel *)songArtistLabel
{
    if (!_songArtistLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kGoldColor;
        _songArtistLabel = label;
    }
    return _songArtistLabel;
}
//暂停
- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = ({
            UIButton *button = [[UIButton alloc]init];
            [button addTarget:self action:@selector(pauseButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            button;
        });
    }
    return _pauseButton;
}
//喜欢
- (UIButton *)likeButton
{
    if (!_likeButton) {
        _likeButton = ({
            UIButton *button = [[UIButton alloc]init];
            [button addTarget:self action:@selector(likeButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
            button;
        });
    }
    return _likeButton;
}
//删除
- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = ({
            UIButton *button = [[UIButton alloc]init];
            [button addTarget:self action:@selector(deleteButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
            button;
        });
    }
    return _deleteButton;
}
//跳过
- (UIButton *)skipButton
{
    if (!_skipButton) {
        _skipButton = ({
            UIButton *button = [[UIButton alloc]init];
            [button addTarget:self action:@selector(skipButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
            button;
        });
    }
    return _skipButton;
}

#pragma mark - RemoteControl
//远程控制接收到的事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlPlay:
                [self pauseButtonDidTapped:nil]; // 切换播放、暂停按钮
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self skipButtonDidTapped:nil]; // 播放下一曲按钮
                break;
            default:
                break;
        }
    }
}
//更新进度条时进行的操作
-(void)updateProgress{
    int currentTimeMinutes = (unsigned)[PlayerController sharedInstance].currentPlaybackTime/60;
    int currentTimeSeconds = (unsigned)[PlayerController sharedInstance].currentPlaybackTime%60;
    NSMutableString *currentTimeString;
    //专辑图片旋转
    self.albumCoverImage.transform = CGAffineTransformRotate(self.albumCoverImage.transform, M_PI / 1440);
    if (currentTimeSeconds < 10) {
        currentTimeString = [NSMutableString stringWithFormat:@"%d:0%d",currentTimeMinutes,currentTimeSeconds];
    }
    else{
        currentTimeString = [NSMutableString stringWithFormat:@"%d:%d",currentTimeMinutes,currentTimeSeconds];
    }
    
    NSMutableString *timeLabelString = [NSMutableString stringWithFormat:@"%@/%@",currentTimeString,totalTimeString];
    self.timeLabel.text = timeLabelString;
    self.timerProgressBar.progress = [PlayerController sharedInstance].currentPlaybackTime/[[SongInfo currentSong].length intValue];
}
@end

