//
//  DYMAppDelegate.m
//  DYMBookReader
//
//  Created by Daniel Dong on 10/03/2015.
//  Copyright (c) 2015 Daniel Dong. All rights reserved.
//

#import "DYMAppDelegate.h"
#import "DYMBookReaderViewController.h"
#import "iflyMSC/IFlyMSC.h"

#define APPID_VALUE           @"53565bd9"

@implementation DYMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"txt"];
    
    DYMBookReaderViewController *vc = (DYMBookReaderViewController *)self.window.rootViewController;
    vc.plistFileName = @"花千骨";
    vc.customFontName = @"FlagBlack";
    vc.pageEdgeInset = UIEdgeInsetsMake(30, 20, 30, 10);
    
    [self instanceIflymsc];
    
    return YES;
}


- (void)instanceIflymsc{
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

@end
