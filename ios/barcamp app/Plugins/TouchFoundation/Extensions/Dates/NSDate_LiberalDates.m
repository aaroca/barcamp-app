//
//  NSDateFormatter_LiberalDates.m
//  TouchFoundation
//
//  Created by Devin Chalmers on 3/30/11.
//  Copyright 2011 Devin Chalmers. All rights reserved.
//

#import "NSDate_LiberalDates.h"


@implementation NSDate (LiberalDates)

+ (NSDate *)dateWithInternetString:(NSString *)dateString;
{
	NSDate *date = nil;
	
	for (NSDateFormatter *formatter in [NSDateFormatter allISO8601DateFormatters]) {
		date = [formatter dateFromString:dateString];
		if (date) return date;
	}
	
	for (NSDateFormatter *formatter in [NSDateFormatter allRFC2822DateFormatters]) {
		date = [formatter dateFromString:dateString];
		if (date) return date;
	}
	
	for (NSDateFormatter *formatter in [NSDateFormatter allInternetDateFormatters]) {
		date = [formatter dateFromString:dateString];
		if (date) return date;
	}
	
	return date;
}

@end
