//
//  DYMBookUtility.m
//  Pods
//
//  Created by Dong Yiming on 15/10/6.
//
//

#import "DYMBookUtility.h"
#import <CoreText/CoreText.h>

@implementation DYMBookUtility

+(void)doAsync:(dispatch_block_t)block completion:(dispatch_block_t)completionBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       
        if (block) {
            block();
        }
        
        dispatch_async(dispatch_get_main_queue(), completionBlock);
    });
}

//+(NSBundle *)resourceBundle {
//    
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSURL *url = [bundle URLForResource:@"DYMBook" withExtension:@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithURL:url];
//    
//    return resourceBundle;
//}


+(UIFont *)customFontWithFileName:(NSString *)fileName Size:(CGFloat)fontSize {
    
    static NSString *customFontName = nil;
    
    if (customFontName == nil) {
        NSString * fontPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"ttf"];
        NSURL * url = [NSURL fileURLWithPath:fontPath];
        
        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
        CGFontRef customFont = CGFontCreateWithDataProvider(fontDataProvider);
        customFontName = (__bridge NSString *)CGFontCopyPostScriptName(customFont);
        CGDataProviderRelease(fontDataProvider);
        
        CTFontManagerRegisterGraphicsFont(customFont, NULL);
        CGFontRelease(customFont);
    }
    
    return [UIFont fontWithName:customFontName size:fontSize];
}

@end
