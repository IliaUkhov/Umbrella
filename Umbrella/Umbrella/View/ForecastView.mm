//
//  ForecastView.m
//  Umbrella
//
//  Created by Ilia Ukhov on 11/5/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForecastView.h"
#import "ViewConfigurator.h"
#import "WeatherInfoLabel.h"
#import "UIIndices.h"

#include <string>
#include <unordered_set>

@interface ForecastView ()

@property (weak, nonatomic) UIScrollView* scrollView;
@property (weak, nonatomic) ViewConfigurator* viewConfigurator;
@property (weak, nonatomic) BackgroundView* backgroundView;

@property (nonatomic) NSDictionary* pictureDictionary;
@property (nonatomic) NSSet* cloudyWeatherList;

@property (nonatomic) std::vector<bool>* is_day_list;
@property (nonatomic) std::vector<bool>* is_clear_list;

@property (nonatomic) CGFloat weatherPageHeight;
@property (nonatomic) NSUserDefaults* sharedDefaults;

@end

@implementation ForecastView

- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                  viewConfigurator:(ViewConfigurator*)viewConfigurator
                    backgroundView:(BackgroundView*)backgroundView
                 pictureDictionary:(NSDictionary*)pictures
                    sharedDefaults:(NSUserDefaults*)sharedDefaults{
    if ([super init]) {
        self.scrollView = scrollView;
        self.viewConfigurator = viewConfigurator;
        self.backgroundView = backgroundView;
        self.pictureDictionary = pictures;
        self.cloudyWeatherList = [self getCloudyWeatherList];
        self.is_day_list = new std::vector<bool>(8, YES);
        self.is_clear_list = new std::vector<bool>(8, YES);
        self.weatherPageHeight = 170 + self.scrollView.frame.size.width * 0.64;
        self.sharedDefaults = sharedDefaults;
    }
    return self;
}

- (void)dealloc {
    delete self.is_day_list;
    delete self.is_clear_list;
}

- (void)showNewShortForecast:(weather::short_forecast)entries {
    CGFloat pageViewOffset = 0;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [self setupIsDayAndIsClearForShortForecast:entries calendar:calendar];
    BOOL begin = true;
    for (auto entry : *entries) {
        NSLog(@"%s", entry->description().c_str());
        UIView* weatherPage = [self makeWeatherPageWithXOffset:pageViewOffset];
        [self.scrollView addSubview:weatherPage];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:entry->date()];
        NSInteger hours = [calendar component:NSCalendarUnitHour fromDate:date];
        NSString* imageName = [self choosePictureWithDescription:
            [NSString stringWithUTF8String:entry->description().c_str()] timeHours:hours];
        UIImage* image = [UIImage imageNamed:imageName];
        if (begin) { [self updateWidgetPicture:imageName]; begin = false; }
        [self setWeatherPicture:image into:weatherPage];
        [self setupLabelsForShortForecastWithWeatherPage:weatherPage info:entry];
        pageViewOffset += self.scrollView.frame.size.width;
    }
    [self finishSetupScrollViewWithPageCount:entries->size()];
}

- (void)showNewLongForecast:(weather::long_forecast)entries {
    CGFloat pageViewOffset = 0;
    [self setupIsDayAndIsClearForLongForecast:entries];
    BOOL begin = true;
    for (auto entry : *entries) {
        NSLog(@"%s", entry->description().c_str());
        UIView* weatherPage = [self makeWeatherPageWithXOffset:pageViewOffset];
        [self.scrollView addSubview:weatherPage];
        NSString* imageName = [self choosePictureWithDescription:
            [NSString stringWithUTF8String:entry->description().c_str()] timeHours:12];
        UIImage* image = [UIImage imageNamed:imageName];
        if (begin) { [self updateWidgetPicture:imageName]; begin = false; }
        [self setWeatherPicture:image into:weatherPage];
        [self setupLabelsForLongForecastWithWeatherPage:weatherPage info:entry];
        pageViewOffset += self.scrollView.frame.size.width;
    }
    [self finishSetupScrollViewWithPageCount:entries->size()];
}

- (UIView*)makeWeatherPageWithXOffset:(CGFloat)xOffset {
    UIView* weatherPage = [[UIView alloc] init];
    weatherPage.frame = CGRectMake(
        xOffset,
        (self.scrollView.frame.size.height - self.weatherPageHeight) / 2 - 10,
        self.scrollView.frame.size.width,
        self.weatherPageHeight
    );
    return weatherPage;
}

- (void)setWeatherPicture:(UIImage*)image into:(UIView*)view {
    CGSize frameSize = view.frame.size;
    UIImageView* weatherPictureView = [[UIImageView alloc] initWithImage:image];
    weatherPictureView.frame = CGRectMake(
        0, 0, frameSize.width, frameSize.width * 0.64
    );
    [view addSubview:weatherPictureView];
}

- (void)setLabelsIntoPage:(UIView*)page withTexts:(NSArray*)texts {
    CGSize frameSize = page.frame.size;
    CGFloat width = frameSize.width - 60;
    CGFloat pictureHeight = frameSize.width * 0.64;
    UILabel* dateLabel = [[WeatherInfoLabel alloc] initWithFrame:
        CGRectMake(30, pictureHeight, width, 50)];
    dateLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    UILabel* temperatureLabel = [[WeatherInfoLabel alloc] initWithFrame:
        CGRectMake(30, pictureHeight + 50, width, 40)];
    UILabel* humidityLabel = [[WeatherInfoLabel alloc] initWithFrame:
        CGRectMake(30, pictureHeight + 90, width, 40)];
    UILabel* windSpeedLabel = [[WeatherInfoLabel alloc] initWithFrame:
        CGRectMake(30, pictureHeight + 130, width, 40)];
    NSArray* labels = @[dateLabel, temperatureLabel, humidityLabel, windSpeedLabel];
    for (NSInteger i = 0; i < labels.count; ++i) {
        [page addSubview: labels[i]];
        [labels[i] setText:texts[i]];
    }
}

