//
//  NSString_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/01/08.
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

#import "NSString_Extensions.h"

#import "NSScanner_HTMLExtensions.h"

@implementation NSString (NSString_Extensions)

- (NSString *)stringByTidyingHTMLEntities
{
NSMutableString *theOutput = [NSMutableString string];

NSScanner *theScanner = [NSScanner scannerWithString:self];
[theScanner setCharactersToBeSkipped:NULL];

while ([theScanner isAtEnd] == NO)
	{
	NSString *theString = NULL;
	if ([theScanner scanUpToString:@"&" intoString:&theString] == YES)
		{
		[theOutput appendString:theString];
		}
	if ([theScanner scanHTMLEntityIntoString:&theString] == YES)
		{
		[theOutput appendString:theString];
		}
	else
		{
		if ([theScanner scanString:@"&" intoString:&theString] == YES)
			{
			[theOutput appendString:theString];
			}
		}
	}

return([[theOutput copy] autorelease]);
}

- (NSArray *)componentsSeperatedByWhitespaceRunsOrComma
{
    NSMutableCharacterSet *theCommaCharacterSet = [[[NSCharacterSet characterSetWithCharactersInString:@","] mutableCopy] autorelease];
    [theCommaCharacterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return [self componentsSeparatedByRunsFromCharacterSet:theCommaCharacterSet];
}

- (NSArray *)componentsSeparatedByRunsFromCharacterSet:(NSCharacterSet *)characterSet
{
    NSMutableArray *theArray = [NSMutableArray array];
    NSCharacterSet *contentSet = [characterSet invertedSet];
    
    NSScanner *theScanner = [NSScanner scannerWithString:self];
    while (![theScanner isAtEnd])
	{
        [theScanner scanCharactersFromSet:characterSet intoString:NULL];
        
        NSString *theValue = NULL;
        if ([theScanner scanCharactersFromSet:contentSet intoString:&theValue] == YES)
		{
            [theArray addObject:theValue];
		}
	}
    return(theArray);
}

#pragma mark -

- (long)asLongFromHex
{
long theValue = strtol([self UTF8String], NULL, 16);
return(theValue);
}

- (NSString *)stringByAddingPercentEscapesWithCharactersToLeaveUnescaped:(NSString *)inCharactersToLeaveUnescaped legalURLCharactersToBeEscaped:(NSString *)inLegalURLCharactersToBeEscaped
{
NSString *theEscapedString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)inCharactersToLeaveUnescaped, (CFStringRef)inLegalURLCharactersToBeEscaped, kCFStringEncodingUTF8) autorelease];

return(theEscapedString);
}

- (NSString *)stringByObsessivelyAddingPercentEscapes
{
return([self stringByAddingPercentEscapesWithCharactersToLeaveUnescaped:@"abcdefghijklmnopqrstuvwyxzABCDEFGHIJKLMNOPQRSTUVWXYZ123456780" legalURLCharactersToBeEscaped:@"/=&?"]);
}

- (NSString *)stringByFlatteningHTML
{
    NSMutableArray *components = [NSMutableArray array];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    while (![scanner isAtEnd])
    {
        NSString *thisComponent = @"";
        
        [scanner scanUpToString:@"<" intoString:&thisComponent];
        [scanner scanUpToString:@">" intoString:nil];
        [scanner scanString:@">" intoString:nil];
        
        if (thisComponent.length > 0)
            [components addObject:thisComponent];
    }
    
    NSString *flattenedString = [components componentsJoinedByString:@" "];
    return flattenedString;
}

@end
