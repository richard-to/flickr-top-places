//
//  PlacesMapViewController.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/11/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "PlacesMapViewController.h"
#import "FlickrPlacesAnnotation.h"

@interface PlacesMapViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *listButton;

@end

@implementation PlacesMapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    self.mapView.delegate = self;
}

- (void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        //aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    aView.annotation = annotation;
    //[(UIImageView *)aView.leftCalloutAccessoryView setImage: nil];
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    FlickrPlacesAnnotation *tempLocation = (FlickrPlacesAnnotation *)view.annotation;
    [self performSegueWithIdentifier:@"photos map view" sender:tempLocation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"photos map view"]) {
        NSLog(@"HIT");
    }
}
@end
