//
//  IflyMSCManager.h
//  DYMBookReader
//
//  Created by LHL on 16/3/9.
//  Copyright © 2016年 Daniel Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IflyMSCManager : NSObject

+ (id)shareInstanced;

- (void)destroyIFly;

- (void)startSpeaker:(NSString *)text;

- (void)setIFlySynthesizer;

#pragma mark - 播放uri合成音频
- (void)playUriAudio;



@end
