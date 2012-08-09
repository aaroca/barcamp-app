//
//  CBundleResourceURLProtocol.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/15/08.
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

#import "CBundleResourceURLProtocol.h"

#if !defined(XBUNDLE_NEVER_CHECK_WHITELIST)
#define XBUNDLE_NEVER_CHECK_WHITELIST 1
#endif /* !defined(XBUNDLE_NEVER_CHECK_WHITELIST) */

@implementation CBundleResourceURLProtocol

+ (void)load
{
[self registerClass:self];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
NSURL *theURL = request.URL;

if ([theURL.scheme isEqualToString:@"x-resource"] == NO)
	return(NO);

NSString *thePath = theURL.resourceSpecifier;
thePath = [thePath stringByStandardizingPath];
if ([self isPathWhitelisted:thePath] == NO)
	{
	return(NO);
	}

thePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:thePath];
BOOL theFileExists = [[NSFileManager defaultManager] fileExistsAtPath:thePath];

return(theFileExists);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
return(request);
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
return([a.URL isEqual:b.URL]);
}

- (void)startLoading
{
NSAssert(self.client, @"Should never get a startLoading message.");
NSAssert([self.client conformsToProtocol:@protocol(NSURLProtocolClient)], @"Should never have a client that does not conform to NSURLProtocolClient protocol.");

NSURL *theURL = self.request.URL;
NSAssert([theURL.scheme isEqualToString:@"x-resource"], @"The requesting URL scheme is not x-resource.");

NSString *thePath = theURL.resourceSpecifier;

thePath = [thePath stringByStandardizingPath];

if ([[self class] isPathWhitelisted:thePath] == NO)
	{
	NSError *theError = [NSError errorWithDomain:@"TODO_DOMAIN" code:-1 userInfo:NULL];
	[self.client URLProtocol:self didFailWithError:theError];
	return;
	}

thePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:thePath];

NSString *theMimeType = [[self class] MIMETypeForPath:thePath];

NSData *theData = [NSData dataWithContentsOfFile:thePath];

NSURLResponse *theResponse = [[[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:theMimeType expectedContentLength:theData.length textEncodingName:NULL] autorelease];

[self.client URLProtocol:self didReceiveResponse:theResponse cacheStoragePolicy:NSURLCacheStorageNotAllowed];

[self.client URLProtocol:self didLoadData:theData];

[self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
}

+ (NSString *)MIMETypeForPath:(NSString *)inPath
{
NSString *theExtension = [inPath pathExtension];
if ([theExtension isEqualToString:@"js"])
	return(@"text/javascript");
else if ([theExtension isEqualToString:@"css"])
	return(@"text/css");
else if ([theExtension isEqualToString:@"html"])
	return(@"text/html");
else if ([theExtension isEqualToString:@"png"])
	return(@"image/png");
else
	return(@"application/data");
}

+ (BOOL)isPathWhitelisted:(NSString *)inPath
{
if (inPath == NULL || inPath.length == 0)
	return(NO);

#if XBUNDLE_NEVER_CHECK_WHITELIST == 1
return(YES);
#endif /* XBUNDLE_NEVER_CHECK_WHITELIST */

NSSet *theWhitelistedPaths = [NSSet setWithArray:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"XBundleResourceWhitelistedPaths"]];

if ([theWhitelistedPaths containsObject:inPath])
	return(YES);
else
	{
	return(NO);
	}
}


//+ (id)propertyForKey:(NSString *)key inRequest:(NSURLRequest *)request;
//+ (void)setProperty:(id)value forKey:(NSString *)key inRequest:(NSMutableURLRequest *)request;
//+ (void)removePropertyForKey:(NSString *)key inRequest:(NSMutableURLRequest *)request;


@end
