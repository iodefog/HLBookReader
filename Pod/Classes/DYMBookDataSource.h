//
//  DYMBookDataSource.h
//  Pods
//
//  Created by Dong Yiming on 15/10/7.
//
//

#import <Foundation/Foundation.h>
#import "DYMBookPageStyle.h"
#import "DYMBookChapter.h"

@interface DYMBookDataSource : NSObject

@property (nonatomic, strong, readonly) DYMBookPageStyle        *pageStyle;
@property (nonatomic, copy, readonly) NSString                  *plistFileName;

@property (nonatomic, strong)       DYMBookChapter              *currentChapter;

-(instancetype)initWithPlistFileName:(NSString *)plistFileName pageStyle:(DYMBookPageStyle *)pageStyle;

-(void)load:(dispatch_block_t)completionBlock;

-(DYMBookPageVC *)getPage:(BOOL)forward;

@end
