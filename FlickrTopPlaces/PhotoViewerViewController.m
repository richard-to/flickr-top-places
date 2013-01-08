//
//  PhotoViewerViewController.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/7/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "PhotoViewerViewController.h"

@interface PhotoViewerViewController ()
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
    self.photoLabel.text = self.photoTitle;
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageUrl]];
    self.scrollViewer.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);    
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
