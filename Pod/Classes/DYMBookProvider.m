//
//  DYMBookProvider.m
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import "DYMBookProvider.h"


@interface DYMBookProvider ()

@end

@implementation DYMBookProvider

+(NSString *)bookWithTxtFilePath:(NSString *)filePath {
    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:url.absoluteString]) {
//        NSData *data = [NSData dataWithContentsOfFile:url.absoluteString];
//        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }
    NSError *error;
    
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    return str;
}

+(DYMBook *)bookWithPlistFileName:(NSString *)fileName {
    return [[DYMBook alloc] initWithPlistFileName:fileName];
}

@end
