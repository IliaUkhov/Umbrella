//
//  CityPicker.m
//  Umbrella
//
//  Created by Ilia Ukhov on 10/6/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityPicker.h"
#import "SearchBar.h"

#include "quick_city_finder.hpp"
#include "country_codes_dict_loader.hpp"

@interface CityPicker ()

@property (weak, nonatomic) ViewConfigurator* gui;
@property (weak, nonatomic) SearchBar* searchBarController;

@property (nonatomic) cities::city_finder* picker_data_provider;
@property (nonatomic) std::vector<cities::city> cities_to_show;

@end

@implementation CityPicker

- (instancetype)initWithView:(ViewConfigurator*)view
            searchController:(SearchBar*)searchBarController {
    if ([super init]) {
        self.gui = view;
        NSString* bundlePath = [[NSBundle mainBundle]
            pathForResource:@"Resources" ofType:@"bundle"];
        cities::country_codes_dict_loader::load([bundlePath UTF8String]);
        self.picker_data_provider =
            new cities::quick_city_finder
            (
                [bundlePath UTF8String]
,               cities::country_codes_dict_loader::get_country_codes_dict().get()
             );
        self.searchBarController = searchBarController;
        [self getProbableCitiesWith:@""];
    }
    return self;
}

- (void)dealloc {
    delete self.picker_data_provider;
}

- (void)getProbableCitiesWith:(NSString*)namePart {
    BOOL empty = namePart.length == 0;
    if (empty) {
        self.cities_to_show =
            self.picker_data_provider->get_big_cities();
    } else {
        self.cities_to_show =
            self.picker_data_provider->get_similar_cities([namePart UTF8String], 100);
    }
    [self.gui refreshCityPicker];
    if (self.cities_to_show.size() > 0) {
        [self.gui selectRowInCityPicker:empty ? 19 : 0];
        [self autocompleteSearchWithCity:self.cities_to_show[empty ? 19 : 0]];
    }
}

- (NSInteger)pickerView:(UIPickerView*)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return self.cities_to_show.size();
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView*)pickerView {
    return 1;
}

- (NSString*)pickerView:(UIPickerView*)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component {
    if (self.cities_to_show.size() > 0) {
        return [NSString stringWithUTF8String:self.cities_to_show[row].first.c_str()];
    } else {
        return @"";
    }
}

- (void)pickerView:(UIPickerView*)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    [self autocompleteSearchWithCity:self.cities_to_show[row]];
}

- (void)autocompleteSearchWithCity:(cities::city)city {
    [self.searchBarController autocompleteSearchWithCityName:
        [NSString stringWithUTF8String:city.first.c_str()] andId:city.second];
}

@end
