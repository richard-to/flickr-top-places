//
//  PlacesMapViewController.h
//  FlickrTopPlaces
//
//  Created by Richard To on 1/11/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class PlacesMapViewController;

@protocol MapViewControllerDelegate <NSObject>
- (UIImage *)mapViewController:(PlacesMapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end

@interface PlacesMapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;
@end
