//
//  UIColor+UmbrellaColors.m
//  Umbrella
//
//  Created by Ilia Ukhov on 11/4/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import "UIColor+UmbrellaColors.h"

@implementation UIColor (UmbrellaColors)

+ (UIColor*)umbrella_dayClear {
    return [UIColor colorWithHue:0.56 saturation:0.32 brightness:1.0 alpha:1.0];
}

+ (UIColor*)umbrella_dayCloudy {
    return [UIColor colorWithHue:0.56 saturation:0.0 brightness:0.85 alpha:1.0];
}

+ (UIColor*)umbrella_nightClear {
    return [UIColor colorWithHue:0.67 saturation:0.29 brightness:0.68 alpha:1.0];
}

+ (UIColor*)umbrella_nightCloudy {
    return [UIColor colorWithHue:0.67 saturation:0.21 brightness:0.5 alpha:1.0];
}

+ (UIColor*)umbrella_gray {
    return [UIColor colorWithHue:0.56 saturation:0.0 brightness:0.93 alpha:1.0];
}

@end
