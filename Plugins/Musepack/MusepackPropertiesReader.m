//
//  MADPropertiesReader.m
//  MAD
//
//  Created by Vincent Spader on 2/24/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MusepackPropertiesReader.h"
#import "MusepackDecoder.h"

@implementation MusepackPropertiesReader

- (NSDictionary *)propertiesForURL:(NSURL *)url
{
	NSDictionary *properties;
	MusepackDecoder *decoder;
	
	decoder = [[MusepackDecoder alloc] init];
	if (![decoder open:url])
	{
		return nil;
	}
	
	properties = [decoder properties];
	
	[decoder close];
	
	return properties;
}


+ (NSArray *)fileTypes
{
	return [NSArray arrayWithObject:@"mpc"];
}

@end
