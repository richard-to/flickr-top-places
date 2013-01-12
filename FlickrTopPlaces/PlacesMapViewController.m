//
//  PlacesMapViewController.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/11/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "PlacesMapViewController.h"
#import "PhotosMapViewController.h"
#import "FlickrPlacesAnnotation.h"
#import "FlickrFetcher.h"

@interface PlacesMapViewController ()
@end

@implementation PlacesMapViewController

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    FlickrPlacesAnnotation *tempLocation = (FlickrPlacesAnnotation *)view.annotation;
    [self performSegueWithIdentifier:@"photos map view" sender:tempLocation.flickrMeta];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"photos map view"]) {
        [segue.destinationViewController setFlickrMeta: sender];
    }
}
@end
