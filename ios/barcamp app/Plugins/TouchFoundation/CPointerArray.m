//
//  CPointerArray.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/10/08.
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

#import "CPointerArray.h"

// WithOptions:NSPointerFunctionsZeroingWeakMemory | NSPointerFunctionsObjectPersonality

@interface CPointerArray ()

@property (readwrite, nonatomic, assign) void **buffer;

@end

@implementation CPointerArray


- (id)init
{
if ((self = [super init]) != NULL)
	{
	count = 0;
	buffer = NULL;
	}
return(self);
}

- (void)dealloc
{
self.buffer = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSUInteger)count
{
return(count);
}

- (void)setCount:(NSUInteger)inCount
{
if (count != inCount)
	{
	const NSUInteger theOldCount = count;
	const size_t theOldSize = sizeof(void *) * theOldCount;
	const size_t theNewSize = sizeof(void *) * inCount;
	void **theNewBuffer = NULL;
	if (theOldSize == 0)
		theNewBuffer = malloc(theNewSize);
	else
		theNewBuffer = realloc(self.buffer, theNewSize);

	if (theNewBuffer == NULL)
		[NSException raise:NSMallocException format:@"realloc failed trying to allocate %d bytes, (errno: %d)", theNewSize, errno];

	if (theNewSize > theOldSize)
		memset(theNewBuffer + theOldCount, 0, theNewSize - theOldSize);

	buffer = theNewBuffer;
	count = inCount;
	}
}

- (void **)buffer
{
if (buffer == NULL && self.count > 0)
	{
	const size_t theSize = sizeof(void *) * self.count;
	void **theNewBuffer = malloc(theSize);
	memset(theNewBuffer, 0, theSize);

	if (theNewBuffer == NULL)
		[NSException raise:NSMallocException format:@"-[CPointerArray buffer] malloc failed trying to allocate %d bytes, (errno: %d)", theSize, errno];

	buffer = theNewBuffer;
	}
return(buffer);
}

- (void)setBuffer:(void **)inBuffer
{
if (buffer != inBuffer)
	{
	buffer = inBuffer;
	//
	if (buffer == NULL)
		self.count = 0;
	}
}

#pragma mark -

- (void *)pointerAtIndex:(NSUInteger)inIndex;
{
if (inIndex > count - 1)
	[NSException raise:NSRangeException format:@"-[CPointerArray pointerAtIndex:] inIndex (%d) is greater than count (%d) - 1", inIndex, count];
return(buffer[inIndex]);
}

- (void)addPointer:(void *)inPointer
{
self.count += 1;
self.buffer[self.count - 1] = inPointer;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
const NSUInteger theStartIndex = state->state;
const NSUInteger theCount = MIN(self.count - theStartIndex, len);

if (theCount > 0)
	state->itemsPtr = (id *)&buffer[theStartIndex];
else
	state->itemsPtr = NULL;

state->state = theStartIndex + theCount;
state->mutationsPtr = (unsigned long *)&buffer;

return(theCount);
}

@end
