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

- (void) setUp
{
	volumeChangeDetector = [VCDVolumeChangeDetector new];
	initialVolume = [volumeChangeDetector initialVolume];
}

- (void) tearDown
{
	volumeChangeDetector = nil;
}

- (void) testVolumeDown
{
	[self prepare];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(volumeDownDetect:)
												 name:kVolumeDownButtonDidPush
											   object:nil];
	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
}

- (void) volumeDownDetect :(NSNotification *)notification
{
	float modifiedVolume = [MPMusicPlayerController applicationMusicPlayer].volume;

	DLog(@"volume init mod : %f : %f", initialVolume, modifiedVolume);

	@try
	{
		GHAssertEquals(initialVolume, modifiedVolume, @"一致するはず");
		[self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVolumeDown)];
	} @catch (NSException *exception1)
	{
		[self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVolumeDown)];
	} @finally{
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:kVolumeDownButtonDidPush
													  object:nil];
	}
}

- (void) testVolumeUp
{
	[self prepare];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(volumeUpDetect:)
												 name:kVolumeUpButtonDidPush
											   object:nil];
	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];

}

- (void) volumeUpDetect :(NSNotification *)notification
{
	float modifiedVolume = [MPMusicPlayerController applicationMusicPlayer].volume;

	DLog(@"volume init mod : %f : %f", initialVolume, modifiedVolume);

	@try
	{
		GHAssertEquals(initialVolume, modifiedVolume, @"一致するはず");
		[self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testVolumeUp)];
	} @catch (NSException *exception1)
	{
		[self notify:kGHUnitWaitStatusFailure forSelector:@selector(testVolumeUp)];
	} @finally{
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:kVolumeUpButtonDidPush
													  object:nil];
	}
}


@end