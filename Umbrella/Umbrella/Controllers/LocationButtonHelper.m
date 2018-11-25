//
//  LocationButtonHelper.m
//  Umbrella
//
//  Created by Ilia Ukhov on 11/21/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import "LocationButtonHelper.h"

@interface LocationButtonHelper ()

@property UIButton* button;
@property CLLocationManager* manager;
@property Service* requestMaker;

@end

@implementation LocationButtonHelper

- (instancetype)initWithLocationButton:(UIButton*)button
                              service:(Service*)service {
    if ([super init]) {
        self.button = button;
        self.requestMaker = service;
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        self.manager.distanceFilter = kCLDistanceFilterNone;
        self.manager.desiredAccuracy = kCLLocationAccuracyKilometer;
        [self setupButtonAction];
    }
    return self;
}

- (void)setupButtonAction {
    [self.button addTarget:self
                    action:@selector(locationButtonPressed)
          forControlEvents:UIControlEventTouchUpInside];
}

- (void)locationButtonPressed {
    NSLog(@"Current location");
    [self.manager requestWhenInUseAuthorization];
    [self.manager requestLocation];
}

- (void)locationManager:(CLLocationManager*)manager
     didUpdateLocations:(NSArray<CLLocation*>*)locations {
    CLLocationCoordinate2D newLocation = [locations lastObject].coordinate;
    NSLog(@"Latitude: %f", newLocation.latitude);
    NSLog(@"Longitude: %f", newLocation.longitude);
    [self.requestMaker sendRequestWithLatitude:newLocation.latitude
                                     longitude:newLocation.longitude];
}

- (void)locationManager:(CLLocationManager*)manager
       didFailWithError:(NSError*)error {
    NSLog(@"Loaction updating failed");
}

@end
