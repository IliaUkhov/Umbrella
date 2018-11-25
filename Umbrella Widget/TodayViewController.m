//
//  TodayViewController.m
//  Umbrella Widget
//
//  Created by Ilia Ukhov on 11/8/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic) NSUserDefaults* sharedDefaults;
@property (nonatomic) NSString* displayedTime;

@end

@implementation TodayViewController

@synthesize imageView, cityAndTimeLabel, temperatureLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sharedDefaults =
        [[NSUserDefaults alloc] initWithSuiteName:@"group.mycompany.Umbrella"];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void(^)(NCUpdateResult))completionHandler {
    NSLog(@"widget change");
    NSString* time = [self.sharedDefaults objectForKey:@"Time"];
    if ([time isEqualToString:self.displayedTime]) {
        completionHandler(NCUpdateResultNoData);
        return;
    }
    NSString* description = [self.sharedDefaults valueForKey:@"Description"];
    if ([description isEqualToString:@"empty"]) {
        [cityAndTimeLabel setText:@"No connection"];
        [temperatureLabel setText:@""];
    } else {
        self.displayedTime = time;
        [self setupLabels];
    }
}

- (void)setupLabels {
    NSString* city = [self.sharedDefaults objectForKey:@"City"];
    NSString* time = [self.sharedDefaults objectForKey:@"Time"];
    [self.cityAndTimeLabel setText:[NSString stringWithFormat:@"%@%@", city, time]];
    [self.temperatureLabel setText:[self.sharedDefaults objectForKey:@"Temperature"]];
}

@end
