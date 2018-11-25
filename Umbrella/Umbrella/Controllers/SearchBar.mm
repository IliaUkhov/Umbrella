//
//  SearchBar.m
//  Umbrella
//
//  Created by Ilia Ukhov on 10/10/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchBar.h"
#import "CityPicker.h"

#include "aliases_and_constants.hpp"
#include "request_processor.hpp"

@interface SearchBar ()

@property (weak, nonatomic) ViewConfigurator* viewConfigurator;
@property (weak, nonatomic) CityPicker* cityPickerController;
@property (weak, nonatomic) Service* requestMaker;

@property (nonatomic) cities::city current;
@property (nonatomic) cities::city last;

@property NSUserDefaults* defaults;

@end

@implementation SearchBar

- (instancetype)initWithView:(ViewConfigurator*)viewConfigurator
        cityPickerController:(CityPicker*)cityPickerController
                requestMaker:(Service*)requestMaker {
    if ([super init]) {
        self.viewConfigurator = viewConfigurator;
        self.cityPickerController = cityPickerController;
        self.requestMaker = requestMaker;
        self.current = {"", 0};
        self.last = {"", 0};
        self.defaults = [[NSUserDefaults alloc]
            initWithSuiteName:@"group.mycompany.Umbrella"];
    }
    return self;
}

- (void)autocompleteSearchWithCityName:(NSString*)name
                                 andId:(NSUInteger)serviceId {
    [self.viewConfigurator setSearchBarPlaceholderWithCityName:name];
    self.current = {[name UTF8String], serviceId};
    if (self.last.second == 0) self.last = self.current;
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [self.viewConfigurator autocompleteSearchBarWithCityName:
        [NSString stringWithUTF8String:self.current.first.c_str()]];
    self.last = self.current;
    [searchBar endEditing:YES];
    NSString* searchedCityName = [NSString stringWithUTF8String:self.current.first.c_str()];
    [self.viewConfigurator setCityLabelText: searchedCityName];
    [self.defaults setInteger:self.current.second forKey:@"LastSearchedCityId"];
    [self.defaults setObject:searchedCityName forKey:@"LastSearchedCityName"];
    [self.requestMaker sendRequestWithCityId:self.current.second];
}

- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar {
    [self.viewConfigurator autocompleteSearchBarWithCityName:
        [NSString stringWithUTF8String:self.last.first.c_str()]];
    [searchBar endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar {
    [searchBar setShowsCancelButton:YES];
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText {
    [self.cityPickerController getProbableCitiesWith:searchText];
}

- (void)searchBarTextDidEndEditing:(UISearchBar*)searchBar {
    [searchBar setShowsCancelButton:NO];
}

@end
