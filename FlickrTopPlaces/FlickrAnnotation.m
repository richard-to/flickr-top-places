//
//  FlickrAnnotation.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/12/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "FlickrAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrAnnotation

@synthesize flickrMeta = _flickrMeta;

+ (FlickrAnnotation *)annotationFromMeta:(NSDictionary *)flickrMeta;
{
    FlickrAnnotation *annotation =
    [[FlickrAnnotation alloc] init];
    annotation.flickrMeta = flickrMeta;
    return annotation;
}

- (NSString *)title
{
    NSString *title = self.flickrMeta[FLICKR_PHOTO_TITLE];
    NSString *desc = self.flickrMeta[@"description"][@"_content"];
    if (title.length > 0) {
        return title;
    } else {
        return desc;
    }
}

- (NSString *)subtitle
{
    NSString *desc = self.flickrMeta[@"description"][@"_content"];
    if (desc.length > 0) {
        return desc;
    } else {
        return nil;
    }
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.flickrMeta objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.flickrMeta objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}
@end
