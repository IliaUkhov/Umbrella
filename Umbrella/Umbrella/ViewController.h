//
//  ViewController.h
//  Umbrella
//
//  Created by Ilia Ukhov on 9/20/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIStackView* mainStackView;
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl* pageIndicator;
@property (weak, nonatomic) IBOutlet UIPickerView *cityPicker;
@property (weak, nonatomic) IBOutlet UILabel* cityLabel;
@property (weak, nonatomic) IBOutlet UISearchBar* searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl* segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton* locationButton;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray* viewsAboveSearchBar;

@end

