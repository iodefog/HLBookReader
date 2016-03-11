//
//  DYMBookPageDatasource.m
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import "DYMBookChapter.h"
#import "DYMBookPagesCache.h"
#import "DYMBookUtility.h"

@interface DYMBookChapter () {
    
    NSTextStorage           *_storage;
    
    NSLayoutManager         *_layoutManager;
    
    DYMBookPagesCache       *_pagesCache;
}

@end



@implementation DYMBookChapter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pagesCache = [DYMBookPagesCache new];
    }
    return self;
}

-(void)refresh:(dispatch_block_t)block {
    
    if (_status == kDYMBookChapterRefreshing) {
        if (block) {
            block();
        }
        return;
    }
    _status = kDYMBookChapterRefreshing;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_content];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    if (_pageStyle.font) {
        [attributes setObject:_pageStyle.font forKey:NSFontAttributeName];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:_pageStyle.font.lineHeight * 0.7];
        [attributes setObject:style forKey:NSParagraphStyleAttributeName];
    }
    
    if (_pageStyle.textColor) {
        [attributes setObject:_pageStyle.textColor forKey:NSForegroundColorAttributeName];
    }
    
    
    [attributes setObject:@(1.2) forKey:NSKernAttributeName];
    
    if (attributes.allKeys.count > 0) {
        [attrStr setAttributes:attributes range:NSMakeRange(0, _content.length)];
    }
    
    _storage = [[NSTextStorage alloc] initWithAttributedString:attrStr];
    _layoutManager = [[NSLayoutManager alloc] init];
    [_storage addLayoutManager:_layoutManager];
    
    
    //
    [DYMBookUtility doAsync:^{
        
        NSRange range = NSMakeRange(0, 0);
        NSUInteger  containerIndex = 0;
        
        NSLog(@"begin add textContainers...");
        while (NSMaxRange(range) < _layoutManager.numberOfGlyphs) {
            
            CGSize shorterSize = CGSizeMake(_pageStyle.contentSize.width, _pageStyle.contentSize.height - _pageStyle.font.lineHeight);
            NSTextContainer *container = [[NSTextContainer alloc] initWithSize:shorterSize];
            [_layoutManager addTextContainer:container];
            
            range = [_layoutManager glyphRangeForTextContainer:container];
            containerIndex++;
        }
        NSLog(@"end add textContainers...");
        
    } completion:^{
        
        _status = kDYMBookChapterReady;
        
        if (block) {
            block();
        }
    }];
}

-(DYMBookPageVC *)firstPage {
    
    return [self pageAtIndex:0];
}

-(DYMBookPageVC *)pageAtIndex:(NSInteger)index {
    
    if (index >= 0 && index < _layoutManager.textContainers.count) {
        
        NSTextContainer *container = _layoutManager.textContainers[index];
        DYMBookPageVC *vc = [_pagesCache dequeuePageForContainer:container contentSize:_pageStyle.contentSize pageEdgeInset:_pageStyle.pageEdgeInset];
        
        vc.chapter = self;
        [vc setBookName:_bookName chapterTitle:_chapterTitle
           currentIndex:index totoalPageCount:_layoutManager.textContainers.count
                   font:_pageStyle.subFont textColor:_pageStyle.textColor];
        
        vc.view.backgroundColor = _pageStyle.backgroundColor;
//        vc.view.backgroundColor = [UIColor blackColor]; // for debug
        
        return vc;
    }
    
    return nil;
}

-(NSInteger)indexOfPageVC:(DYMBookPageVC *)pageVC {
//    NSLog(@"textContainers:%@", _layoutManager.textContainers);
    return [_layoutManager.textContainers indexOfObject:pageVC.textContainer];
}

-(void)didShowPageVC:(DYMBookPageVC *)pageVC {
    NSUInteger index = [self indexOfPageVC:pageVC];
//    NSLog(@"go to index:%ld, page-currentIndex:%ld", index, pageVC.currentIndex);
    [self goToIndex:index];
}

-(DYMBookPageVC *)goToFirstPage {
    return [self goToIndex:0];
}

-(DYMBookPageVC *)goToLastPage {
    return [self goToIndex:_layoutManager.textContainers.count - 1];
}

-(DYMBookPageVC *)goToIndex:(NSUInteger)index {
    
    if (index < _layoutManager.textContainers.count) {
        _currentPageIndex = index;
        
        return [self pageAtIndex:index];
    }
    
    return nil;
}

@end
