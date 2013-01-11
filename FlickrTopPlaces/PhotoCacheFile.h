//
//  PhotoCacheFile.h
//  FlickrTopPlaces
//
//  Created by Richard To on 1/11/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoCacheFile : NSObject
@property (nonatomic) int cacheSize;
@property (nonatomic, strong) NSString *cacheFolderName;
- (BOOL)fileExists:(NSString *)filename;
- (NSData *)retrieveCachedFileByFilename:(NSString *)filename;
- (void)storeFileInCacheUsingData:(NSData *)fileData
               withFilename:(NSString *)filename;
@end
