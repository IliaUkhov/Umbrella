//
//  ForecastView.h
//  Umbrella
//
//  Created by Ilia Ukhov on 11/5/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#ifndef ForecastView_h
#define ForecastView_h

#import <Foundation/Foundation.h>
#import "BackgroundView.h"
#import "ForecastDelegate.h"
#import "ForecastTypeObserver.h"

#include <stdio.h>
#include <vector>
#include "forecast.hpp"

@class ViewConfigurator;

@interface ForecastView : NSObject

- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                  viewConfigurator:(ViewConfigurator*)viewConfigurator
                    backgroundView:(BackgroundView*)backgroundView
                 pictureDictionary:(NSDictionary*)pictures
                    sharedDefaults:(NSUserDefaults*)sharedDefaults;

- (void)showNewShortForecast:(weather::short_forecast)entries;

- (void)showNewLongForecast:(weather::long_forecast)entries;

- (void)setupThemeWithPage:(NSUInteger)page;

@end

#endif /* ForecastView_h */
