//
//  DYMBookProvider.h
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import <Foundation/Foundation.h>
#import "DYMBook.h"

@interface DYMBookProvider : NSObject

+(NSString *)bookWithTxtFilePath:(NSString *)filePath;

+(DYMBook *)bookWithPlistFileName:(NSString *)fileName;

@end
