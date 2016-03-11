//
//  DYMAppDelegate+IFly.m
//  DYMBookReader
//
//  Created by LHL on 16/3/9.
//  Copyright © 2016年 Daniel Dong. All rights reserved.
//

#import "DYMAppDelegate+IFly.h"
#import "IflyMSCManager.h"
@implementation DYMAppDelegate (IFly)

- (void)speakerDelay:(NSString *)text{
    NSLog(@"IFLY + Text \n%@", text);
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(speakerNow:) object:text];
    [self performSelector:@selector(speakerNow:) withObject:text afterDelay:0.3];
    
 
}

- (void)speakerNow:(NSString *)text{
    [[IflyMSCManager shareInstanced] destroyIFly];
    [[IflyMSCManager shareInstanced] setIFlySynthesizer];
    [[IflyMSCManager shareInstanced] startSpeaker:text];
}

@end
