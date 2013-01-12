//
//  MapViewController.h
//  FlickrTopPlaces
//
//  Created by Richard To on 1/12/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@protocol MapViewControllerDelegate <NSObject>
- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end


@interface MapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;
@property BOOL showThumbnail;
@end
