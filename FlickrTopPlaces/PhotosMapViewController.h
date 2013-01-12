//
//  PhotosMapViewController.h
//  FlickrTopPlaces
//
//  Created by Richard To on 1/12/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface PhotosMapViewController : MapViewController
@property (nonatomic, strong) NSDictionary *flickrMeta;
@end
