//
//  DYMBookTimer.h
//  Pods
//
//  Created by Dong Yiming on 15/10/7.
//
//

#import <Foundation/Foundation.h>

static NSString *DYM_NOTIFICATION_MINUTE_CHANGED = @"DYM_NOTIFICATION_MINUTE_CHANGED";

@interface DYMBookTimer : NSObject

-(void)start;
-(void)stop;

+(NSDateComponents *)dateComponentsForNow;

@end
