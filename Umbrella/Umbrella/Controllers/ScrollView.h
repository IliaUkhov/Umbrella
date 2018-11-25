//
//  ScrollView.h
//  Umbrella
//
//  Created by Ilia Ukhov on 10/9/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewConfigurator.h"
#import "ForecastDelegate.h"

@interface ScrollView : NSObject<UIScrollViewDelegate>

- (instancetype)initWithView:(ViewConfigurator*)viewConfigurator;

@end
