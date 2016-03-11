//
//  DYMBookPageStyle.h
//  Pods
//
//  Created by Dong Yiming on 15/10/7.
//
//

#import <Foundation/Foundation.h>

@interface DYMBookPageStyle : NSObject

@property (nonatomic, strong)               UIFont    *font;

@property (nonatomic, strong, readonly)     UIFont    *subFont;

@property (nonatomic, strong)               UIColor   *textColor;
/// Page background color
@property (nonatomic, strong)               UIColor   *backgroundColor;

@property (nonatomic, assign)               CGSize    contentSize;
/// Insets around page's four edges
@property (nonatomic, assign)               UIEdgeInsets  pageEdgeInset;


@end
