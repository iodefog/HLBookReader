//
//  DYMBookPageDatasource.h
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import <Foundation/Foundation.h>
#import "DYMBookPageVC.h"
#import "DYMBookPageStyle.h"

typedef NS_ENUM(NSInteger, EDYMBookChapterStatus) {
    kDYMBookChapterNotReady = 0
    , kDYMBookChapterRefreshing
    , kDYMBookChapterReady
};

@interface DYMBookChapter : NSObject

@property (nonatomic, copy) NSString    *bookName;

@property (nonatomic, copy) NSString    *chapterTitle;

@property (nonatomic, strong) NSString    *content;

@property (nonatomic, assign) NSUInteger   currentPageIndex;

@property (nonatomic, strong) DYMBookPageStyle    *pageStyle;

@property (nonatomic, assign, readonly) EDYMBookChapterStatus   status;

@property (nonatomic, strong) NSLayoutManager         *layoutManager;


-(void)refresh:(dispatch_block_t)block;

-(DYMBookPageVC *)firstPage;

-(DYMBookPageVC *)pageAtIndex:(NSInteger)index;

-(NSInteger)indexOfPageVC:(DYMBookPageVC *)pageVC;

-(void)didShowPageVC:(DYMBookPageVC *)pageVC;

-(DYMBookPageVC *)goToFirstPage;

-(DYMBookPageVC *)goToLastPage;

-(DYMBookPageVC *)goToIndex:(NSUInteger)index;

@end
