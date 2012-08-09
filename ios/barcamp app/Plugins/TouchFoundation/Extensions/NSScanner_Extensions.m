//
//  NSScanner_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 12/27/2004.
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

#import "NSScanner_Extensions.h"

@implementation NSScanner (NSScanner_MoreExtensions)

- (NSString *)remainingString
{
return([[self string] substringFromIndex:[self scanLocation]]);
}

- (BOOL)scanAtMost:(NSUInteger)inMaximum commaSeparatedDoubles:(NSArray **)outDoubles
{
NSMutableArray *theDoubles = [NSMutableArray array];


NSInteger theStartScanLocation, theScanLocation;
theStartScanLocation = theScanLocation = [self scanLocation];

while ([self isAtEnd] == NO)
	{
	double theDouble;
	if ([self scanDouble:&theDouble] == NO)
		{
		break;
		}
	
	[theDoubles addObject:[NSNumber numberWithDouble:theDouble]];
	if (inMaximum > 0 && [theDoubles count] >= inMaximum)
		break;
	
	[self scanString:@"," intoString:NULL];

	theScanLocation = [self scanLocation];
	}

if ([theDoubles count] > 0)
	{
	[self setScanLocation:theScanLocation];

	if (outDoubles)
		*outDoubles = theDoubles;
	return(YES);
	}

[self setScanLocation:theStartScanLocation];

return(NO);
}

- (BOOL)skipComma
{
[self scanString:@"," intoString:NULL];
return(YES);
}

- (BOOL)scanCGPoint:(CGPoint *)outCGPoint
{
NSInteger theOldScanLocation = [self scanLocation];

CGPoint thePoint;
if ([self scanCGFloat:&thePoint.x] == YES && [self skipComma] && [self scanCGFloat:&thePoint.y] == YES)
	{
	if (outCGPoint)
		*outCGPoint = thePoint;
	return(YES);
	}

[self setScanLocation:theOldScanLocation];
return(NO);
}

- (BOOL)scanCGFloat:(CGFloat *)outCGFloat;
{
// TODO handle 64-bit
double theDouble;
BOOL theResult = [self scanDouble:&theDouble];
if (outCGFloat)
	*outCGFloat = theDouble;
return(theResult);
}

- (BOOL)scanAtMost:(NSUInteger)N charactersFromSet:(NSCharacterSet *)set intoString:(NSString **)value;
{
NSUInteger theCurrentLocation = [self scanLocation];

NSString *theValue = NULL;
if ([self scanCharactersFromSet:set intoString:&theValue] == YES)
	{
	NSUInteger theScannedCharacters = [theValue length];
	if (theScannedCharacters > N)
		{
		theValue = [theValue substringToIndex:N];
		[self setScanLocation:theCurrentLocation + N];
		}
	if (value)
		{
		*value = theValue;
		}
	return(YES);
	}
else
	{
	return(NO);
	}
}

- (BOOL)scanStringWithinParentheses:(NSString **)outString;
{
NSUInteger theCurrentLocation = [self scanLocation];

if ([self scanString:@"(" intoString:NULL] == NO)
	{
	[self setScanLocation:theCurrentLocation];
	return(NO);
	}
if ([self scanUpToString:@")" intoString:outString] == NO)
	{
	[self setScanLocation:theCurrentLocation];
	return(NO);
	}

return(YES);	
}

- (BOOL)scanNumber:(NSNumber **)outNumber
{
BOOL theResult = NO;
NSString *theSign = @"";
[self scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"+-"] intoString:&theSign];
NSString *theInteger = @"";
theResult = [self scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theInteger];

NSString *theFraction = @"";
if ([self scanString:@"." intoString:NULL])
	{
	theResult = YES;
	[self scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theFraction];
	}

if (theResult == YES)
	{
	if (outNumber != NULL)
		*outNumber = [NSNumber numberWithFloat:[[NSString stringWithFormat:@"%@%@.%@", theSign, theInteger, theFraction] floatValue]];
	}
return(theResult);
}

/*
- (BOOL)scanAtMost:(unsigned)N charactersFromSet:(NSCharacterSet *)set intoString:(NSString **)value;
{
unsigned theCurrentLocation = [self scanLocation];

NSString *theValue = NULL;
if ([self scanCharactersFromSet:set intoString:&theValue] == YES)
	{
	unsigned theScannedCharacters = [theValue length];
	if (theScannedCharacters > N)
		{
		theValue = [theValue substringToIndex:N];
		[self setScanLocation:theCurrentLocation + N];
		}
	if (value)
		{
		*value = theValue;
		}
	return(YES);
	}
else
	{
	return(NO);
	}
}

- (BOOL)scanStringWithinParentheses:(NSString **)outString;
{
unsigned theCurrentLocation = [self scanLocation];

if ([self scanString:@"(" intoString:NULL] == NO)
	{
	[self setScanLocation:theCurrentLocation];
	return(NO);
	}
if ([self scanUpToString:@")" intoString:outString] == NO)
	{
	[self setScanLocation:theCurrentLocation];
	return(NO);
	}

return(YES);	
}

- (BOOL)scanNumber:(NSNumber **)outNumber
{
BOOL theResult = NO;
NSString *theSign = @"";
[self scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"+-"] intoString:&theSign];
NSString *theInteger = @"";
theResult = [self scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theInteger];

NSString *theFraction = @"";
if ([self scanString:@"." intoString:NULL])
	{
	theResult = YES;
	[self scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theFraction];
	}

if (theResult == YES)
	{
//	if (outNumber != NULL)
//		outNumber = [NSNumber numberWithFloat:[[NSString stringWithFormat:@"%@%@.%@", theSign, theInteger, theFraction] floatValue]];
	}
return(theResult);
}
*/

@end
