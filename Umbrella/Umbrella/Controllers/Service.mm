//
//  Service.m
//  Umbrella
//
//  Created by Ilia Ukhov on 10/22/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import "Service.h"

#include "request_processor.hpp"
#include "forecast_1_or_5_days.hpp"
#include "country_codes_dict_loader.hpp"
#include <iostream>

@interface Service ()

@property service::service_access* service;
@property weather::interpreter* weather_parser;
@property NSObject<ForecastDelegate>* observer;
@property ViewConfigurator* viewConfigurator;

@property ForecastType forecastType;
@property NSUInteger lastSearchedCityId;

@property BOOL toFindOutRequestedCity;

@end

@implementation Service

- (instancetype)initWithWeatherObserver:(NSObject<ForecastDelegate>*)observer
                       viewConfigurator:(ViewConfigurator*)viewConfigurator
                           forecastType:(ForecastType)type {
    if ([super init]) {
        self.observer = observer;
        using namespace service;
        cities::country_codes_dict_loader::load([[[NSBundle mainBundle]
            pathForResource:@"Resources" ofType:@"bundle"] UTF8String]);
        self.service = new request_processor();
        if (!cities::country_codes_dict_loader::get_country_codes_dict()) NSLog(@"Dict was not loaded");
        self.weather_parser = new weather::json_interpreter(
            cities::country_codes_dict_loader::get_country_codes_dict().get()
        );
        self.viewConfigurator = viewConfigurator;
        self.forecastType = type;
        self.service->add_response_handling([self](status_code code, std::string text){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processAnswerWithStatusCode:code text:text];
            });
        });
        self.lastSearchedCityId = 0;
        self.toFindOutRequestedCity = NO;
    }
    return self;
}

- (void)dealloc {
    delete self.service;
    delete self.weather_parser;
}

- (void)forecastTypeChanged:(ForecastType)type {
    self.forecastType = type;
    if (self.lastSearchedCityId != 0) [self sendRequestWithCityId:self.lastSearchedCityId];
}

- (void)processAnswerWithStatusCode:(NSUInteger)code text:(std::string)text {
    if (code != 200 || text.empty()) {
        [self.observer forecastLoadFailed];
        return;
    }
    self.weather_parser->read(text);
    if (self.toFindOutRequestedCity) {
        NSString* foundCity =
            [NSString stringWithUTF8String:self.weather_parser->get_city().first.c_str()];
        [self.viewConfigurator setCityLabelText:foundCity];
        [self.viewConfigurator endSearchBarEditing];
        self.toFindOutRequestedCity = NO;
    }
    void* forecast;
    switch (self.forecastType) {
        case OneDay:
            forecast = self.weather_parser->get_short_forecast();
            break;
        case FourDay:
            forecast = self.weather_parser->get_long_forecast();
            break;
    }
    if (self.observer) [self.observer forecastLoaded:forecast];
    [self deleteForecast:forecast];
}

- (void)deleteForecast:(void*)forecast {
    switch (self.forecastType) {
        case OneDay: {
            auto entries = reinterpret_cast<weather::short_forecast>(forecast);
            for (auto entry : *entries) delete entry;
            delete entries;
            break;
        }
        case FourDay: {
            auto entries = reinterpret_cast<weather::long_forecast>(forecast);
            for (auto entry : *entries) delete entry;
            delete entries;
            break;
        }
    }
}

- (void)sendRequestWithCityId:(NSUInteger)serviceId {
    self.lastSearchedCityId = serviceId;
    [self.observer forecastBeganLoad];
    self.service->send_request(serviceId);
}

- (void)sendRequestWithLatitude:(double)latitude longitude:(double)longitude {
    [self.observer forecastBeganLoad];
    self.service->send_request(latitude, longitude);
    self.toFindOutRequestedCity = YES;
}

@end
