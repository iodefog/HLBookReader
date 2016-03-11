//
//  DYMBookPagesCache.m
//  Pods
//
//  Created by Dong Yiming on 15/10/6.
//
//

#import "DYMBookPagesCache.h"


static const NSInteger  MIN_POOL_SIZE = 100;

@interface DYMBookPagesCache () {
    NSMutableArray      *_pages;
}
@property(nonatomic, assign) NSInteger      poolSize;

@end


@implementation DYMBookPagesCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _poolSize = MIN_POOL_SIZE;
        [self doInit];
    }
    return self;
}

-(instancetype)initWithSize:(NSInteger)poolSize {
    self = [super init];
    if (self) {
        _poolSize = MIN(poolSize, MIN_POOL_SIZE);
        [self doInit];
    }
    return self;
}

-(void)doInit {
    
    _pages = [NSMutableArray arrayWithCapacity:_poolSize];
}

-(DYMBookPageVC *)dequeuePageForContainer:(NSTextContainer *)textContainer contentSize:(CGSize)contentSize pageEdgeInset:(UIEdgeInsets)pageEdgeInset {
    
    DYMBookPageVC *resultVC;
    
    for (DYMBookPageVC *vc in _pages) {
        if (vc.textContainer == textContainer) {
            resultVC = vc;
            break;
        }
    }
    
    if (resultVC == nil) {
        resultVC = [DYMBookPageVC new];
        [resultVC setTextContainer:textContainer contentSize:contentSize pageEdgeInset:pageEdgeInset];
    }
    
    [_pages removeObject:resultVC];
    [_pages addObject:resultVC];
    
    return resultVC;
}

@end
