//
//  ViewConfigurator.m
//  Umbrella
//
//  Created by Ilia Ukhov on 10/25/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import "ViewConfigurator.h"
#import "ForecastView.h"
#import "InitialSetup.h"
#import "WeatherInfoLabel.h"
#import "UIColor+UmbrellaColors.h"
#import "UIIndices.h"

#include <stdio.h>
#include <string>
#include <vector>
#include "forecast.hpp"

@interface ViewConfigurator ()

@property (weak, nonatomic) NSArray* ui;
@property (retain, nonatomic) BackgroundView* backgroundView;
@property (retain, nonatomic) ForecastView* forecastView;
@property (retain, nonatomic) InitialSetup* initialSetup;
@property (nonatomic) ForecastType forecastType;

@property (nonatomic) NSString* searchedCity;
@property (nonatomic) NSUserDefaults* sharedDefaults;

@end

@implementation ViewConfigurator

- (instancetype)initWithUIElements:(NSArray*)ui
                      forecastType:(ForecastType)forecastType
                    sharedDefaults:(NSUserDefaults*)sharedDefaults {
    if ([super init]) {
        NSDictionary* pictures = [self getPictureDictionary];
        self.ui = ui;
        self.backgroundView = [[BackgroundView alloc]
            initWithMainView:self.ui[MainView]];
        self.forecastView = [[ForecastView alloc]
            initWithScrollView:self.ui[ScrollView]
            viewConfigurator:self
            backgroundView:self.backgroundView
            pictureDictionary:pictures
            sharedDefaults:sharedDefaults];
        self.initialSetup = [[InitialSetup alloc]
            initWithUIElements:ui
            backgroundViewConfigurator:self.backgroundView];
        self.forecastType = forecastType;
        self.searchedCity = @"";
    }
    return self;
}

- (void)forecastLoaded:(void*)weatherEntries {
    [self clearSubviews:self.ui[ScrollView]];
    [self.ui[CityLabel] setText:self.searchedCity];
    std::vector<weather::weather*>* short_forecast;
    switch (self.forecastType) {
        case OneDay:
            short_forecast =
                reinterpret_cast<weather::short_forecast>(weatherEntries);
            [self.forecastView showNewShortForecast: short_forecast];
            break;
        case FourDay:
            [self.forecastView showNewLongForecast:
                reinterpret_cast<weather::long_forecast>(weatherEntries)];
            break;
    }
    [self updateWidgetCity];
    [self.sharedDefaults synchronize];
}

- (void)forecastBeganLoad {
    [self.ui[CityLabel] setText:@""];
    [self clearSubviews:self.ui[ScrollView]];
    [self setSpinningWheelIntoView:self.ui[ScrollView]];
}

- (void)setSpinningWheelIntoView:(UIView*)view {
    UIActivityIndicatorView* wheel = [[UIActivityIndicatorView alloc] init];
    wheel.frame = ((UIScrollView*) self.ui[ScrollView]).frame;
    wheel.transform = CGAffineTransformMakeScale(2.5, 2.5);
    [wheel.layer setOpacity:0.0];
    [wheel.layer addAnimation:[self makeDelayedAppearAnimation] forKey:@"opacity"];
    [wheel startAnimating];
    [view addSubview: wheel];
}

- (CABasicAnimation*)makeDelayedAppearAnimation {
    CABasicAnimation* delayedAppear =
        [CABasicAnimation animationWithKeyPath:@"opacity"];
    delayedAppear.fromValue = [NSNumber numberWithFloat:0.0];
    delayedAppear.toValue = [NSNumber numberWithFloat:1.0];
    [delayedAppear setFillMode:kCAFillModeForwards];
    [delayedAppear setRemovedOnCompletion:NO];
    delayedAppear.beginTime = CACurrentMediaTime() + 0.25;
    return delayedAppear;
}

- (void)forecastLoadFailed {
    [self clearSubviews:self.ui[ScrollView]];
    UIImageView* noConnection = [[UIImageView alloc]
        initWithImage:[UIImage imageNamed:@"NoConnection"]];
    CGRect thisScrollViewFrame = ((UIScrollView*) self.ui[ScrollView]).frame;
    noConnection.frame = CGRectMake(
            0,
            50,
            thisScrollViewFrame.size.width,
            thisScrollViewFrame.size.width * 0.64
    );
    [self.ui[ScrollView] addSubview:noConnection];
    [self updateWidgetWithEmptyInfo];
    [self.sharedDefaults synchronize];
}

- (void)clearSubviews:(UIView*)view {
    for (UIView* subview in view.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)forecastTypeChanged:(ForecastType)type {
    self.forecastType = type;
}

- (void)performInitialSetup {
    [self.initialSetup performInitialSetup];
}

- (void)performLateSetup {
    [self.initialSetup performLateSetup];
}

- (void)setSearchBarPlaceholderWithCityName:(NSString*)name {
    [self.ui[SearchBar] setPlaceholder:name];
}

- (void)autocompleteSearchBarWithCityName:(NSString*)name {
    [self.ui[SearchBar] setText:name];
}

- (void)setPagesCount:(NSUInteger)count {
    [self.ui[PageIndicator] setNumberOfPages:count];
}

- (void)setCurrentPage:(NSUInteger)page {
    [self.ui[PageIndicator] setCurrentPage:page];
    [self.forecastView setupThemeWithPage:page];
}

- (void)refreshCityPicker {
    [self.ui[CityPicker] reloadAllComponents];
}

- (void)selectRowInCityPicker:(NSUInteger)row {
    [self.ui[CityPicker] selectRow:row inComponent:0 animated:NO];
}

- (void)setCityLabelText:(NSString*)text {
    self.searchedCity = text;
}

- (void)updateWidgetWithEmptyInfo {
    [self.sharedDefaults setObject:@"empty" forKey:@"Description"];
}

- (void)updateWidgetCity {
    [self.sharedDefaults setObject:self.searchedCity forKey:@"City"];
}

- (void)endSearchBarEditing {
    [self.ui[SearchBar] endEditing:YES];
}

- (NSDictionary*)getPictureDictionary {
    return @{
             @"empty" : @"NoConnection",
             @"clear sky" : @"ClearSky",
             @"few clouds" : @"LittleCloudy",
             @"scattered clouds" : @"LittleCloudy",
             @"broken clouds" : @"Cloudy",
             @"light rain" : @"LightRain",
             @"mist" : @"Fog",
             @"moderate rain" : @"Rain",
             @"heavy intensity rain" : @"Rain",
             @"hail" : @"Hail"
             };
}

@end
