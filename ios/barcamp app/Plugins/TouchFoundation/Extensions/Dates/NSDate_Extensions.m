//
//  NSDate_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 4/1/09.
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

#import "NSDate_Extensions.h"

@implementation NSDate (NSDate_Extensions)

+ (NSDate *)dateWithString:(NSString *)inString format:(NSString *)inFormat
{
NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
theFormatter.formatterBehavior = NSDateFormatterBehavior10_4;
theFormatter.dateFormat = inFormat;
return([theFormatter dateFromString:inString]);
}

- (NSString *)stringWithFormat:(NSString *)inFormat;
{
NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
theFormatter.formatterBehavior = NSDateFormatterBehavior10_4;
theFormatter.dateFormat = inFormat;
return([theFormatter stringFromDate:self]);
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)inDateStyle timeStyle:(NSDateFormatterStyle)inTimeStyle
{
NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
theFormatter.formatterBehavior = NSDateFormatterBehavior10_4;
theFormatter.dateStyle = inDateStyle;
theFormatter.timeStyle = inTimeStyle;
return([theFormatter stringFromDate:self]);
}

- (NSString *)stringWithShortDateStyleFormat
{
return([self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle]);
}

- (NSString *)stringWithMediumDateStyleFormat
{
return([self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]);
}

- (NSString *)stringWithLongDateStyleFormat
{
return([self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle]);
}

- (NSString *)stringWithFullDateStyleFormat
{
return([self stringWithDateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterNoStyle]);
}

- (NSString *)stringWithShortTimeStyleFormat
{
return([self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]);
}

- (NSString *)stringWithMediumTimeStyleFormat
{
return([self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle]);
}

- (NSString *)stringWithLongTimeStyleFormat
{
return([self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle]);
}

- (NSString *)stringWithFullTimeStyleFormat
{
return([self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterFullStyle]);
}

- (BOOL)isSameCalendarDayAsDate:(NSDate *)inDate
{
NSDateComponents *theComponents = [[NSCalendar currentCalendar] components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self toDate:inDate options:0];

return(theComponents.era == 0 && theComponents.year == 0 && theComponents.month == 0 && theComponents.day == 0);
}

@end
