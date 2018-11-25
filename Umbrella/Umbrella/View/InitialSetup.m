//
//  InitialSetup.m
//  Umbrella
//
//  Created by Ilia Ukhov on 10/27/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import "InitialSetup.h"
#import "UIColor+UmbrellaColors.h"
#import "UIIndices.h"

@interface InitialSetup ()

@property (weak, nonatomic) NSArray* ui;
@property (weak, nonatomic) BackgroundView* backgroundView;
@property (weak, nonatomic) UISegmentedControl* segmentedControl;

@property (nonatomic) BOOL keyboardWasShownAtLeastOnce;

@end

@implementation InitialSetup

- (instancetype)initWithUIElements:(NSArray*)ui
        backgroundViewConfigurator:(BackgroundView*)backgroundView {
    if ([super init]) {
        self.backgroundView = backgroundView;
        self.keyboardWasShownAtLeastOnce = NO;
        NSLog(@"%f", ((UIView*) self.ui[0]).frame.size.height);
    }
    return self;
}

- (void)performInitialSetup {
    [self.backgroundView setThemeWithIsDay:YES isClear:YES];
    [self setupSegmentedcontrol];
//    [self setupKeyboardObservers];
}

- (void)performLateSetup {
    [self.ui[CityPicker] selectRow:19 inComponent:0 animated:NO];
}

- (void)setupSegmentedcontrol {
    UIFont* font = [UIFont systemFontOfSize:16.0F];
    NSDictionary* attributes =
        [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.segmentedControl.layer.cornerRadius = 10;
    self.segmentedControl.layer.borderColor = self.segmentedControl.tintColor.CGColor;
    self.segmentedControl.layer.borderWidth = 1;
    self.segmentedControl.layer.masksToBounds = YES;
}

@end
