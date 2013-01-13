//
//  MapViewController.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/12/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <MKMapViewDelegate>

@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;
@synthesize showThumbnail = _showThumbnail;
@synthesize listButton = _listButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.showThumbnail = NO;
    self.navigationItem.hidesBackButton = YES;
    self.mapView.delegate = self;
}

- (void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) {
        id <MKAnnotation> aView = self.annotations[0];
        CLLocationCoordinate2D current = aView.coordinate;
        CLLocationDegrees minLatitude  = current.latitude;
        CLLocationDegrees maxLatitude = current.latitude;
        CLLocationDegrees minLongitude = current.longitude;
        CLLocationDegrees maxLongitude = current.longitude;
        
        for (id <MKAnnotation> aView in self.annotations) {
            current = aView.coordinate;
            if (current.latitude < minLatitude) {
                minLatitude = current.latitude;
            }
            
            if (current.latitude < maxLatitude) {
                maxLatitude = current.latitude;
            }
            
            if (current.longitude < minLongitude) {
                minLongitude = current.longitude;
            }
            
            if (current.longitude > maxLongitude) {
                maxLongitude = current.longitude;
            }
        }
        
        CLLocationCoordinate2D center;
        center.latitude = (minLatitude + maxLatitude) / 2;
        center.longitude = (minLongitude + maxLongitude) / 2;
        
        CLLocationDegrees latDelta = fabs(maxLatitude - minLatitude) * 1.1;
        CLLocationDegrees lngDelta = fabs(maxLongitude - minLongitude) * 1.1;
        
        MKCoordinateSpan span;
        span.latitudeDelta = latDelta;
        span.longitudeDelta = lngDelta;
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        [self.mapView setRegion:region animated:NO];
        [self.mapView addAnnotations:self.annotations];
    }
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
        if (self.showThumbnail) {
            aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        }
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    aView.annotation = annotation;
    if (self.showThumbnail) {
        [(UIImageView *)aView.leftCalloutAccessoryView setImage: nil];
    }
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

@end
