//
//  DYMBookPagesCache.h
//  Pods
//
//  Created by Dong Yiming on 15/10/6.
//
//

#import <Foundation/Foundation.h>
#import "DYMBookPageVC.h"

@interface DYMBookPagesCache : NSObject

-(DYMBookPageVC *)dequeuePageForContainer:(NSTextContainer *)textContainer contentSize:(CGSize)contentSize pageEdgeInset:(UIEdgeInsets)pageEdgeInset;

@end
