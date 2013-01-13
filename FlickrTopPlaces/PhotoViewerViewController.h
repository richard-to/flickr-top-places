//
//  PhotoViewerViewController.h
//  FlickrTopPlaces
//
//  Created by Richard To on 1/7/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface PhotoViewerViewController : UIViewController <SplitViewBarButtonItemPresenter>
@property(nonatomic, strong) NSURL *imageUrl;
@property(nonatomic, strong) NSString *photoTitle;
-(void)updateImage;
@end
