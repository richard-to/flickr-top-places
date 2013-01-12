//
//  FlickrAnnotation.h
//  FlickrTopPlaces
//
//  Created by Richard To on 1/12/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrAnnotation : NSObject <MKAnnotation>
+ (FlickrAnnotation *)annotationFromMeta:(NSDictionary *)flickrMeta;
@property (nonatomic, strong) NSDictionary *flickrMeta;
@end
