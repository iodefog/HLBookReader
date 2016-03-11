//
//  DYMBookPageVC.m
//  Pods
//
//  Created by Dong Yiming on 15/10/6.
//
//

#import "DYMBookPageVC.h"
#import "DYMBookTimer.h"
#import <Masonry/Masonry.h>

@interface DYMBookPageVC () <UIGestureRecognizerDelegate> {
    DYMBookTextView      *_textView;
    
    UILabel              *_lblBookName;
    UILabel              *_lblChapterTitle;
    UILabel              *_lblProgress;
    UILabel              *_lblTime;

}

@property (nonatomic, copy) NSString        *bookName;

@property (nonatomic, copy) NSString        *chapterTitle;

@property (nonatomic, assign) NSUInteger    totalPageCount;

@property (nonatomic, strong) UIFont        *font;

@property (nonatomic, strong) UIColor       *textColor;

@end

@implementation DYMBookPageVC

-(void)setTextContainer:(NSTextContainer *)textContainer contentSize:(CGSize )contentSize pageEdgeInset:(UIEdgeInsets)pageEdgeInset {
    
//    NSLog(@"------begin init Text View...");
    
    _textContainer = textContainer;
    _contentSize = contentSize;
    _pageEdgeInset = pageEdgeInset;
    
    CGRect rect = CGRectMake(_pageEdgeInset.left
                             , _pageEdgeInset.top
                             , _contentSize.width, _contentSize.height);
    
    _textView = [[DYMBookTextView alloc] initWithFrame:rect textContainer:_textContainer];
    _textView.editable = NO;
    _textView.scrollEnabled = NO;
    
//    NSLog(@"------end init Text View...");
}

-(void)setBookName:(NSString *)bookName
       chapterTitle:(NSString *)chapterTitle
      currentIndex:(NSUInteger)currentIndex
   totoalPageCount:(NSUInteger)totoalPageCount
              font:(UIFont *)font
         textColor:(UIColor *)textColor {
    
    _bookName = bookName;
    _chapterTitle = chapterTitle;
    _currentIndex = currentIndex;
    _totalPageCount = totoalPageCount;
    _font = font;
    _textColor = textColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTimeChanged:) name:DYM_NOTIFICATION_MINUTE_CHANGED object:nil];
    
    [self.view addSubview:_textView];
    
    // Sub titles
    CGFloat alpha = 0.75;
    _lblBookName = [UILabel new];
    _lblBookName.alpha = alpha;
    _lblBookName.font = _font;
    _lblBookName.textColor = _textColor;
    _lblBookName.text = [NSString stringWithFormat:@"《%@》", _bookName];
    
    _lblChapterTitle = [UILabel new];
    _lblChapterTitle.alpha = alpha;
    _lblChapterTitle.font = _font;
    _lblChapterTitle.textColor = _textColor;
    _lblChapterTitle.text = _chapterTitle;
    _lblChapterTitle.textAlignment = NSTextAlignmentRight;
    
    _lblProgress = [UILabel new];
    _lblProgress.alpha = alpha;
    _lblProgress.font = _font;
    _lblProgress.textColor = _textColor;
    _lblProgress.text = [NSString stringWithFormat:@"%@ / %@", @(_currentIndex + 1), @(_totalPageCount)];
    
    _lblTime = [UILabel new];
    _lblTime.alpha = alpha;
    _lblTime.font = _font;
    _lblTime.textColor = _textColor;
    _lblTime.text = [self timeStringWithDateComponents:[DYMBookTimer dateComponentsForNow]];
    _lblTime.textAlignment = NSTextAlignmentRight;
    
    [self.view addSubview:_lblBookName];
    [_lblBookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(_pageEdgeInset.left + 5);
        make.bottom.equalTo(_textView.mas_top).offset(-5);
    }];
    
    [self.view addSubview:_lblProgress];
    [_lblProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(_pageEdgeInset.left + 5);
        make.top.equalTo(_textView.mas_bottom).offset(5);
        make.width.equalTo(@80);
    }];
    
    [self.view addSubview:_lblChapterTitle];
    [_lblChapterTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing).offset(-(_pageEdgeInset.right + 5));
        make.baseline.equalTo(_lblProgress.mas_baseline);
        make.leading.equalTo(_lblProgress.mas_trailing).offset(20);
    }];
    
    [self.view addSubview:_lblTime];
    [_lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing).offset(-(_pageEdgeInset.right + 5));
        make.baseline.equalTo(_lblBookName.mas_baseline);
        make.leading.equalTo(_lblBookName.mas_trailing).offset(20);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark -tap
-(void)tapped:(UITapGestureRecognizer *)tap {
    CGPoint location = [tap locationInView:self.view];
    EDYMBookPageArea area = [self pageAreaWithLocation:location];
//    NSLog(@"Tapped Begin: %@", NSStringFromCGPoint(location));
    
    if (_pageTapHandler) {
        _pageTapHandler(area, self);
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.view];
    EDYMBookPageArea area = [self pageAreaWithLocation:location];
    
    if (_transitionStyle == UIPageViewControllerTransitionStylePageCurl
        && (area == kDYMBookPageAreaLeft || area == kDYMBookPageAreaRight)) {
        return NO;
    }
    
    return YES;
}

-(EDYMBookPageArea)pageAreaWithLocation:(CGPoint)location {
    CGFloat pageWidth = CGRectGetWidth(self.view.frame);
    if (location.x < pageWidth * 0.25) {
        return kDYMBookPageAreaLeft;
    } else if (location.x > pageWidth * 0.75) {
        return kDYMBookPageAreaRight;
    }
    
    return kDYMBookPageAreaMiddle;
}

#pragma mark - timer
-(void)handleTimeChanged:(NSNotification *)notification {
    NSDateComponents *comp = notification.object;
    if ([comp isKindOfClass:[NSDateComponents class]]) {
        _lblTime.text = [self timeStringWithDateComponents:comp];
    }
}

-(NSString *)timeStringWithDateComponents:(NSDateComponents *)comp {
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)comp.hour, (long)comp.minute];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<%@> - Book:%@, Chapter:%@, CurrentIndex:%@", NSStringFromClass([self class]), _bookName, _chapterTitle, @(_currentIndex)];
}

@end
