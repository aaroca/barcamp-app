//
//  NSDateFormatter_InternetDateExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 5/16/09.
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

#import "NSDateFormatter_InternetDateExtensions.h"

#import "ISO8601DateFormatter.h"

struct SDateFormatTimeZonePair {
	NSString *dateFormat;
	NSString *timezone;
};

@implementation NSDateFormatter (NSDateFormatter_InternetDateExtensions)

//http://unicode.org/reports/tr35/tr35-4.html#Date_Format_Patterns
//http://www.faqs.org/rfcs/rfc2822.html
//http://en.wikipedia.org/wiki/ISO_8601

+ (NSDateFormatter *)RFC2822Formatter;
{
NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
[theFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
[theFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
[theFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss ZZ"];
return(theFormatter);
}

+ (NSDateFormatter *)RFC2822FormatterGMT;
{
NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
[theFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
[theFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
[theFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
[theFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss 'GMT'"];
return(theFormatter);
}

+ (NSDateFormatter *)RFC2822FormatterUTC;
{
NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
[theFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
[theFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
[theFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss 'UTC'"];
return(theFormatter);
}


+ (NSDateFormatter *)ISO8601Formatter
{
NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
[theFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
[theFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
[theFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
[theFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
return(theFormatter);
}

+ (NSDateFormatter *)ISO8601FormatterMinimal
{
NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
[theFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
[theFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
[theFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
[theFormatter setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
return(theFormatter);
}


+ (NSArray *)allRFC2822DateFormatters
{
static NSArray *sFormatters = NULL;

@synchronized(self)
	{
	if (sFormatters == NULL)
		{
		struct SDateFormatTimeZonePair thePairs[] = {
			{ .dateFormat = @"EEE, d MMM yy HH:mm:ss ZZ" },
			{ .dateFormat = @"EEE, d MMM yy HH:mm:ss zzz" },
			{ .dateFormat = @"EEE, d MMM yy HH:mm:ss 'Z'", @"UTC", },
			{ NULL, NULL },
			};

		NSMutableArray *theFormatters = [NSMutableArray array];
		for (int N = 0; thePairs[N].dateFormat != NULL; ++N)
			{
			NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[theFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
			[theFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
			[theFormatter setDateFormat:thePairs[N].dateFormat];
			if (thePairs[N].timezone)
				[theFormatter setTimeZone:[NSTimeZone timeZoneWithName:thePairs[N].timezone]];

			[theFormatters addObject:theFormatter];
			}


		sFormatters = [theFormatters copy];
		}
	}
return(sFormatters);
}

+ (NSArray *)allISO8601DateFormatters
{
static NSArray *sFormatters = NULL;

@synchronized(self)
	{
	if (sFormatters == NULL)
		{
		struct SDateFormatTimeZonePair thePairs[] = {
			{ .dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'", .timezone = @"UTC" },
			{ .dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SS'Z'", .timezone = @"UTC" },
			{ .dateFormat = @"yyyyMMdd'T'HHmmss'Z'", .timezone = @"UTC" },
			{ .dateFormat = @"HH:mm:ss'Z'", .timezone = @"UTC" },
			{ .dateFormat = @"HHmmss'Z'", .timezone = @"UTC" },
			{ .dateFormat = @"HH:mm:ss'Z'", .timezone = @"UTC" },
			{ .dateFormat = @"HHmmss'Z'", .timezone = @"UTC" },
			{ .dateFormat = @"yyyy-MM-dd", .timezone = @"UTC" },
			{ .dateFormat = @"yyyyMMdd", .timezone = @"UTC" },
			{ .dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZ" },
			{ .dateFormat = @"yyyyMMdd'T'HHmmssZZ" },
			{ .dateFormat = @"HH:mm:ssZZ" },
			{ .dateFormat = @"HHmmssZZ" },
			{ NULL, NULL },
			};

		NSMutableArray *theFormatters = [NSMutableArray array];
		for (int N = 0; thePairs[N].dateFormat != NULL; ++N)
			{
			NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[theFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
			[theFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
			[theFormatter setDateFormat:thePairs[N].dateFormat];
			[theFormatter setDefaultDate:NULL];
			[theFormatter setLenient:NO];
			if (thePairs[N].timezone)
				[theFormatter setTimeZone:[NSTimeZone timeZoneWithName:thePairs[N].timezone]];

			[theFormatters addObject:theFormatter];
			}


		sFormatters = [theFormatters copy];
		}
	}
return(sFormatters);
}


+ (NSArray *)allInternetDateFormatters;
{
static NSArray *sFormatters = NULL;

@synchronized(self)
	{
	if (sFormatters == NULL)
		{
		NSArray *theFormats = [NSArray arrayWithObjects:
			@"d MMM yy HH:mm:ss zzz",
			@"EEE, d MMM yy HH:mm:ss 'Z'",
			@"EEE, d MMM yy HH:mm:ss zzz",
			NULL];

		NSMutableArray *theFormatters = [NSMutableArray arrayWithCapacity:[theFormats count]];

		for (NSString *theFormat in theFormats)
			{
			NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[theFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
			[theFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
			[theFormatter setDateFormat:theFormat];
			[theFormatters addObject:theFormatter];
			}

		sFormatters = [theFormatters copy];
		}
	}
return(sFormatters);
}

@end
