//
//  ForecastTypeObserver.h
//  Umbrella
//
//  Created by Ilia Ukhov on 11/1/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#ifndef CurrentForecastTypeObserver_h
#define CurrentForecastTypeObserver_h

#import <Foundation/Foundation.h>

typedef enum { OneDay, FourDay } ForecastType;

@protocol ForecastTypeObserver <NSObject>

@required

- (void)forecastTypeChanged:(ForecastType)type;

@end

#endif /* CurrentForecastTypeObserver_h */
