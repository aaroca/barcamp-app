//
//  CInvocationGrabber.m
//  TouchCode
//
//  Created by Jonathan Wight on 20090528.
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

#import "CInvocationGrabber.h"

/*
CInvocationGrabber *theInvocationGrabber = [CInvocationGrabber invocationGrabber];
[[theInvocationGrabber prepareWithInvocationTarget:foo] doSomethingWithParameter:bar];
NSInvocation *theInvocation = [theInvocationGrabber invocation];
*/

@interface CInvocationGrabber ()
@property (readwrite, retain) id target;
@property (readwrite, assign) NSInvocation **invocationDestination;
@end

@implementation CInvocationGrabber

@synthesize target;
@synthesize invocationDestination;

+ (id)grabInvocation:(NSInvocation **)outInvocation fromTarget:(id)inTarget;
{
CInvocationGrabber *theGrabber = [[[self alloc] init] autorelease];
theGrabber.target = inTarget;
theGrabber.invocationDestination = outInvocation;
return(theGrabber);
}

- (id)init
{
return(self);
}

- (void)dealloc
{
self.target = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSMethodSignature *)methodSignatureForSelector:(SEL)inSelector
{
NSMethodSignature *theMethodSignature = [[self target] methodSignatureForSelector:inSelector];
return(theMethodSignature);
}

- (void)forwardInvocation:(NSInvocation *)ioInvocation
{
[ioInvocation setTarget:self.target];

if (self.invocationDestination)
	*self.invocationDestination = ioInvocation;

[self didGrabInvocation:ioInvocation];
}

- (void)didGrabInvocation:(NSInvocation *)inInvocation
{
}

@end

#pragma mark  -

@interface CThreadingInvocationGrabber ()
@property (readwrite, nonatomic, assign) BOOL waitUntilDone;
@end

#pragma mark -

@implementation CThreadingInvocationGrabber

@synthesize waitUntilDone;

+ (id)grabInvocationFromTarget:(id)inTarget andPeformOnMainThreadWaitUntilDone:(BOOL)inWaitUntilDone
{
CThreadingInvocationGrabber *theGrabber = [[[self alloc] init] autorelease];
theGrabber.target = inTarget;
theGrabber.waitUntilDone = inWaitUntilDone;
return(theGrabber);
}

- (void)didGrabInvocation:(NSInvocation *)inInvocation
{
[inInvocation retainArguments];

[inInvocation performSelectorOnMainThread:@selector(invoke) withObject:NULL waitUntilDone:self.waitUntilDone];
}

@end

