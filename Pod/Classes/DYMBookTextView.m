//
//  DYMBookTextView.m
//  Pods
//
//  Created by Dong Yiming on 15/10/6.
//
//

#import "DYMBookTextView.h"

@implementation DYMBookTextView

-(instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1]; // for debug
        self.scrollEnabled = NO;
        self.editable = NO;
        
        _textSize = frame.size;
    }
    return self;
}

@end
