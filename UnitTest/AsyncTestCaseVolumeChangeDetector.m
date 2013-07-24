//
// Created by MIYAMOTO TATSUYA on 2013/07/24.
// Copyright (c) 2013 Tatsuya Miyamoto. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AsyncTestCaseVolumeChangeDetector.h"

@implementation AsyncTestCaseVolumeChangeDetector
{
	float initialVolume;
	VCDVolumeChangeDetector *volumeChangeDetector;
}

-(void) setUp
{
	volumeChangeDetector = [VCDVolumeChangeDetector new];
	initialVolume = [volumeChangeDetector initialVolume];
}

-(void) tearDown
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kVolumeDownButtonDidPush
												  object:nil];
}

-(void) testVolumeDown
{
	[self prepare];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(volumeChangeDetect:)
												 name:kVolumeDownButtonDidPush
											   object:nil];
	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

-(void) volumeChangeDetect :(NSNotification *)notification
{
	@try{
		[self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVolumeDown)];
	} @catch (NSException *exception1){

	}
}

-(void) testVolumeUp
{
}

@end