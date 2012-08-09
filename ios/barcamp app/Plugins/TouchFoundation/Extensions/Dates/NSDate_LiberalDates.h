//
//  NSDateFormatter_LiberalDates.h
//  TouchFoundation
//
//  Created by Devin Chalmers on 3/30/11.
//  Copyright 2011 Devin Chalmers. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSDateFormatter_InternetDateExtensions.h"

@interface NSDate (LiberalDates)

+ (NSDate *)dateWithInternetString:(NSString *)dateString;

@end
