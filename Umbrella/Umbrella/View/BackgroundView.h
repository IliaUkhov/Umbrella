//
//  BackgroundView.h
//  Umbrella
//
//  Created by Ilia Ukhov on 11/4/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#ifndef BackgroundView_h
#define BackgroundView_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BackgroundView : NSObject

- (instancetype)initWithMainView:(UIView*)view;

- (void)setThemeWithIsDay:(BOOL)isDay isClear:(BOOL)isClear;

@end

#endif /* BackgroundView_h */
