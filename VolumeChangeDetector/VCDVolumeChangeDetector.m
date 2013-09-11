//
// Created by MIYAMOTO TATSUYA on 2013/07/24.
// Copyright (c) 2013 Tatsuya Miyamoto. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "VCDVolumeChangeDetector.h"

@implementation VCDVolumeChangeDetector
{

}


void volumeChangeListenerCallback (
		void                      *inClientData,
		AudioSessionPropertyID    inID,
		UInt32                    inDataSize,
		const void                *inData
);

void volumeChangeListenerCallback (
		void                      *inClientData,
		AudioSessionPropertyID    inID,
		UInt32                    inDataSize,
		const void                *inData
){
	const float *volumePointer = inData;
	float volume = *volumePointer;

	VCDVolumeChangeDetector *vcdVolumeChangeDetector = (__bridge VCDVolumeChangeDetector *)inClientData;

	DLog(@"current [%f] init [%f] ", volume, vcdVolumeChangeDetector.initialVolume);

	if(volume < vcdVolumeChangeDetector.initialVolume){
		[vcdVolumeChangeDetector volumeDown];
	} else if (volume > vcdVolumeChangeDetector.initialVolume){
		[vcdVolumeChangeDetector volumeUp];
	}
}


-(id) init
{
	self = [super init];
	if(self){
		[self initializeAudioSession];

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationDidBecomeActiveNotification:)
													 name:UIApplicationDidBecomeActiveNotification
												   object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationDidEnterBackgroundNotification:)
													 name:UIApplicationDidEnterBackgroundNotification
												   object:nil];

	}
	return self;
}

- (void) initializeAudioSession
{
	AudioSessionInitialize(NULL, NULL, NULL, NULL);
	AudioSessionSetActive(YES);

	_initialVolume = [[MPMusicPlayerController applicationMusicPlayer] volume];

	CGRect frame = CGRectMake(0, -100, 10, 0);
	self.volumeView = [[MPVolumeView alloc] initWithFrame:frame];
	[self.volumeView sizeToFit];
	[[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self.volumeView];

	[self addAudioSession];
}

-(void)applicationDidBecomeActiveNotification:(NSNotification *)notification{
	[self initializeAudioSession];
	DLog("applicationDidBecomeActiveNotification");
}

-(void)applicationDidEnterBackgroundNotification:(NSNotification *)notification{
	DLog("applicationDidEnterBackgroundNotification");
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidBecomeActiveNotification
												  object:nil];

	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidEnterBackgroundNotification
												  object:nil];

	[self removeAudioSession];
	AudioSessionSetActive(NO);
}

-(void) volumeDown
{
	[self removeAudioSession];
	[self revertVolumeToInitial];
	[self addAudioSession];

	[self postNotification:kVolumeDownButtonDidPush];
}

-(void) volumeUp
{
	[self removeAudioSession];
	[self revertVolumeToInitial];
	[self addAudioSession];

	[self postNotification:kVolumeUpButtonDidPush];
}

- (void) addAudioSession
{
	AudioSessionAddPropertyListener(
			kAudioSessionProperty_CurrentHardwareOutputVolume,
			volumeChangeListenerCallback,
			(__bridge void *)self);
}

- (void) removeAudioSession
{
	AudioSessionRemovePropertyListenerWithUserData(
			kAudioSessionProperty_CurrentHardwareOutputVolume,
			volumeChangeListenerCallback,
			(__bridge void *)self);
}

- (void) revertVolumeToInitial
{
	[MPMusicPlayerController applicationMusicPlayer].volume = _initialVolume;
}

- (void) postNotification:(NSString *)notificationName
{
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
}

@end