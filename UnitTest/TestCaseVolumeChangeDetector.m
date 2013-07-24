//
// Created by MIYAMOTO TATSUYA on 2013/07/23.
// Copyright (c) 2013 Tatsuya Miyamoto. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "TestCaseVolumeChangeDetector.h"

@implementation TestCaseVolumeChangeDetector
{
	id mock;
	VCDVolumeChangeDetector *volumeChangeDetector;
}

-(void) setUp
{
	mock = [OCMockObject observerMock];
	volumeChangeDetector = [VCDVolumeChangeDetector new];
}

-(void) tearDown
{
	[[NSNotificationCenter defaultCenter] removeObserver:mock name:kVolumeDownButtonDidPush object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:mock name:kVolumeUpButtonDidPush object:nil];
}

-(void) testInit
{
}

-(void) testVolumeDown
{
	[[NSNotificationCenter defaultCenter] addMockObserver:mock name:kVolumeDownButtonDidPush object:nil];
	[[mock expect] notificationWithName:kVolumeDownButtonDidPush object:[OCMArg any]];

	[volumeChangeDetector volumeDown];
	[mock verify];
}

-(void) testVolumeUp
{
	[[NSNotificationCenter defaultCenter] addMockObserver:mock name:kVolumeUpButtonDidPush object:nil];
	[[mock expect] notificationWithName:kVolumeUpButtonDidPush object:[OCMArg any]];

	[volumeChangeDetector volumeUp];
	[mock verify];
}
@end