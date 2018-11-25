//
//  SearchBar.h
//  Umbrella
//
//  Created by Ilia Ukhov on 10/10/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewConfigurator.h"
#import "Service.h"

@class CityPicker;

@interface SearchBar : NSObject<UISearchBarDelegate>

-(instancetype)initWithView:(ViewConfigurator*)viewConfigurator
       cityPickerController:(CityPicker*)cityPickerController
               requestMaker:(Service*)requestMaker;

- (void)autocompleteSearchWithCityName:(NSString*)name
                                 andId:(NSUInteger)serviceId;

@end
