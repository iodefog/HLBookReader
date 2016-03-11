//
//  DYMBookUtility.h
//  Pods
//
//  Created by Dong Yiming on 15/10/6.
//
//

#import <Foundation/Foundation.h>

@interface DYMBookUtility : NSObject

+(void)doAsync:(dispatch_block_t)block completion:(dispatch_block_t)completionBlock;

+(UIFont *)customFontWithFileName:(NSString *)fileName Size:(CGFloat)fontSize;

@end
