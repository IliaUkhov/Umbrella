//
//  CityPicker.h
//  Umbrella
//
//  Created by Ilia Ukhov on 10/6/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewConfigurator.h"

@class SearchBar;

@interface CityPicker : NSObject<UIPickerViewDelegate, UIPickerViewDataSource>

- (instancetype)initWithView:(ViewConfigurator*)view
            searchController:(SearchBar*)searchBarController;

- (void)getProbableCitiesWith:(NSString*)namePart;

@end
