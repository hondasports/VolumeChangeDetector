//
// Created by MIYAMOTO TATSUYA on 2013/07/24.
// Copyright (c) 2013 Tatsuya Miyamoto. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import	<AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

#import	"NotificationNames.h"

@interface VCDVolumeChangeDetector : NSObject

@property (readonly) float initialVolume;

-(void) volumeDown;
-(void) volumeUp;

@end