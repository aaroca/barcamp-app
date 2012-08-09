//
//  NSURL_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/05/08.
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

#import "NSURL_Extensions.h"

@implementation NSURL (NSURL_Extensions)

+ (NSURL *)URLWithRoot:(NSURL *)inRoot query:(NSString *)inQuery
{
if (inQuery == NULL || [inQuery length] == 0)
	return(inRoot);
NSString *theURLString = [NSString stringWithFormat:@"%@?%@", inRoot, inQuery];
return([self URLWithString:theURLString]);
}

+ (NSURL *)URLWithRoot:(NSURL *)inRoot queryDictionary:(NSDictionary *)inQueryDictionary
{
NSURL *theURL = NULL;

if ([inRoot query] != NULL)
	{
	NSMutableDictionary *theExistingQuery = [[[inRoot queryDictionary] mutableCopy] autorelease];
	
	[theExistingQuery addEntriesFromDictionary:inQueryDictionary];
	
	theURL = [self URLWithRoot:[inRoot querylessURL] query:[self queryStringForDictionary:theExistingQuery]];
	}
else
	{
	theURL = [self URLWithRoot:inRoot query:[self queryStringForDictionary:inQueryDictionary]];
	}

return(theURL);
}

+ (NSString *)queryStringForDictionary:(NSDictionary *)inQueryDictionary
{
NSMutableArray *theQueryComponents = [NSMutableArray array];
for (NSString *theKey in inQueryDictionary)
	{
	id theValue = [inQueryDictionary objectForKey:theKey];
    if ([theValue isKindOfClass:[NSArray class]])
        {
        for (id subValue in theValue)
            {
            NSString *tempSubValue = [subValue description];
            [theQueryComponents addObject:[NSString stringWithFormat:@"%@=%@", theKey, [tempSubValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            }
        }
    else
        {
        // this fixes the issue of spaces in values. %@ = [value description]
        NSString *tempValue = [theValue description];
        [theQueryComponents addObject:[NSString stringWithFormat:@"%@=%@", theKey, [tempValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }
	}
return([theQueryComponents componentsJoinedByString:@"&"]);
}

- (NSDictionary *)queryDictionary
{
NSString *theQuery = [self query];

NSMutableDictionary *theQueryDictionary = [NSMutableDictionary dictionary];

for (NSString *theComponent in [theQuery componentsSeparatedByString:@"&"])
	{
	if ([theComponent rangeOfString:@"="].location != NSNotFound)
		{
		NSArray *theComponents = [theComponent componentsSeparatedByString:@"="];
		if ([theComponents count] != 2)
			return(NULL);
		[theQueryDictionary setObject:[theComponents objectAtIndex:1] forKey:[theComponents objectAtIndex:0]];
		}
	else
		{
		[theQueryDictionary setObject:[NSNull null] forKey:theComponent];
		}
	}
return(theQueryDictionary);
}

- (NSURL *)querylessURL
{
NSMutableString *theURLString = [NSMutableString stringWithString:@""];

if ([self scheme])
	[theURLString appendFormat:@"%@://", [self scheme]];
if ([self user])
	[theURLString appendFormat:@"%@", [self user]];
if ([self host])
	[theURLString appendFormat:@"%@", [self host]];
if ([self path])
	[theURLString appendFormat:@"%@", [self path]];

NSURL *theURL = [NSURL URLWithString:theURLString];
return(theURL);
}

@end
