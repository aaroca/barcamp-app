//
//  NSOperationQueue_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 4/28/09.
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

#import "NSOperationQueue_Extensions.h"

#define USE_MAIN_QUEUE 0

@interface CRunloopHelper : NSObject {
	BOOL flag;
}
@property (readwrite, assign) BOOL flag;
- (void)runSynchronousOperation:(NSOperation *)inOperation onQueue:(NSOperationQueue *)inQueue;
@end

#pragma mark -

@implementation NSOperationQueue (NSOperationQueue_Extensions)

#if USE_MAIN_QUEUE == 0
static NSOperationQueue *gDefaultOperationQueue = NULL;
#endif

+ (NSOperationQueue *)defaultOperationQueue
{
#if USE_MAIN_QUEUE == 0
@synchronized(@"+[NSOperationQueue defaultOperationQueue]")
	{
	if (gDefaultOperationQueue == NULL)
		{
		gDefaultOperationQueue = [[self alloc] init];
		}
	}
return(gDefaultOperationQueue);
#else
NSOperationQueue *theQueue = [self currentQueue];
return(theQueue);
#endif
}

- (void)addOperationRecursively:(NSOperation *)inOperation
{
[self addOperation:inOperation];

for (NSOperation *theDependency in inOperation.dependencies)
	{
	[self addOperationRecursively:theDependency];
	}
}

- (void)addDependentOperations:(NSArray *)inOperations
{
NSOperation *thePreviousOperation = NULL;
for (NSOperation *theOperation in [inOperations reverseObjectEnumerator])
	{
	if (thePreviousOperation)
		{
		[thePreviousOperation addDependency:theOperation];
		}
	thePreviousOperation = theOperation;
	}

[self addOperationRecursively:[inOperations lastObject]];
}

- (void)runSynchronousOperation:(NSOperation *)inOperation
{
CRunloopHelper *theHelper = [[[CRunloopHelper alloc] init] autorelease];
[theHelper runSynchronousOperation:inOperation onQueue:self];
}

@end

#pragma mark -

@implementation CRunloopHelper

@synthesize flag;

- (void)runSynchronousOperation:(NSOperation *)inOperation onQueue:(NSOperationQueue *)inQueue
{
NSString *theContext = @"-[CRunloopHelper runSynchronousOperation:onQueue] context";

[inOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:theContext];
[inOperation addObserver:self forKeyPath:@"isCancelled" options:NSKeyValueObservingOptionNew context:theContext];

[inQueue addOperationRecursively:inOperation];

self.flag = YES;
while (self.flag == YES)
	{
	if ([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]] == NO)
		break;
	}

[inOperation removeObserver:self forKeyPath:@"isFinished"];
[inOperation removeObserver:self forKeyPath:@"isCancelled"];
}

- (void)stop
{
self.flag = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
[[NSRunLoop currentRunLoop] performSelector:@selector(stop) target:self argument:NULL order:0 modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
}

@end
