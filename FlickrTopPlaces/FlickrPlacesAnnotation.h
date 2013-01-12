//
//  FlickrPlacesAnnotation.h
//  FlickrTopPlaces
//
//  Created by Richard To on 1/11/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPlacesAnnotation : NSObject <MKAnnotation>
+ (FlickrPlacesAnnotation *)annotationForPlace:(NSDictionary *)place;
@property (nonatomic, strong) NSDictionary *place;
@end
