//
//  ForecastDelegate.h
//  Umbrella
//
//  Created by Ilia Ukhov on 10/22/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ForecastDelegate <NSObject>

@required

- (void)forecastLoaded:(void*)forecast;

- (void)forecastBeganLoad;

- (void)forecastLoadFailed;

@end
