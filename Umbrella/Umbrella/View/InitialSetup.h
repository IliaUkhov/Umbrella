//
//  InitialSetup.h
//  Umbrella
//
//  Created by Ilia Ukhov on 10/27/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#ifndef InitialSetup_h
#define InitialSetup_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BackgroundView.h"

@interface InitialSetup : NSObject

- (instancetype)initWithUIElements:(NSArray*)ui
        backgroundViewConfigurator:(BackgroundView*)backgroundView;

- (void)performInitialSetup;

- (void)performLateSetup;

@end

#endif /* InitialSetup_h */
