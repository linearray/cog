//
//  PlaylistLoader.h
//  Cog
//
//  Created by Vincent Spader on 3/05/07.
//  Copyright 2007 Vincent Spader All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PlaylistController;

typedef enum {
	kPlaylistM3u,
	kPlaylistPls,
} PlaylistType;

@interface PlaylistLoader : NSObject {
	IBOutlet PlaylistController *playlistController;
}

//load arrays of urls...
- (void)addURLs:(NSArray *)urls sort:(BOOL)sort;
- (void)addURL:(NSURL *)url;
- (void)insertURLs:(NSArray *)urls atIndex:(int)index sort:(BOOL)sort;

//load playlist auto-determines type to be either pls or m3u.
- (NSArray *)urlsFromPlaylist:(NSString *)filename;
- (NSArray *)urlsFromM3u:(NSString *)filename;
- (NSArray *)urlsFromPls:(NSString *)filename;

//save playlist, auto-determines type based on extension. Uses m3u if it cannot be determined.
- (BOOL)save:(NSString *)filename;
- (BOOL)save:(NSString *)filename asType:(PlaylistType)type;
- (BOOL)saveM3u:(NSString *)filename;
- (BOOL)savePls:(NSString *)filename;

- (NSArray *)acceptableFileTypes;
- (NSArray *)acceptablePlaylistTypes;

@end