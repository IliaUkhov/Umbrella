//
//  TodayViewController.h
//  Umbrella Widget
//
//  Created by Ilia Ukhov on 11/8/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *cityAndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@end
