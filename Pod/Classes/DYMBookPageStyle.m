//
//  DYMBookPageStyle.m
//  Pods
//
//  Created by Dong Yiming on 15/10/7.
//
//

#import "DYMBookPageStyle.h"

@implementation DYMBookPageStyle


-(void)setFont:(UIFont *)font {
    _font = font;
    if (_font) {
        _subFont = [UIFont fontWithName:_font.fontName size:_font.pointSize * 0.7];
    }
}

@end
