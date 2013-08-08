//
// Created by MIYAMOTO TATSUYA on 2013/07/23.
// Copyright (c) 2013 Tatsuya Miyamoto. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import	"OCMock.h"
#import "GHTestCase.h"

#import	"NotificationNames.h"
#import "VCDVolumeChangeDetector.h"


@interface TestCaseVolumeChangeDetector : GHTestCase

- (void) testVolumeUp;

- (void) testVolumeDown;

@end