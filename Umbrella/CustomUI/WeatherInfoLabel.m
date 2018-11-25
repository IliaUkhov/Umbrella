//
//  WeatherInfoLabel.m
//  Umbrella
//
//  Created by Ilia Ukhov on 11/3/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import "WeatherInfoLabel.h"

@implementation WeatherInfoLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:20];
    }
    return self;
}

@end
