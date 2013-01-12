//
//  PhotosMapViewController.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/12/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "PhotosMapViewController.h"
#import "PhotoViewerViewController.h"
#import "FlickrFetcher.h"
#import "FlickrAnnotation.h"

@interface PhotosMapViewController () <MapViewControllerDelegate>

@end

@implementation PhotosMapViewController

@synthesize flickrMeta = _flickrMeta;

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (void)setFlickrMeta:(NSDictionary *)flickrMeta
{
    if (_flickrMeta != flickrMeta) {
        _flickrMeta = flickrMeta;
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("photos in place map", NULL);
        dispatch_async(downloadQueue, ^{
            NSArray *photosInPlace = [FlickrFetcher photosInPlace:flickrMeta maxResults:50];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.rightBarButtonItem = NULL;
                self.annotations = [self mapAnnotationWithData:photosInPlace];
            });
        });
    }
}

- (NSArray *) mapAnnotationWithData:(NSArray *)flickrPhotoData
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:flickrPhotoData.count];
    for (NSDictionary* flickrMeta in flickrPhotoData) {
        [annotations addObject:[FlickrAnnotation annotationFromMeta:flickrMeta]];
    }
    return annotations;
}

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    FlickrAnnotation *fpa = (FlickrAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.flickrMeta format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data ? [UIImage imageWithData:data] : nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    FlickrAnnotation *tempLocation = (FlickrAnnotation *)view.annotation;
    [self performSegueWithIdentifier:@"photo map to photo detail view" sender:tempLocation.flickrMeta];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"photo map to photo detail view"]) {
        NSURL *url = [FlickrFetcher urlForPhoto: sender
                                         format:FlickrPhotoFormatLarge];
        [segue.destinationViewController setImageUrl: url];
        [segue.destinationViewController setPhotoTitle:sender[FLICKR_PHOTO_TITLE]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *viewedSet = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"viewedPhotos"] copyItems:YES];
        
        if (!viewedSet) {
            viewedSet = [[NSMutableArray alloc] init];
        }
        [viewedSet addObject:sender];
        [[NSUserDefaults standardUserDefaults] setObject:[viewedSet copy]
                                                  forKey:@"viewedPhotos"];
    }
}

@end
