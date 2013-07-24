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

-(id) init
{
	self = [super init];
	if(self){

	}
	return self;
}

-(void) volumeDown
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kVolumeDownButtonDidPush object:self];
}

-(void) volumeUp
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kVolumeUpButtonDidPush object:self];
}

@end