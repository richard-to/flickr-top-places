//
//  PhotoViewerViewController.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/7/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "PhotoViewerViewController.h"

@interface PhotoViewerViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewer;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@end

@implementation PhotoViewerViewController

@synthesize imageUrl = _imageUrl;
@synthesize scrollViewer = _scrollViewer;
@synthesize imageView = _imageView;
@synthesize photoTitle = _photoTitle;
@synthesize photoLabel = _photoLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollViewer.delegate = self;
    self.photoLabel.text = self.photoTitle;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSArray *directories = [fm URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSString *path = [[directories lastObject] path];
    NSString *largePhotoCachePath = [path stringByAppendingPathComponent: @"largePhotos"];
    [fm createDirectoryAtPath:largePhotoCachePath withIntermediateDirectories:TRUE attributes:nil error: nil];

    NSString *photoFilePath = [largePhotoCachePath stringByAppendingPathComponent: [self.imageUrl lastPathComponent]];

    if ([fm isReadableFileAtPath:photoFilePath]) {
        NSLog(@"RETRIEVE FROM CACHE");
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:photoFilePath];
        self.imageView.image = [UIImage imageWithData:imageData];
        self.scrollViewer.zoomScale = 1;
        self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
        self.scrollViewer.contentSize = self.imageView.frame.size;
    } else {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        
        NSLog(@"RETRIEVE OUT OF URL");
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr photo download", NULL);
        dispatch_async(downloadQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL:self.imageUrl];
            [data writeToFile:photoFilePath atomically: YES];
            UIImage *img = [UIImage imageWithData: data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.rightBarButtonItem = NULL;
                self.imageView.image = img;
                self.scrollViewer.zoomScale = 1;
                self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
                self.scrollViewer.contentSize = self.imageView.frame.size;            
            });
        });
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (NSString *)photoTitle
{
    if(!_photoTitle || _photoTitle.length <= 0) _photoTitle = @"Unknown";
    return _photoTitle;
}

- (void)setImageUrl:(NSURL *)imageUrl
{
    _imageUrl = imageUrl;

}
@end
