//
//  FlickrPlacesAnnotation.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/11/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "FlickrPlacesAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPlacesAnnotation

@synthesize place;

+ (FlickrPlacesAnnotation *)annotationForPlace:(NSDictionary *)place;
{
    FlickrPlacesAnnotation *annotation =
        [[FlickrPlacesAnnotation alloc] init];
    annotation.place = place;
    return annotation;
}

- (NSString *)title
{
    NSArray *placeChunks = [[self.place objectForKey:FLICKR_PLACE_NAME]
                            componentsSeparatedByString:@", "];
    return placeChunks[0];
}

- (NSString *)subtitle
{
    NSArray *placeChunks = [[self.place objectForKey:FLICKR_PLACE_NAME]
                            componentsSeparatedByString:@", "];
    if (placeChunks.count == 3) {
        return [[NSString alloc] initWithFormat:
                                     @"%@, %@", placeChunks[1], placeChunks[2]];
    } else {
       return placeChunks[1];
    }
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.place objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}
@end
