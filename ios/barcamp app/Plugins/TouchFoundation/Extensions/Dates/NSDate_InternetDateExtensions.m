//
//  NSDate_InternetDateExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/8/08.
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

#import "NSDate_InternetDateExtensions.h"

#import "NSDateFormatter_InternetDateExtensions.h"
#import "ISO8601DateFormatter.h"

@implementation NSDate (NSDate_InternetDateExtensions)

- (NSDate *)UTCDate
{
NSCalendar *theCalendar = [[[NSCalendar currentCalendar] copy] autorelease];
NSDateComponents *theComponents = [theCalendar components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
theCalendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
return([theCalendar dateFromComponents:theComponents]);
}

+ (NSDate *)dateWithRFC2822String:(NSString *)inString
{
NSDate *theDate = [[NSDateFormatter RFC2822Formatter] dateFromString:inString];
return(theDate);
}

- (NSString *)RFC822String
{
NSString *theDateString = [[NSDateFormatter RFC2822Formatter] stringFromDate:self];
return(theDateString);
}

- (NSString *)RFC822StringGMT
{
NSString *theDateString = [[NSDateFormatter RFC2822FormatterGMT] stringFromDate:self];
return(theDateString);
}

- (NSString *)RFC822StringUTC
{
NSString *theDateString = [[NSDateFormatter RFC2822FormatterUTC] stringFromDate:self];
return(theDateString);
}

+ (NSDate *)dateWithISO8601String:(NSString *)inString
{
ISO8601DateFormatter *theFormatter = [[[ISO8601DateFormatter alloc] init] autorelease];
NSDate *theDate = [theFormatter dateFromString:inString];
return(theDate);
}

- (NSString *)ISO8601String
{
ISO8601DateFormatter *theFormatter = [[[ISO8601DateFormatter alloc] init] autorelease];
theFormatter.includeTime = YES;
NSString *theDateString = [theFormatter stringFromDate:self];
return(theDateString);
}

- (NSString *)ISO8601MinimalString
{
NSString *theDateString = [[NSDateFormatter ISO8601FormatterMinimal] stringFromDate:self];
return(theDateString);
}


@end
