//
//  NetworkManager.m
//  Douban
//
//  Created by lk on 16/5/4.
//  Copyright © 2016年 唐家文. All rights reserved.
//

#import "NetworkManager.h"
#import "AppDelegate.h"
#import "SongInfo.h"
#import "ChannelInfo.h"

#import "PlayerController.h"

#import "DFMUpChannelsEntity.h"
#import "DFMHotChannelsEntity.h"
#import "DFMRecChannelsEntity.h"

#import <UIKit/UIKit.h>

#import <MJExtension.h>
#import <AFNetworking/AFNetworking.h>

#define PLAYLISTURLFORMATSTRING @"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite"
#define LOGINURLSTRING @"http://douban.fm/j/login"
#define LOGOUTURLSTRING @"http://douban.fm/partner/logout"
#define CAPTCHAIDURLSTRING @"http://douban.fm/j/new_captcha"
#define CAPTCHAIMGURLFORMATSTRING @"http://douban.fm/misc/captcha?size=m&id=%@"

#import "UserInfo.h"
static NSMutableString *captchaID;//可变的字符串用来存放验证码；

@interface NetworkManager(){
    AppDelegate *appDelegate;
    AFHTTPRequestOperationManager *manager;
}
@end

@implementation NetworkManager
/** 初始化方法，重写父类的初始化方法 */
-(instancetype)init{
    if (self = [super init]) {
        appDelegate = [[UIApplication sharedApplication] delegate];//获取app的代理对象
        
        manager = [AFHTTPRequestOperationManager manager];//获取网络请求的对象
    }
    return self;
}
/** 获取NetworkManager的单例 */
+ (instancetype)sharedInstancd
{
    static NetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{               //此方法在整个程序运行时，只被执行一次
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

//加载分类列表（推荐频道、上升最快兆赫、热门兆赫），对应右上角弹出的第二个按钮，
-(void)setChannel:(NSUInteger)channelIndex withURLWithString:(NSString *)urlWithString{
    
    [manager GET:urlWithString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {//向服务器发起网络请求
        NSDictionary *channelsDictionary = responseObject;//获取服务器返回的数据,responseObject里面包含了服务器返回的数据信息
        NSDictionary *tempChannel = [channelsDictionary objectForKey:@"data"];
        
        if (channelIndex == DFMChannelTypeUpTrending) {
            
            DFMUpChannelsEntity *entity = [DFMUpChannelsEntity objectWithKeyValues:tempChannel];//将字典转换成DFMUpChannelsEntity模型
            [ChannelInfo channels][channelIndex] = entity.channels;//给类ChannelInfo中的channels数组赋值
        }
        
        else if (channelIndex == DFMChannelTypeHot) {
            
            DFMHotChannelsEntity *entity = [DFMHotChannelsEntity objectWithKeyValues:tempChannel];//将字典转换成DFMHotChannelsEntity模型
            [ChannelInfo channels][channelIndex] = entity.channels;//给类ChannelInfo中的channels数组赋值
        }
        
        else{
            NSDictionary *channels = [tempChannel objectForKey:@"res"];//获取tempChannel中的res
            if ([[channels allKeys]containsObject:@"rec_chls"]) {//判断channels所有的keys是否包含rec_chls
                for (NSDictionary *tempRecCannels in [channels objectForKey:@"rec_chls"]) {//遍历数组
                    ChannelInfo *channelInfo = [ChannelInfo objectWithKeyValues:tempRecCannels];//将字典转换成ChannelInfo模型
                    [[[ChannelInfo channels] objectAtIndex:channelIndex] addObject:channelInfo];//添加channels数组元素
                }
            }
            else{
                NSDictionary *channels = [tempChannel objectForKey:@"res"];
                ChannelInfo *channelInfo = [ChannelInfo objectWithKeyValues:channels];
                [[[ChannelInfo channels] objectAtIndex:channelIndex] addObject:channelInfo];
            }
        }
        [self.delegate reloadTableviewData];//调用reloadTableviewData方法，重新加载页面
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}


//登陆数据格式
//POST Params:
//remember:on/off
//source:radio
//captcha_solution:cheese 验证码
//alias:xxxx%40gmail.com
//form_password:password
//captcha_id:jOtEZsPFiDVRR9ldW3ELsy57%3en
/** 登录验证 */
-(void)LoginwithUsername:(NSString *)username Password:(NSString *)password  Captcha:(NSString *)captcha RememberOnorOff:(NSString *)rememberOnorOff{
    
    //网络请求参数
    NSDictionary *loginParameters = @{@"remember": rememberOnorOff,
                                      @"source": @"radio",
                                      @"captcha_solution": captcha,
                                      @"alias": username,
                                      @"form_password":password,
                                      @"captcha_id":captchaID};
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置服务器返回数据的解析方式，JSON解析
    [manager POST:LOGINURLSTRING parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {//向服务器发起网络请求
        NSDictionary *tempLoginInfoDictionary = responseObject;
        //r=0 登陆成功
        if ([(NSNumber *)[tempLoginInfoDictionary valueForKey:@"r"] intValue] == 0) {
            UserInfo *userInfo = [[UserInfo alloc]initWithDictionary:tempLoginInfoDictionary];
            appDelegate.userInfo = userInfo;//给AppDelegate里的userInfo属性赋值
            [appDelegate.userInfo archiverUserInfo];//归档
            NSLog(@"COOKIES:%@",appDelegate.userInfo.cookies);
            [self.delegate loginSuccess];//调用DoubanDelegate的loginSuccess方法
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登陆失败" message:[tempLoginInfoDictionary valueForKey:@"err_msg"] delegate:self cancelButtonTitle:@"GET" otherButtonTitles: nil];
            [alertView show];
            [self loadCaptchaImage];//登录失败，重新加载验证码图片
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"LOGIN_ERROR:%@",error);
    }];
}


//source
//value radio
//ck
//the key ck in your cookie
//no_login
//value y #### Response none #### Example none
/** 退出登录 */
-(void)logout{
    
    NSDictionary *logoutParameters = @{@"source": @"radio",
                                       @"ck": appDelegate.userInfo.cookies,
                                       @"no_login": @"y"};
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//设置网络请求的格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置服务器返回数据的解析格式
    [manager GET:LOGOUTURLSTRING parameters:logoutParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"LOGOUT_SUCCESSFUL");
        appDelegate.userInfo = [[UserInfo alloc]init];
        [appDelegate.userInfo archiverUserInfo];//归档
        [self.delegate logoutSuccess];//调用DoubanDelegate的logoutSuccess方法
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"LOGOUT_ERROR:%@",error);
    }];
}

//获取播放列表信息
//type
//n : None. Used for get a song list only.
//e : Ended a song normally.
//u : Unlike a hearted song.
//r : Like a song.
//s : Skip a song.
//b : Trash a song.
//p : Use to get a song list when the song in playlist was all played.
//sid : the song's id
/** 获取音乐列表信息 */
-(void)loadPlaylistwithType:(NSString *)type{
    
    NSString *playlistURLString = [NSString stringWithFormat:PLAYLISTURLFORMATSTRING, type, [SongInfo currentSong].sid, [PlayerController sharedInstance].currentPlaybackTime, [ChannelInfo currentChannel].ID];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:playlistURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DFMPlaylist *playList = [PlayerController sharedInstance].playList;
        
        NSDictionary *songDictionary = responseObject;
        
        playList = [DFMPlaylist objectWithKeyValues:songDictionary];//将字典数据转换成DFMPlaylist模型
        
        if ([type isEqualToString:@"r"]) {
            [SongInfo setCurrentSongIndex:-1];
        }
        else{
            if ([playList.song count] != 0) {
                [SongInfo setCurrentSongIndex:0];
                [SongInfo setCurrentSong:[playList.song objectAtIndex:[SongInfo currentSongIndex]]];
                [[PlayerController sharedInstance] setContentURL:[NSURL URLWithString:[SongInfo currentSong].url]];
                [[PlayerController sharedInstance] play];
            }
            //如果是未登录用户第一次使用红心列表，会导致列表中无歌曲
            else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"HeyMan" message:@"红心列表中没有歌曲，请您先登陆，或者添加红心歌曲" delegate:self cancelButtonTitle:@"GET" otherButtonTitles: nil];
                [alertView show];
                ChannelInfo *myPrivateChannel = [[ChannelInfo alloc]init];
                myPrivateChannel.name = @"我的私人";
                myPrivateChannel.ID = @"0";
                [ChannelInfo updateCurrentCannel:myPrivateChannel];
            }
        }
        [self.delegate reloadTableviewData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //FIXME: 或许信息失败有点bug，先这样把 = =
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"HeyMan" message:@"登陆失败啦" delegate:self cancelButtonTitle:@"哦,酱紫" otherButtonTitles: nil];
        //        [alertView show];
        //        NSLog(@"LOADPLAYLIST_ERROR:%@",error);
    }];
}

/** 登录界面，加载验证码图片 */
-(void)loadCaptchaImage{
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:CAPTCHAIDURLSTRING parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *tempCaptchaID = [[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [tempCaptchaID replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempCaptchaID length])];
        captchaID = tempCaptchaID;
        NSString *captchaImgURL = [NSString stringWithFormat:CAPTCHAIMGURLFORMATSTRING,tempCaptchaID];
        //加载验证码图片
        [self.delegate setCaptchaImageWithURLInString:captchaImgURL];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end