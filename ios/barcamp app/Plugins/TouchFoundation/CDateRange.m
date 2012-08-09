//
//  CDateRange.m
//  TouchCode
//
//  Created by Jonathan Wight on 5/15/09.
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

#import "CDateRange.h"

#import "NSDate_Extensions.h"

@interface CDateRange ()
@property (readwrite, nonatomic, retain) NSDate *start;
@property (readwrite, nonatomic, retain) NSDate *end;
@end

#pragma mark -

@implementation CDateRange

@synthesize start;
@synthesize end;

- (id)initWithStart:(NSDate *)inStart end:(NSDate *)inEnd;
{
if ((self = [super init]) != NULL)
	{
	self.start = inStart;
	self.end = inEnd;
	}
return(self);
}

- (void)dealloc
{
self.start = NULL;
self.end = NULL;
//
[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
return([[CDateRange alloc] initWithStart:self.start end:self.end]);
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
return([[CMutableDateRange alloc] initWithStart:self.start end:self.end]);
}

#pragma mark -

- (NSTimeInterval)duration;
{
return([self.end timeIntervalSinceDate:self.start]);
}

- (NSString *)formattedString
{
if ([self.start isSameCalendarDayAsDate:self.end] == YES)
	{
	// Dec 25, 10:30 AM - 11:00 AM
	return([NSString stringWithFormat:@"%@, %@ - %@",
		[self.start stringWithFormat:@"MMM d"],
		[self.start stringWithShortTimeStyleFormat],
		[self.end stringWithShortTimeStyleFormat]
		]);
	}
else
	{
	// Dec 25, 10:30 AM - Dec 26, 11:00 AM
	return([NSString stringWithFormat:@"%@, %@ - %@, %@",
		[self.start stringWithFormat:@"MMM d"],
		[self.start stringWithShortTimeStyleFormat],
		[self.end stringWithFormat:@"MMM d"],
		[self.end stringWithShortTimeStyleFormat]
		]);
	}
}

@end

#pragma mark -

@implementation CMutableDateRange

@synthesize durationPinnedFlag;

- (id)initWithStart:(NSDate *)inStart end:(NSDate *)inEnd;
{
if ((self = [super initWithStart:inStart end:inEnd]) != NULL)
	{
	self.durationPinnedFlag = YES;
	}
return(self);
}

- (NSDate *)start
{
return(start);
}

- (void)setStart:(NSDate *)inStart
{
if (start != inStart)
	{
	if (self.durationPinnedFlag == NO)
		[super setStart:inStart];
	else
		{
		NSTimeInterval theDuration = self.duration;
		[super setStart:inStart];
		[super setEnd:[inStart dateByAddingTimeInterval:theDuration]];
		}

    }
}

- (NSDate *)end
{
return end;
}

- (void)setEnd:(NSDate *)inEnd
{
if (end != inEnd)
	{
	[super setEnd:inEnd];
    }
}

- (NSTimeInterval)duration
{
return([self.end timeIntervalSinceDate:self.start]);
}

- (void)setDuration:(NSTimeInterval)inDuration
{
self.end = [self.start dateByAddingTimeInterval:inDuration];
}

@end

#pragma mark -

@implementation CDateRange (CDateRange_Extensions)

- (NSTimeInterval)durationHours
{
return(round(self.duration / 3600.0));
}

@end
