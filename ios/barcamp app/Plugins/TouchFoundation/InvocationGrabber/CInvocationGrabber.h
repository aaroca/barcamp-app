//
//  CInvocationGrabber.h
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

#import <Foundation/Foundation.h>

/**
 * @class CInvocationGrabber
 * @discussion CInvocationGrabber is a helper object that makes it very easy to construct instances of NSInvocation. The object is inspired by NSUndoManager's prepareWithInvocationTarget method.

NSInvocation *theInvocation = NULL;
[[CInvocationGrabber grabWithTarget:someObject invocation:&theInvocation] doSomethingWithParameter:someParameter];

Note this version is all new and the syntax is a lot more compact. This version is not backwards compatible and the old version is therefore deprecated.

WARNING: Does not seem to work with methods that take vararg style arguments (...), e.g. -[NSMutableString appendFormat:] etc.
 */
@interface CInvocationGrabber : NSProxy {
	id target;
	NSInvocation **invocationDestination;
}

+ (id)grabInvocation:(NSInvocation **)outInvocation fromTarget:(id)inTarget;

- (void)didGrabInvocation:(NSInvocation *)inInvocation;

@end

#pragma mark -

@interface CThreadingInvocationGrabber : CInvocationGrabber {
	BOOL waitUntilDone;
}

+ (id)grabInvocationFromTarget:(id)inTarget andPeformOnMainThreadWaitUntilDone:(BOOL)inWaitUntilDone;

@end

