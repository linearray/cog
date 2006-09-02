//
//  FileTreeController.h
//  Cog
//
//  Created by Vincent Spader on 8/20/2006.
//  Copyright 2006 Vincent Spader. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileTreeWatcher.h"
#import "PlaylistController.h"

@interface FileTreeController : NSTreeController
{
	IBOutlet PlaylistController *playlistController;

	NSString *rootPath;
	
	FileTreeWatcher *watcher;
}

- (id)rootPath;
- (void)setRootPath:(id)r;

@end
