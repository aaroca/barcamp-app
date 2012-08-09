//
//  NSURLResponse_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 11/09/09.
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

#import "NSURLResponse_Extensions.h"

@implementation NSURLResponse (NSURLResponse_Extensions)

- (NSError *)asError
{
// TODO - we can make a minimal OH NOES error here and just use the URL in the error. No?
return(NULL);
}

- (NSString *)debuggingDescription
{
NSMutableArray *theComponents = [NSMutableArray array];

[theComponents addObject:[NSString stringWithFormat:@"URL: %@", [self URL]]];
[theComponents addObject:[NSString stringWithFormat:@"MIMEType: %@", [self MIMEType]]];

NSString *theDescription = [theComponents componentsJoinedByString:@"\n"];
return(theDescription);
}

- (void)dump
{
fprintf(stderr, "%s\n", [[self debuggingDescription] UTF8String]);
}

@end

#pragma mark -

@implementation NSHTTPURLResponse (NSURLResponse_Extensions)

- (NSError *)asError
{
NSString *theLocalizedDescription = NULL;
NSString *theRecoverySuggestion = NULL;

switch ([self statusCode])
	{
	case 401:
		theLocalizedDescription = @"Authorization failed.";
		theRecoverySuggestion = @"Try again later.";
		break;
	case 503:
		theLocalizedDescription = @"The service is currently unavailable.";
		theRecoverySuggestion = @"Try again later.";
		break;
	default:
		theLocalizedDescription = [NSHTTPURLResponse localizedStringForStatusCode:self.statusCode];
		break;
	}

NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionary];

if (self.URL)
	[theUserInfo setObject:self.URL forKey:NSURLErrorKey];

if (theLocalizedDescription != NULL)
	[theUserInfo setObject:theLocalizedDescription forKey:NSLocalizedDescriptionKey];
if (theRecoverySuggestion != NULL)
	[theUserInfo setObject:theRecoverySuggestion forKey:NSLocalizedRecoverySuggestionErrorKey];

NSError *theError = [NSError errorWithDomain:@"HTTP" code:self.statusCode userInfo:theUserInfo];
return(theError);
}

- (NSString *)debuggingDescription
{
NSMutableArray *theComponents = [NSMutableArray array];

[theComponents addObject:[NSString stringWithFormat:@"URL: %@", [self URL]]];
[theComponents addObject:[NSString stringWithFormat:@"MIMEType: %@", [self MIMEType]]];
[theComponents addObject:[NSString stringWithFormat:@"statusCode: %d", [self statusCode]]];
[theComponents addObject:[NSString stringWithFormat:@"Headers: %@", [self allHeaderFields]]];


NSString *theDescription = [theComponents componentsJoinedByString:@"\n"];
return(theDescription);
}

@end
