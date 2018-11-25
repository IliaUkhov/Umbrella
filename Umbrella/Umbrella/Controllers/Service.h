//
//  Service.h
//  Umbrella
//
//  Created by Ilia Ukhov on 10/22/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForecastDelegate.h"
#import "ForecastTypeObserver.h"
#import "ViewConfigurator.h"

@interface Service : NSObject<ForecastTypeObserver>

- (instancetype)initWithWeatherObserver:(NSObject<ForecastDelegate>*)observer
                       viewConfigurator:(ViewConfigurator*)viewConfigurator
                           forecastType:(ForecastType)type;

- (void)sendRequestWithCityId:(NSUInteger)serviceId;

- (void)sendRequestWithLatitude:(double)latitude longitude:(double)longitude;

@end
