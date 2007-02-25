//
//  MusepackFile.m
//  zyVorbis
//
//  Created by Vincent Spader on 1/23/05.
//  Copyright 2005 Vincent Spader All rights reserved.
//

#import "MusepackDecoder.h"

@implementation MusepackDecoder

- (BOOL)open:(NSURL *)url
{
	NSLog(@"Decoder opening...$@", url);
	inFd = fopen([[url path] UTF8String], "rb");
	if (inFd == 0)
		return NO;
	
	mpc_reader_setup_file_reader(&reader , inFd);

    mpc_streaminfo_init(&info);
    if (mpc_streaminfo_read(&info, &reader.reader) != ERROR_CODE_OK)
	{
        NSLog(@"Not a valid musepack file.");
        return NO;
    }
	
	/* instantiate a decoder with our file reader */
	mpc_decoder_setup(&decoder, &reader.reader);
	if (!mpc_decoder_initialize(&decoder, &info))
	{
		NSLog(@"Error initializing decoder.");
		return NO;
	}
	

	bitrate = (int)(info.average_bitrate/1000.0);
	frequency = info.sample_freq;
		
	length = ((double)mpc_streaminfo_get_length_samples(&info)*1000.0)/frequency;	

	NSLog(@"Length: %lf", length);
	return YES;
}

- (BOOL)writeSamplesToBuffer:(uint16_t *)sample_buffer fromBuffer:(const MPC_SAMPLE_FORMAT *)p_buffer ofSize:(unsigned)p_size
{
	unsigned n;
	int m_bps = 16;
	int clip_min = - 1 << (m_bps - 1),
		clip_max = (1 << (m_bps - 1)) - 1,
		float_scale = 1 << (m_bps - 1);

	for (n = 0; n < p_size; n++)
	{
		int val;
#ifdef MPC_FIXED_POINT
		val = shift_signed( p_buffer[n], m_bps - MPC_FIXED_POINT_SCALE_SHIFT );			
#else
		val = (int)( p_buffer[n] * float_scale );
#endif
		
		if (val < clip_min)
			val = clip_min;
		else if (val > clip_max)
			val = clip_max;

//		sample_buffer[n] = CFSwapInt16LittleToHost(val);
		sample_buffer[n] = val;
	}

//	m_data_bytes_written += p_size * (m_bps >> 3);
	return YES;
}

- (int)fillBuffer:(void *)buf ofSize:(UInt32)size
{
	int numread = bufferAmount;
	int count = 0;
    MPC_SAMPLE_FORMAT sampleBuffer[MPC_DECODER_BUFFER_LENGTH];

	//Fill from buffer, going by bufferAmount
	//if still needs more, decode and repeat
	if (bufferAmount == 0)
	{
		/* returns the length of the samples*/

		unsigned status = mpc_decoder_decode(&decoder, sampleBuffer, 0, 0);
		if (status == (unsigned)( -1))
		{
			//decode error
			NSLog(@"Decode error");
			return 0;
		}
		else if (status == 0) //EOF
		{
			return 0;
		}
		else //status>0 /* status == MPC_FRAME_LENGTH */
		{
			[self writeSamplesToBuffer:((uint16_t*)buffer)  fromBuffer:sampleBuffer ofSize:(status*2)];
		}
		
		bufferAmount = status*4;
	}

	count = bufferAmount;
	if (bufferAmount > size)
	{
		count = size;
	}

	memcpy(buf, buffer, count);

	bufferAmount -= count;

	if (bufferAmount > 0)
		memmove(buffer, &buffer[count], bufferAmount);

	if (count < size)
		numread = [self fillBuffer:(&((char *)buf)[count]) ofSize:(size - count)];
	else
		numread = 0;

	return count + numread;
}

- (void)close
{
	fclose(inFd);
}

- (double)seekToTime:(double)milliseconds
{
	mpc_decoder_seek_sample(&decoder, frequency*((double)milliseconds/1000.0));
	
	return milliseconds;
}

- (NSDictionary *)properties
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithInt:bitrate], @"bitrate",
		[NSNumber numberWithFloat:frequency], @"sampleRate",
		[NSNumber numberWithDouble:length], @"length",
		[NSNumber numberWithInt:16], @"bitsPerSample",
		[NSNumber numberWithInt:2], @"channels",
		@"little",@"endian",
		nil];
}

+ (NSArray *)fileTypes
{
	return [NSArray arrayWithObject:@"mpc"];
}


@end