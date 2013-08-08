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
		AudioSessionInitialize(NULL, NULL, NULL, NULL);
		AudioSessionSetActive(YES);

		_initialVolume = [[MPMusicPlayerController applicationMusicPlayer] volume];

		CGRect frame = CGRectMake(0, -100, 10, 0);
		self.volumeView = [[MPVolumeView alloc] initWithFrame:frame];
		[self.volumeView sizeToFit];
		[[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self.volumeView];

		[self addAudioSession];
	}
	return self;
}

-(void) dealloc
{
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