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

+ (FlickrAnnotation *)annotationFromMeta:(NSDictionary *)flickrMeta;
{
    FlickrPlacesAnnotation *annotation =
        [[FlickrPlacesAnnotation alloc] init];
    annotation.flickrMeta = flickrMeta;
    return annotation;
}

- (NSString *)title
{
    NSArray *placeChunks = [[self.flickrMeta objectForKey:FLICKR_PLACE_NAME]
                            componentsSeparatedByString:@", "];
    return placeChunks[0];
}

- (NSString *)subtitle
{
    NSArray *placeChunks = [[self.flickrMeta objectForKey:FLICKR_PLACE_NAME]
                            componentsSeparatedByString:@", "];
    if (placeChunks.count == 3) {
        return [[NSString alloc] initWithFormat:
                                     @"%@, %@", placeChunks[1], placeChunks[2]];
    } else {
       return placeChunks[1];
    }
}
@end
