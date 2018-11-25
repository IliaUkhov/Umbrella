//
//  ViewConfigurator.h
//  Umbrella
//
//  Created by Ilia Ukhov on 10/25/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#ifndef view_h
#define view_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BackgroundView.h"
#import "ForecastDelegate.h"
#import "ForecastTypeObserver.h"

@class ForecastView;

@interface ViewConfigurator : NSObject<ForecastDelegate, ForecastTypeObserver>

- (instancetype)initWithUIElements:(NSArray*)ui
                      forecastType:(ForecastType)forecastType
                    sharedDefaults:(NSUserDefaults*)sharedDefaults;

/* implements ForecastDelegate */
- (void)forecastLoaded:(void*)weatherEntries;

/* implements ForecastDelegate */
- (void)forecastBeganLoad;

/* implements ForecastDelegate */
- (void)forecastLoadFailed;

/* implements ForecastTypeObserver */
- (void)forecastTypeChanged:(ForecastType)type;

- (void)performInitialSetup;

- (void)performLateSetup;

- (void)setSearchBarPlaceholderWithCityName:(NSString*)name;

- (void)autocompleteSearchBarWithCityName:(NSString*)name;

- (void)setPagesCount:(NSUInteger)count;

- (void)setCurrentPage:(NSUInteger)page;

- (void)refreshCityPicker;

- (void)selectRowInCityPicker:(NSUInteger)row;

- (void)setCityLabelText:(NSString*)text;

- (void)endSearchBarEditing;

@end

#endif /* view_h */
