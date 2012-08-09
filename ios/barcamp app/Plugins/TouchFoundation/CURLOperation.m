//
//  CURLOperation.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/21/09.
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

#import "CURLOperation.h"

#import "CTemporaryData.h"

@interface CURLOperation ()
@property (readwrite, assign) BOOL isExecuting;
@property (readwrite, assign) BOOL isFinished;
@property (readwrite, retain) NSURLRequest *request;
@property (readwrite, retain) NSURLConnection *connection;
@property (readwrite, retain) NSURLResponse *response;
@property (readwrite, retain) NSError *error;
@property (readwrite, retain) CTemporaryData *temporaryData;
@end

@implementation CURLOperation

@synthesize isExecuting;
@synthesize isFinished;
@synthesize request;
@synthesize connection;
@synthesize response;
@synthesize error;
@synthesize temporaryData;
@synthesize defaultCredential;
@synthesize userInfo;

- (id)initWithRequest:(NSURLRequest *)inRequest
	{
	if ((self = [super init]) != NULL)
		{
		isExecuting = NO;
		isFinished = NO;

		request = [inRequest copy];
		}
	return(self);
	}

- (void)dealloc
	{
	[request release];
	request = NULL;
	[connection release];
	connection = NULL;
	[response release];
	response = NULL;
	[error release];
	error = NULL;
	[temporaryData release];
	temporaryData = NULL;
	[defaultCredential release];
	defaultCredential = NULL;
	[userInfo release];
	userInfo = NULL;
	//
	[super dealloc];
	}

#pragma mark -

- (BOOL)isConcurrent
	{
	return(YES);
	}

- (NSData *)data
	{
	return(self.temporaryData.data);
	}

#pragma mark -

- (void)start
	{
	@try
		{
		self.isExecuting = YES;
		self.connection = [[[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO] autorelease];
	//	self.connection = [[[NSURLConnection alloc] initWithRequest:self.request delegate:self] autorelease];

		[self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
		[self.connection start];

	//	[self.connection performSelectorOnMainThread:@selector(start) withObject:NULL waitUntilDone:YES];

		}
	@catch (NSException * e)
		{
		NSLog(@"EXCEPTION CAUGHT: %@", e);
		}
	}

- (void)cancel
	{
	[self.connection cancel];
	self.connection = NULL;
	//
	[super cancel];
	}

#pragma mark -

- (void)didReceiveData:(NSData *)inData
	{
	if (self.isCancelled)
		{
		return;
		}

	if (self.temporaryData == NULL)
		{
		self.temporaryData = [[[CTemporaryData alloc] initWithMemoryLimit:64 * 1024] autorelease];
		}
	NSError *theError = NULL;
	BOOL theResult = [self.temporaryData appendData:inData error:&theError];
	if (theResult == NO)
		{
		self.error = theError;
		[self cancel];
		}
	}

- (void)didFinish
	{
	[self willChangeValueForKey:@"isFinished"];
	self.isFinished = YES;
	[self didChangeValueForKey:@"isFinished"];

	self.isExecuting = NO;
	self.connection = NULL;
	}

- (void)didFailWithError:(NSError *)inError
	{
	self.error = inError;

	[self willChangeValueForKey:@"isFinished"];
	self.isFinished = YES;
	[self didChangeValueForKey:@"isFinished"];

	self.isExecuting = NO;
	self.connection = NULL;
	}

#pragma mark -

- (NSURLRequest *)connection:(NSURLConnection *)inConnection willSendRequest:(NSURLRequest *)inRequest redirectResponse:(NSURLResponse *)response
	{
	return(inRequest);
	}

//- (BOOL)connection:(NSURLConnection *)inConnection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
//{
//}
//
//- (NSInputStream *)connection:(NSURLConnection *)inConnection needNewBodyStream:(NSURLRequest *)request
//{
//}

- (void)connection:(NSURLConnection *)inConnection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)inChallenge
	{
	if (self.defaultCredential == NULL || [inChallenge previousFailureCount] > 1)
		{
		[[inChallenge sender] cancelAuthenticationChallenge:inChallenge];
		}

	[[inChallenge sender] useCredential:self.defaultCredential forAuthenticationChallenge:inChallenge];
	}

//- (void)connection:(NSURLConnection *)inConnection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//}
//
//- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)inConnection
//{
//}

- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)inResponse
	{
	self.response = inResponse;
	}

- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData
	{
	[self didReceiveData:inData];
	}

//- (void)connection:(NSURLConnection *)inConnection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
//{
//}

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection
	{
	NSInteger statusCode = [(NSHTTPURLResponse *)self.response statusCode];
	if (statusCode >= 400)
		{
		NSString *body = [[[NSString alloc] initWithBytes:[self.data bytes] length:[self.data length] encoding:NSUTF8StringEncoding] autorelease];
		NSError *err = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:[NSDictionary dictionaryWithObject:body forKey:NSLocalizedDescriptionKey]];
		[self didFailWithError:err];
		}
	else
		{
		[self didFinish];
		}
	}

- (void)connection:(NSURLConnection *)inConnection didFailWithError:(NSError *)inError
	{
	[self didFailWithError:inError];
	}

//- (NSCachedURLResponse *)connection:(NSURLConnection *)inConnection willCacheResponse:(NSCachedURLResponse *)cachedResponse
//{
//}

//- (NSString *)description
//{
//return([NSString stringWithFormat:@"isFinished:%d", self.isFinished]);;
//}

@end
