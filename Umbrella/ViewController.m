//
//  ViewController.m
//  Umbrella
//
//  Created by Ilia Ukhov on 9/20/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#define iOS11_or_higher \
([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
#define has_notch \
[[[UIApplication sharedApplication] delegate] window].safeAreaInsets.top > 20.0

#import "ViewController.h"
#import "View/ViewConfigurator.h"
#import "Controllers/LocationButtonHelper.h"
#import "Controllers/SearchBar.h"
#import "Controllers/ScrollView.h"
#import "Controllers/CityPicker.h"
#import "Controllers/Service.h"
#import "ForecastTypeObserver.h"

@interface ViewController ()

@property (retain, nonatomic) ViewConfigurator* viewConfigurator;
@property (retain, nonatomic) CityPicker* pickerController;
@property (retain, nonatomic) ScrollView* scrollViewController;
@property (retain, nonatomic) SearchBar* searchBarController;
@property (retain, nonatomic) Service* requestMaker;
@property (retain, nonatomic) LocationButtonHelper* locationHelper;
@property (retain, nonatomic) NSArray* forecastTypeObservers;

@property (nonatomic) BOOL keyboardWasShownAtLeastOnce;

@property (nonatomic) NSUserDefaults* sharedDefaults;
@property (retain, nonatomic) NSArray* uiElements;

@end

@implementation ViewController

@synthesize mainStackView, scrollView,
            pageIndicator, cityPicker,
            searchBar, cityLabel,
            segmentedControl, locationButton,
            viewsAboveSearchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[NSThread alloc] init] start];
    self.sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:
        @"group.mycompany.Umbrella"];
    self.uiElements = [self getUIElements];
    self.viewConfigurator = [[ViewConfigurator alloc]
        initWithUIElements:self.uiElements
        forecastType:OneDay
        sharedDefaults:self.sharedDefaults];
    self.requestMaker = [[Service alloc]
        initWithWeatherObserver:self.viewConfigurator
        viewConfigurator:self.viewConfigurator
        forecastType:OneDay];
    self.forecastTypeObservers = [[NSArray alloc]
        initWithObjects:self.viewConfigurator,
        self.requestMaker, nil];
    self.locationHelper = [[LocationButtonHelper alloc]
        initWithLocationButton:locationButton service:self.requestMaker];
    [self setupDelegates];
    [self.viewConfigurator performInitialSetup];
    self.keyboardWasShownAtLeastOnce = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [self setupKeyboardObservers];
    [self.viewConfigurator performLateSetup];
    [self loadLastSearchedCity];
}

- (void)loadLastSearchedCity {
    NSInteger lastSearchedCityId =
        [self.sharedDefaults integerForKey:@"LastSearchedCityId"];
    NSString* lastSearchedCityName =
        [self.sharedDefaults objectForKey:@"LastSearchedCityName"];
    if (lastSearchedCityId) {
        [self.viewConfigurator setCityLabelText:lastSearchedCityName];
        [self.requestMaker sendRequestWithCityId:lastSearchedCityId];
    }
}

- (void)setupDelegates {
    self.searchBarController = [SearchBar alloc];
    self.pickerController = [CityPicker alloc];
    self.searchBarController = [self.searchBarController
        initWithView:self.viewConfigurator
        cityPickerController:self.pickerController
        requestMaker:self.requestMaker];
    self.pickerController = [self.pickerController
        initWithView:self.viewConfigurator
        searchController:self.searchBarController];
    searchBar.delegate = self.searchBarController;
    cityPicker.delegate = self.pickerController;
    cityPicker.dataSource = self.pickerController;
    self.scrollViewController = [[ScrollView alloc]
        initWithView:self.viewConfigurator];
    scrollView.delegate = self.scrollViewController;
}

- (IBAction)onForecastTypeChange:(UISegmentedControl*)sender {
    ForecastType newForecastType = sender.selectedSegmentIndex == 0 ? OneDay : FourDay;
    for (NSObject<ForecastTypeObserver>* observer in self.forecastTypeObservers) {
        [observer forecastTypeChanged:newForecastType];
    }
}

- (IBAction)onAnyTapAboveKeyboard:(UITapGestureRecognizer*)sender {
    [self.searchBar resignFirstResponder];
}

- (NSArray*)getUIElements {
    return @[
             self.view
,            scrollView
,            pageIndicator
,            searchBar
,            cityPicker
,            cityLabel
,            segmentedControl
,            locationButton
    ];
}

- (void)setupKeyboardObservers {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardAppear:)
     name:UIKeyboardWillShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardDisappear:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void)onKeyboardAppear:(NSNotification*)notification {
    CGFloat keyboardHeight = [self getKeyboardHeightFrom:notification];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect raisedFrame = self.view.frame;
        raisedFrame.origin.y = -keyboardHeight;
        [self.view setFrame:raisedFrame];
    }];
    [scrollView setUserInteractionEnabled:NO];
    [locationButton setHidden:NO];
    [locationButton.layer removeAllAnimations];
    [cityPicker setHidden:NO];
}

- (void)onKeyboardDisappear:(NSNotification*)notification {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect loweredFrame = self.view.frame;
        loweredFrame.origin.y = 0.0F;
        [self.view setFrame:loweredFrame];
    }];
    [scrollView setUserInteractionEnabled:YES];
    [locationButton.layer addAnimation:[self makeDisappearAnimation] forKey:@"opacity"];
    [locationButton setHidden:YES];
    [cityPicker setHidden:YES];
}

- (CGFloat)getKeyboardHeightFrom:(NSNotification*)notification {
    CGFloat keyboardHeight = [[[notification userInfo]
        objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    if (iOS11_or_higher && has_notch) {
        if (!self.keyboardWasShownAtLeastOnce) {
            self.keyboardWasShownAtLeastOnce = true;
            return keyboardHeight;
        } else {
            return keyboardHeight + 57.5;
        }
    } else {
        return keyboardHeight;
    }
}

- (CABasicAnimation*)makeDisappearAnimation {
    CABasicAnimation* delayedAppear =
    [CABasicAnimation animationWithKeyPath:@"opacity"];
    delayedAppear.fromValue = [NSNumber numberWithFloat:1.0];
    delayedAppear.toValue = [NSNumber numberWithFloat:0.0];
    [delayedAppear setFillMode:kCAFillModeForwards];
    [delayedAppear setRemovedOnCompletion:NO];
    return delayedAppear;
}

@end
