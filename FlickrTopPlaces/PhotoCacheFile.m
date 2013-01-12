//
//  PhotoCacheFile.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/11/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "PhotoCacheFile.h"

static const int CACHE_SIZE_DEFAULT = 1350350; //1024 * 3072;

@interface PhotoCacheFile ()
@property (nonatomic, strong) NSString *userCacheDirectory;
@property (nonatomic, strong) NSString *photoCacheDirectory;
@property (nonatomic, strong) NSFileManager *fileManager;
- (NSString *)findOldestFile;
- (void)removeFile:(NSString *)filePath;
@end

@implementation PhotoCacheFile
@synthesize fileManager = _fileManager;
@synthesize cacheSize = _cacheSize;
@synthesize userCacheDirectory = _userCacheDirectory;
@synthesize cacheFolderName = _cacheFolderName;
@synthesize photoCacheDirectory = _photoCacheDirectory;

- (NSFileManager *)fileManager
{
    if (!_fileManager) _fileManager = [[NSFileManager alloc] init];
    return _fileManager;
}

- (int)cacheSize
{
    if (!_cacheSize) _cacheSize = CACHE_SIZE_DEFAULT;
    return _cacheSize;
}

- (NSString *)cacheFolderName
{
    if (!_cacheFolderName) _cacheFolderName = @"largePhotos";
    return _cacheFolderName;
}

- (NSString *)userCacheDirectory
{
    if (!_userCacheDirectory) {
        _userCacheDirectory = [[[self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] path];
    }
    return _userCacheDirectory;
}

- (NSString *)photoCacheDirectory
{
    if (!_photoCacheDirectory) {
        _photoCacheDirectory = [self.userCacheDirectory stringByAppendingPathComponent:self.cacheFolderName];

        [self.fileManager createDirectoryAtPath: _photoCacheDirectory withIntermediateDirectories:TRUE attributes:nil error: nil];
    }
    return _photoCacheDirectory;
}

- (BOOL)fileExists:(NSString *)filename
{
    NSString *path = [self.photoCacheDirectory stringByAppendingPathComponent:filename];
    return [self.fileManager isReadableFileAtPath: path];
}

- (NSData *)retrieveCachedFileByFilename:(NSString *)filename
{
    return [[NSData alloc] initWithContentsOfFile: [self.photoCacheDirectory stringByAppendingPathComponent:filename]];
}

- (void)storeFileInCacheUsingData:(NSData *)fileData
               withFilename:(NSString *)filename
{
    NSString *path = [self.photoCacheDirectory stringByAppendingPathComponent:filename];
    [fileData writeToFile:path atomically:YES];
    while ([self isCacheFull]) {
        NSString *oldestFile = [self findOldestFile];
        [self removeFile: oldestFile];
    }
}

- (BOOL)isCacheFull
{
    NSDictionary *fileAttributes;
    unsigned long long totalFileSize = 0;
    NSArray *files = [self.fileManager contentsOfDirectoryAtPath: self.photoCacheDirectory error:nil];
    NSString *filePath;
    for (NSString *filename in files) {
        filePath = [self.photoCacheDirectory stringByAppendingPathComponent:filename];
        if ([self.fileManager fileExistsAtPath: filePath]) {
            fileAttributes = [self.fileManager attributesOfItemAtPath:filePath error:nil];
            totalFileSize += [fileAttributes fileSize];
        }
    }
    return (totalFileSize > self.cacheSize) ? YES : NO;
}

- (NSString *)findOldestFile
{
    NSDictionary *fileAttributes;
    NSArray *files = [self.fileManager contentsOfDirectoryAtPath:self.photoCacheDirectory error:nil];
    NSString *filePath;
    NSString *oldestFilePath;
    NSDate *fileCreateDate;
    for (NSString *filename in files) {
        filePath = [self.photoCacheDirectory stringByAppendingPathComponent:filename];
        if ([self.fileManager fileExistsAtPath: filePath]) {
            fileAttributes = [self.fileManager attributesOfItemAtPath:filePath error:nil];
            if (!fileCreateDate ||
                    [fileAttributes.fileModificationDate compare: fileCreateDate] == NSOrderedAscending) {
                fileCreateDate = fileAttributes.fileModificationDate;
                oldestFilePath = filePath;
            }
        }
    }
    return oldestFilePath;
}

- (void)removeFile:(NSString *)filePath
{
    [self.fileManager removeItemAtPath:filePath error:nil];
}
@end
