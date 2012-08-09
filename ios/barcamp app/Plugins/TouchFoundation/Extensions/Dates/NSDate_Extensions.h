//
//  NSDate_Extensions.h
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

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_Extensions)

+ (NSDate *)dateWithString:(NSString *)inString format:(NSString *)inFormat;

- (NSString *)stringWithFormat:(NSString *)inFormat;

/// Specifies a short style, typically numeric only, such as “11/23/37” or “3:30pm”.
- (NSString *)stringWithShortDateStyleFormat; 
/// Specifies a medium style, typically with abbreviated text, such as “Nov 23, 1937”.
- (NSString *)stringWithMediumDateStyleFormat;
///Specifies a long style, typically with full text, such as “November 23, 1937” or “3:30:32pm”.
- (NSString *)stringWithLongDateStyleFormat;
///Specifies a full style with complete details, such as “Tuesday, April 12, 1952 AD” or “3:30:42pm PST”.
- (NSString *)stringWithFullDateStyleFormat;

- (NSString *)stringWithShortTimeStyleFormat;
- (NSString *)stringWithMediumTimeStyleFormat;
- (NSString *)stringWithLongTimeStyleFormat;
- (NSString *)stringWithFullTimeStyleFormat;

- (BOOL)isSameCalendarDayAsDate:(NSDate *)inDate;

@end
