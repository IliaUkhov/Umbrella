//
//  LocationButtonHelper.h
//  Umbrella
//
//  Created by Ilia Ukhov on 11/21/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#ifndef LocationButtonHelper_h
#define LocationButtonHelper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Service.h"

@interface LocationButtonHelper : NSObject<CLLocationManagerDelegate>

- (instancetype)initWithLocationButton:(UIButton*)button
                              service:(Service*)service;

/* implements CLLocationManagerDelegate */
- (void)locationManager:(CLLocationManager*)manager
     didUpdateLocations:(NSArray<CLLocation*>*)locations;

/* implements CLLocationManagerDelegate */
- (void)locationManager:(CLLocationManager*)manager
       didFailWithError:(NSError*)error;

@end

#endif /* LocationButtonHelper_h */
