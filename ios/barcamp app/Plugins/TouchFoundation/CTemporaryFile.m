//
//  CTemporaryFile.m
//  TouchCode
//
//  Created by Jonathan Wight on 12/29/08.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this list of
//        conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice, this list
//        of conditions and the following disclaimer in the documentation and/or other materials
//        provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY JONATHAN WIGHT ``AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JONATHAN WIGHT OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of toxicsoftware.com.

#import "CTemporaryFile.h"

#include <unistd.h>

@interface CTemporaryFile ()
@property (readwrite, nonatomic, retain) NSURL *URL;
@property (readwrite, nonatomic, assign) int fileDescriptor;
@end

#pragma mark -

@implementation CTemporaryFile

@synthesize deleteOnDealloc;
@synthesize prefix;
@synthesize suffix;
@synthesize URL;
@synthesize fileDescriptor;
@synthesize fileHandle;

+ (NSString *)temporaryDirectory
    {
    return(NSTemporaryDirectory());
    }

+ (CTemporaryFile *)tempFile
    {
    return([[[self alloc] init] autorelease]);
    }

- (id)init
{
if ((self = [super init]) != NULL)
	{
	deleteOnDealloc = YES;
	fileDescriptor = -1;
	}
return(self);
}

- (void)dealloc
    {
	[self close];

    if (deleteOnDealloc == YES && URL != NULL)
        {
        // Try and delete the file. But dont stress if it fails. JIWTODO - maybe log this?
        [[NSFileManager defaultManager] removeItemAtURL:self.URL error:NULL];
        }

    [suffix release];
    suffix = NULL;

    [URL release];
    URL = NULL;
    //
    [super dealloc];
    }

#pragma mark -

- (NSURL *)URL
    {
    if (URL == NULL)
        {
        [self create];
        }
    return(URL);
    }

- (int)fileDescriptor
    {
    if (fileDescriptor == -1)
        {
        [self create];
        }
    return(fileDescriptor);
    }

- (NSFileHandle *)fileHandle
    {
    if (fileHandle == NULL)
        {
        fileHandle = [[NSFileHandle alloc] initWithFileDescriptor:self.fileDescriptor closeOnDealloc:YES];
        }
    return(fileHandle);
    }

#pragma mark -

- (void)create
    {
    // JIWTODO use a better (user supplied?) template
    NSString *theTemplate = [[[self class] temporaryDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", self.prefix ?: @"", @"XXXXXXXXXXXXXXXXXXXXXXXXXXX"]];
    if (self.suffix)
        theTemplate = [theTemplate stringByAppendingString:self.suffix];

    char theBuffer[theTemplate.length + 1];
    strncpy(theBuffer, [theTemplate UTF8String], theTemplate.length + 1);
    self.fileDescriptor = mkstemps(theBuffer, (int)self.suffix.length);
    self.URL = [NSURL fileURLWithPath:[NSString stringWithUTF8String:theBuffer]];
    }


- (void)close
	{
	if (fileHandle > 0)
		{
        [fileHandle synchronizeFile];
        [fileHandle closeFile];
        [fileHandle release];
        fileHandle = nil;
		}
	
    fileDescriptor = -1;
	}

@end
