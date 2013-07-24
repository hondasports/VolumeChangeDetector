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
	[vcdVolumeChangeDetector volumeDown];
}


-(id) init
{
	self = [super init];
	if(self){
		AudioSessionInitialize(NULL, NULL, NULL, NULL);
		AudioSessionSetActive(YES);

		_initialVolume = [[MPMusicPlayerController applicationMusicPlayer] volume];

		DLog(@"initialVolume %f", _initialVolume);

		AudioSessionAddPropertyListener(
				kAudioSessionProperty_CurrentHardwareOutputVolume,
				volumeChangeListenerCallback,
				(__bridge void *)self);
	}
	return self;
}

-(void) dealloc
{
	AudioSessionSetActive(NO);
	AudioSessionRemovePropertyListenerWithUserData(
			kAudioSessionProperty_CurrentHardwareOutputVolume,
			volumeChangeListenerCallback,
			(__bridge void *)self);
}

-(void) volumeDown
{
	AudioSessionRemovePropertyListenerWithUserData(
			kAudioSessionProperty_CurrentHardwareOutputVolume,
			volumeChangeListenerCallback,
			(__bridge void *)self);
	[MPMusicPlayerController applicationMusicPlayer].volume = _initialVolume;
	[[NSNotificationCenter defaultCenter] postNotificationName:kVolumeDownButtonDidPush object:self];
}

-(void) volumeUp
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kVolumeUpButtonDidPush object:self];
}

@end