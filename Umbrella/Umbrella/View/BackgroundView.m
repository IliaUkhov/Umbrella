//
//  BackgroundView.m
//  Umbrella
//
//  Created by Ilia Ukhov on 11/4/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import "BackgroundView.h"
#import "UIColor+UmbrellaColors.h"

@interface BackgroundView ()

@property UIView* mainView;
@property BOOL first;
@property BOOL isDay;
@property BOOL isClear;

@end

@implementation BackgroundView

- (instancetype)initWithMainView:(UIView*)view {
    if ([super init]) {
        self.mainView = view;
        self.first = YES;
        self.isDay = YES;
        self.isClear = YES;
    }
    return self;
}

- (void)setThemeWithIsDay:(BOOL)isDay isClear:(BOOL)isClear {
    if (isDay == self.isDay && isClear == self.isClear && !self.first) return;
    if (isDay) {
        if (isClear) {
            [self setGradientBackgroundWithUpperColor:
                [UIColor umbrella_dayClear] lowerColor:[UIColor umbrella_gray]];
        } else {
            [self setGradientBackgroundWithUpperColor:
                [UIColor umbrella_dayCloudy] lowerColor:[UIColor umbrella_gray]];
        }
    } else {
        if (isClear) {
            [self setGradientBackgroundWithUpperColor:
                [UIColor umbrella_nightClear] lowerColor:[UIColor umbrella_gray]];
        } else {
            [self setGradientBackgroundWithUpperColor:
                [UIColor umbrella_nightCloudy] lowerColor:[UIColor umbrella_gray]];
        }
    }
    self.isDay = isDay; self.isClear = isClear;
}

- (void)setGradientBackgroundWithUpperColor:(UIColor*)upper lowerColor:(UIColor*)lower {
    CAGradientLayer* gradient = [self makeGradientWithUpperColor:upper lowerColor:lower];
    [self.mainView.layer insertSublayer:gradient atIndex:0];
    if (!self.first) {
        [self.mainView.layer.sublayers[0] removeFromSuperlayer];
    } else {
        self.first = NO;
        CALayer* upperColor = [CALayer layer];
        upperColor.frame = self.mainView.bounds;
        upperColor.backgroundColor = upper.CGColor;
        [self.mainView.layer insertSublayer:upperColor atIndex:0];
    }
    CABasicAnimation* animation = [self makeColorChangeAnimationWithNewColor:upper];
    [self.mainView.layer.sublayers[0] addAnimation:animation forKey:@"backgroundColor"];
    [self.mainView.layer.sublayers[0] setBackgroundColor:upper.CGColor];
}

- (CAGradientLayer*)makeGradientWithUpperColor:(UIColor*)upper lowerColor:(UIColor*)lower {
    CAGradientLayer* gradient = [CAGradientLayer layer];
    gradient.frame = self.mainView.bounds;
    UIColor* whiteTransparent = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    gradient.colors = @[(id)whiteTransparent.CGColor, (id)lower.CGColor];
    gradient.startPoint = CGPointMake(0, 0.2);
    gradient.endPoint = CGPointMake(0, 1);
    return gradient;
}

- (CABasicAnimation*)makeColorChangeAnimationWithNewColor:(UIColor*)color {
    CABasicAnimation* animation =
        [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.fromValue =
        [self.mainView.layer.sublayers[0] valueForKeyPath:@"backgroundColor"];
    animation.toValue = (id) color.CGColor;
    animation.duration = 0.5;
    return animation;
}

@end
