//
//  ScrollView.m
//  Umbrella
//
//  Created by Ilia Ukhov on 10/9/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#import "ScrollView.h"

@interface ScrollView ()

@property (weak, nonatomic) ViewConfigurator* viewConfigurator;

@end

@implementation ScrollView

- (instancetype)initWithView:(ViewConfigurator*)viewConfigurator {
    if ([super init]) {
        self.viewConfigurator = viewConfigurator;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [self.viewConfigurator setCurrentPage:[self getCurrentPageIndex:scrollView]];
}

- (NSInteger)getCurrentPageIndex:(UIScrollView*)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float scrollPosition = scrollView.contentOffset.x / pageWidth;
    return roundf(scrollPosition);
}

@end
