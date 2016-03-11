//
//  DYMBookTimer.m
//  Pods
//
//  Created by Dong Yiming on 15/10/7.
//
//

#import "DYMBookTimer.h"

@interface DYMBookTimer () {
    NSTimer             *_timer;
    
    NSDateComponents    *_dateComponents;
}

@end

@implementation DYMBookTimer


-(void)start {
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)stop {
    [_timer invalidate];
    _timer = nil;
}

-(void)tick:(id)sender {
    
    NSDateComponents *comp = [[self class] dateComponentsForNow];
    
    if (_dateComponents == nil || comp.hour != _dateComponents.hour || comp.minute != _dateComponents.minute) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DYM_NOTIFICATION_MINUTE_CHANGED object:comp];
    }
    
    _dateComponents = comp;
}

+(NSDateComponents *)dateComponentsForNow {
    
    NSDate *date = [NSDate date];
    
    return [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
}

@end
