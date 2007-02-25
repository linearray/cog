/* PlaybackController */

#import <Cocoa/Cocoa.h>

#import "CogAudio/AudioPlayer.h"
#import "PlaylistController.h"
#import "TrackingSlider.h"
#import "AudioScrobbler.h"

@class PlaylistView;

@interface PlaybackController : NSObject
{
    IBOutlet PlaylistController *playlistController;
	IBOutlet PlaylistView *playlistView;
	
	IBOutlet TrackingSlider *positionSlider;
	IBOutlet NSSlider *volumeSlider;
	IBOutlet NSTextField *timeField;
	IBOutlet NSTextField *lengthField;
	IBOutlet NSTextField *bitrateField;
	
	IBOutlet NSButton *playButton;
	
	IBOutlet NSArrayController *outputDevices;
	
	NSTimer *positionTimer;
		
	BOOL waitingForPlay; //No sneaky changing on us
	AudioPlayer *audioPlayer;
	
	int playbackStatus;
	
	double currentVolume;
	
	BOOL showTimeRemaining;
	
	AudioScrobbler *scrobbler;
 }

- (IBAction)toggleShowTimeRemaining:(id)sender;
- (IBAction)changeVolume:(id)sender;

- (IBAction)volumeDown:(id)sender;
- (IBAction)volumeUp:(id)sender;

- (IBAction)playPauseResume:(id)sender;
- (IBAction)pauseResume:(id)sender;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)resume:(id)sender;
- (IBAction)stop:(id)sender;

- (IBAction)next:(id)sender;
- (IBAction)prev:(id)sender;
- (IBAction)seek:(id)sender;


- (void)updateTimeField:(double)pos;

- (void)playEntryAtIndex:(int)i;
- (void)playEntry:(PlaylistEntry *)pe;

@end