- (void)setupLabelsForShortForecastWithWeatherPage:(UIView*)page info:(weather::weather*)info {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"h:mm a";
    NSString* date = [dateFormatter stringFromDate:
        [NSDate dateWithTimeIntervalSince1970:info->date()]];
    NSString* temperature = [NSString stringWithFormat:
        @"Temperature: %d °C", (int) round(info->temperature() - 273.15)];
    NSString* humidity = [NSString stringWithFormat:
        @"Humidity: %d%%", (int) round(info->humidity())];
    NSString* windSpeed = [NSString stringWithFormat:
        @"Wind speed: %.1f m/s", info->wind_speed()];
    [self setLabelsIntoPage:page withTexts:@[date, temperature, humidity, windSpeed]];
    [self updateWidgetTime:date temperature:[temperature substringFromIndex:13]];
}

- (void)setupLabelsForLongForecastWithWeatherPage:(UIView*)page info:(weather::day_weather*)info {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE, MMMM d";
    NSString* date = [dateFormatter stringFromDate:
        [NSDate dateWithTimeIntervalSince1970:info->date()]];
    auto t_range = info->temperature_range();
    NSString* temperature = [NSString stringWithFormat:
        @"Temperature: from %d to %d °C",
        (int) round(t_range.first - 273.15),
        (int) round(t_range.second - 273.15)];
    auto h_range = info->humidity_range();
    NSString* humidity = [NSString stringWithFormat:
        @"Humidity: from %d to %d%%", (int) round(h_range.first), (int) round(h_range.second)];
    auto w_range = info->wind_speed_range();
    NSString* windSpeed = [NSString stringWithFormat:
        @"Wind speed: from %.1f to %.1f m/s", w_range.first, w_range.second];
    [self setLabelsIntoPage:page withTexts:@[date, temperature, humidity, windSpeed]];
    [self updateWidgetTime:date temperature:[temperature substringFromIndex:13]];
}

- (void)finishSetupScrollViewWithPageCount:(NSUInteger)pageCount {
    self.scrollView.contentSize = CGSizeMake(
        self.scrollView.frame.size.width * pageCount,
        self.scrollView.frame.size.height
    );
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.viewConfigurator setPagesCount:pageCount];
    [self.viewConfigurator setCurrentPage:0];
}

- (NSString*)choosePictureWithDescription:(NSString*)description timeHours:(NSInteger)hours {
    NSString* suffix = hours < 4 || hours > 19 ? @"Night" : @"Day";
    NSString* copy = [self removeMostly:description];
    NSString* imageName = self.pictureDictionary[copy];
    return imageName != nil
        ? [NSString stringWithFormat:@"%@%@", imageName, suffix]
        : [NSString stringWithFormat:@"ClearSky%@", suffix];
}

- (NSString*)removeMostly:(NSString*)description {
    if ([description containsString:@"mostly "]) {
        return [description substringFromIndex:7];
    } else return description;
}

- (void)setLabelsTexts:(NSArray*)labels texts:(NSArray*)texts {
    for (int i = 0; i < labels.count; ++i) {
        [labels[i] setText:texts[i]];
    }
}

- (void)setupIsDayAndIsClearForShortForecast:(weather::short_forecast)entries calendar:(NSCalendar*)calendar {
    [self resetIsDayAndIsClear];
    short page = 0;
    for (auto entry : *entries) {
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:entry->date()];
        NSInteger hours = [calendar component:NSCalendarUnitHour fromDate:date];
        if (hours < 4 || hours > 19) {
            self.is_day_list->at(page) = NO;
        }
        if ([self.cloudyWeatherList containsObject: [self removeMostly:
                [NSString stringWithUTF8String:entry->description().c_str()]]]) {
            self.is_clear_list->at(page) = NO;
        }
        ++page;
    }
}

- (void)setupIsDayAndIsClearForLongForecast:(weather::long_forecast)entries {
    [self resetIsDayAndIsClear];
    short page = 0;
    for (auto entry : *entries) {
        if ([self.cloudyWeatherList containsObject: [self removeMostly:
                [NSString stringWithUTF8String:entry->description().c_str()]]]) {
            self.is_clear_list->at(page) = NO;
        }
        ++page;
    }
}

- (void)setupThemeWithPage:(NSUInteger)page {
    [self.backgroundView setThemeWithIsDay:self.is_day_list->at(page) isClear:self.is_clear_list->at(page)];
}

- (void)updateWidgetTime:(NSString*)time temperature:(NSString*)temperature {
    [self.sharedDefaults setObject:time forKey:@"Time"];
    [self.sharedDefaults setObject:temperature forKey:@"Temperature"];
}

- (void)updateWidgetPicture:(NSString*)pictureName {
    [self.sharedDefaults setObject:pictureName forKey:@"Picture"];
}

- (void)resetIsDayAndIsClear {
    std::fill(self.is_day_list->begin(), self.is_day_list->end(), YES);
    std::fill(self.is_clear_list->begin(), self.is_clear_list->end(), YES);
}

- (NSSet*)getCloudyWeatherList {
    return [NSSet setWithObjects:
            @"broken clouds",
            @"light rain",
            @"moderate rain",
            @"heavy intensity rain",
            @"hail",
            nil];
}

@end
