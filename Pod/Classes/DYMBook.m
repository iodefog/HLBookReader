//
//  DYMBook.m
//  Pods
//
//  Created by Dong Yiming on 15/10/6.
//
//

#import "DYMBook.h"
#import "DYMBookUtility.h"

@interface DYMBook () {
    NSString        *_plistFileName;
}

@end

@implementation DYMBook


-(instancetype)initWithPlistFileName:(NSString *)plistFileName {
    self = [super init];
    if (self) {
        _plistFileName = plistFileName;
    }
    return self;
}

-(void)load:(dispatch_block_t)completionBlock {
    
    [DYMBookUtility doAsync:^{
        
        if (_plistFileName.length > 0) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:_plistFileName ofType:@"plist"];
            _data = [NSDictionary dictionaryWithContentsOfFile:filePath];
        }
        
    } completion:completionBlock];
}

-(NSArray *)chapters {
    return ((NSArray *)_data[@"chapterArrArr"]).firstObject;
}

-(NSString *)chapterContentAtIndex:(NSInteger)index {
    return [self chapterAtIndex:index][@"chapterContent"];
}

-(NSString *)chapterTitleAtIndex:(NSInteger)index {
    return [self chapterAtIndex:index][@"chapterTitle"];
}

-(id)chapterAtIndex:(NSUInteger)index {
    NSArray *chapters = [self chapters];
    if (index < chapters.count) {
        return chapters[index];
    }
    
    return nil;
}

@end
