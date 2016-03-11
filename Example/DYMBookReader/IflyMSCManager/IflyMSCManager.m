//
//  IflyMSCManager.m
//  DYMBookReader
//
//  Created by LHL on 16/3/9.
//  Copyright © 2016年 Daniel Dong. All rights reserved.
//

#import "IflyMSCManager.h"
#import "iflyMSC/iflyMSC.h"
#import "PcmPlayer.h"
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "TTSConfig.h"


typedef NS_OPTIONS(NSInteger, SynthesizeType) {
    NomalType           = 5,//普通合成
    UriType             = 6, //uri合成
};


typedef NS_OPTIONS(NSInteger, Status) {
    NotStart            = 0,
    Playing             = 2, //高异常分析需要的级别
    Paused              = 4,
};

@interface IflyMSCManager()<IFlySpeechSynthesizerDelegate>

@property (nonatomic, strong) IFlySpeechSynthesizer * iFlySpeechSynthesizer;


@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, assign) BOOL hasError;
@property (nonatomic, assign) BOOL isViewDidDisappear;


@property (nonatomic, strong) NSString *uriPath;
@property (nonatomic, strong) PcmPlayer *audioPlayer;

@property (nonatomic, assign) Status state;
@property (nonatomic, assign) SynthesizeType synType;


@end

@implementation IflyMSCManager

static dispatch_once_t onceToken;
static id manager = nil;
+ (id)shareInstanced{
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[IflyMSCManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init{
    if(self = [super init]){
    
        
#pragma mark - 初始化uri合成的音频存放路径和播放器
        
        //     使用-(void)synthesize:(NSString *)text toUri:(NSString*)uri接口时， uri 需设置为保存音频的完整路径
        //     若uri设为nil,则默认的音频保存在library/cache下
        NSString *prePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //uri合成路径设置
        _uriPath = [NSString stringWithFormat:@"%@/%@",prePath,@"uri.pcm"];
        //pcm播放器初始化
        _audioPlayer = [[PcmPlayer alloc] init];

    }
    return self;
}

- (void)destroyIFly{
    self.isViewDidDisappear = true;
    [_iFlySpeechSynthesizer stopSpeaking];
    [IFlySpeechSynthesizer destroy];
    [_audioPlayer stop];
    _iFlySpeechSynthesizer.delegate = nil;
}

/**
 开始通用合成
 ****/
- (void)startSpeaker:(NSString *)text {
    
    if (!text || [text isEqualToString:@""]) {
        NSLog(@"无效的文本信息");
        return;
    }
    
    if (_audioPlayer != nil && _audioPlayer.isPlaying == YES) {
        [_audioPlayer stop];
    }
    
    _synType = NomalType;
    
    self.hasError = NO;
    [NSThread sleepForTimeInterval:0.05];
    
    
    self.isCanceled = NO;
    
    _iFlySpeechSynthesizer.delegate = self;
    [_iFlySpeechSynthesizer startSpeaking:text];
    if (_iFlySpeechSynthesizer.isSpeaking) {
        _state = Playing;
    }
}

#pragma mark - 合成回调 IFlySpeechSynthesizerDelegate

/**
 开始播放回调
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakBegin
{
    self.isCanceled = NO;
    if (_state  != Playing) {
        NSLog(@"开始播放");
    }
    
    _state = Playing;
}



/**
 缓冲进度回调
 
 progress 缓冲进度
 msg 附加信息
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onBufferProgress:(int) progress message:(NSString *)msg
{
    NSLog(@"buffer progress %2d%%. msg: %@.", progress, msg);
}




/**
 播放进度回调
 
 progress 缓冲进度
 
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakProgress:(int) progress
{
    NSLog(@"speak progress %2d%%.", progress);
}


/**
 合成暂停回调
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakPaused
{
    NSLog(@"播放暂停");
    
    _state = Paused;
}



/**
 恢复合成回调
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakResumed
{
    
    NSLog(@"播放继续");
    _state = Playing;
}

/**
 合成结束（完成）回调
 
 对uri合成添加播放的功能
 ****/
- (void)onCompleted:(IFlySpeechError *) error
{
    
    if (error.errorCode != 0) {
        NSLog(@"%@",[NSString stringWithFormat:@"错误码:%d",error.errorCode]);
        return;
    }
    NSString *text ;
    if (self.isCanceled) {
        text = @"合成已取消";
    }else if (error.errorCode == 0) {
        text = @"合成结束";
    }else {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        self.hasError = YES;
        NSLog(@"%@",text);
    }
    
    _state = NotStart;
    
    if (_synType == UriType) {//Uri合成类型
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:_uriPath]) {
            [self playUriAudio];//播放合成的音频
        }
    }
}




/**
 取消合成回调
 ****/
- (void)onSpeakCancel
{
    if (_isViewDidDisappear) {
        return;
    }
    self.isCanceled = YES;
    
    if (_synType == UriType) {
        
    }else if (_synType == NomalType) {
        NSLog(@"正在取消...");
    }
}


#pragma mark - 设置合成参数
- (void)setIFlySynthesizer
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    if (instance == nil) {
        return;
    }
    
    //合成服务单例
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    //设置语速1-100
    [_iFlySpeechSynthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
    
    //设置音量1-100
    [_iFlySpeechSynthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    
    //设置音调1-100
    [_iFlySpeechSynthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    
    //设置采样率
    [_iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    
    //设置发音人
    [_iFlySpeechSynthesizer setParameter:instance.vcnName forKey:[IFlySpeechConstant VOICE_NAME]];
    
}

#pragma mark - 播放uri合成音频

- (void)playUriAudio
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    NSLog(@"uri合成完毕，即将开始播放");
    NSError *error = [[NSError alloc] init];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    _audioPlayer = [[PcmPlayer alloc] initWithFilePath:_uriPath sampleRate:[instance.sampleRate integerValue]];
    [_audioPlayer play];
    
}


@end
