//
//  PhotoViewerViewController.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/7/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "PhotoViewerViewController.h"
#import "PhotoCacheFile.h"

@interface PhotoViewerViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewer;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
-(void)displayImage:(UIImage *)image;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@end

@implementation PhotoViewerViewController

@synthesize imageUrl = _imageUrl;
@synthesize scrollViewer = _scrollViewer;
@synthesize imageView = _imageView;
@synthesize photoTitle = _photoTitle;
@synthesize photoLabel = _photoLabel;
@synthesize toolBar = _toolBar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollViewer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateImage];
}

- (void)updateImage
{
    PhotoCacheFile *photoCache = [[PhotoCacheFile alloc] init];
    self.photoLabel.text = self.photoTitle;    
    NSString *filename = [self.imageUrl lastPathComponent];
    if ([photoCache fileExists: filename]) {
        NSData *imageData = [photoCache retrieveCachedFileByFilename:filename];
        UIImage *image = [UIImage imageWithData:imageData];
        [self displayImage:image];
    } else {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr photo download", NULL);
        dispatch_async(downloadQueue, ^{
            NSData *imageData = [NSData dataWithContentsOfURL:self.imageUrl];
            UIImage *image = [UIImage imageWithData: imageData];
            [photoCache storeFileInCacheUsingData: imageData withFilename:filename];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.rightBarButtonItem = NULL;
                [self displayImage: image];
            });
        });
    }
}

- (void)handSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolBarItems = [self.toolBar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolBarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolBarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolBar.items = toolBarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        [self handSplitViewBarButtonItem: splitViewBarButtonItem];
    }
}

- (void)displayImage:(UIImage *) image
{
    self.navigationItem.rightBarButtonItem = NULL;
    self.imageView.image = image;
    self.scrollViewer.zoomScale = 1;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.scrollViewer.contentSize = self.imageView.frame.size;
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
