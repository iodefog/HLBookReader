//
//  DYMBookDataSource.m
//  Pods
//
//  Created by Dong Yiming on 15/10/7.
//
//

#import "DYMBookDataSource.h"
#import "DYMBook.h"
#import "DYMBookProvider.h"
#import "DYMBookChapter.h"

@interface DYMBookDataSource () {
    DYMBook             *_book;
    NSMutableArray      *_chapters;
    
    NSInteger          _currentChapterIndex;
}

@end

@implementation DYMBookDataSource

-(instancetype)initWithPlistFileName:(NSString *)plistFileName pageStyle:(DYMBookPageStyle *)pageStyle {
    
    self = [super init];
    if (self) {
        _plistFileName = plistFileName;
        _pageStyle = pageStyle;
        _chapters = [NSMutableArray array];
    }
    return self;
}

-(void)load:(dispatch_block_t)completionBlock {
    
    _book = [DYMBookProvider bookWithPlistFileName:_plistFileName];
    
    [_chapters removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    [_book load:^{
        
        __strong typeof(self) strongSelf = weakSelf;
        NSArray *chapters = strongSelf->_book.chapters;
        for (id chapterDic in chapters) {
            DYMBookChapter *chapterObject = [DYMBookChapter new];
            chapterObject.content = chapterDic[@"chapterContent"];
            chapterObject.bookName = _book.data[@"title"];
            chapterObject.chapterTitle = chapterDic[@"chapterTitle"];
            chapterObject.pageStyle = _pageStyle;

            [strongSelf->_chapters addObject:chapterObject];
        }
        
        // Preload
        [strongSelf loadChapterAtIndex:_currentChapterIndex completion:^{
            
            if (completionBlock) {
                completionBlock();
            }
            
            [strongSelf loadChapterAtIndex:_currentChapterIndex + 1 completion:nil];
            [strongSelf loadChapterAtIndex:_currentChapterIndex - 1 completion:nil];
        }];
        
        
    }];
}

-(void)loadChapterAtIndex:(NSUInteger)index completion:(dispatch_block_t)completionBlock {
    
    BOOL needRefresh = NO;
    
    if (index < _chapters.count) {
        DYMBookChapter *chapter = _chapters[index];
        if (chapter.status != kDYMBookChapterReady) {
            needRefresh = YES;
            [chapter refresh:completionBlock];
            return;
        }
    }
    
    if (!needRefresh && completionBlock) {
        completionBlock();
    }
}

-(void)setCurrentChapter:(DYMBookChapter *)currentChapter {
    NSUInteger index = [_chapters indexOfObject:currentChapter];
    if (index != NSNotFound) {
        _currentChapterIndex = index;
    }
}

-(DYMBookChapter *)currentChapter {
    return [self chapterAtIndex:_currentChapterIndex];
}

-(DYMBookChapter *)chapterAtIndex:(NSInteger)index {
    
    if (_chapters.count > 0) {
        index = MAX(0, index);
        index = MIN(_chapters.count - 1, index);
        
        DYMBookChapter *chapter = _chapters[index];
        
        return chapter;
    }
    
    return nil;
}

-(DYMBookPageVC *)getPage:(BOOL)forward {
    DYMBookChapter *currentChapter = [self currentChapter];
    NSInteger index = forward ? currentChapter.currentPageIndex + 1 : currentChapter.currentPageIndex - 1;
    DYMBookPageVC *vc = [currentChapter pageAtIndex:index];
    
    if (vc == nil) {
        vc = [self navigate:forward completion:nil];
    }
    
    return vc;
}

-(DYMBookPageVC *)navigate:(BOOL)forward completion:(dispatch_block_t)completion {
    
    NSInteger index = forward ? _currentChapterIndex + 1 : _currentChapterIndex - 1;
    
    NSInteger lastIndex = _chapters.count - 1;
    if (index > lastIndex) {
        return nil;
    } else if (index < 0) {
        return nil;
    }
    
    DYMBookPageVC *pageVC;
    
    if (forward) {
        pageVC = [[self chapterAtIndex:index] goToFirstPage];
    } else {
        pageVC = [[self chapterAtIndex:index] goToLastPage];
    }
    
    [self preloadChaptersAtIndex:index completion:completion];
    
    return pageVC;
}

-(void)preloadChaptersAtIndex:(NSUInteger)index completion:(dispatch_block_t)completion {
    [self loadChapterAtIndex:index completion:^{
        
        if (completion) {
            completion();
        }
        
        [self loadChapterAtIndex:index + 1 completion:nil];
        [self loadChapterAtIndex:index - 1 completion:nil];
    }];

}

@end
