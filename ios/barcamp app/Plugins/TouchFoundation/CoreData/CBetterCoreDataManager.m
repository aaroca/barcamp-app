//
//  CBetterCoreDataManager.m
//  TouchCode
//
//  Created by Jonathan Wight on 11/10/09.
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

#import "CBetterCoreDataManager.h"

#import "NSError_Extensions.h"

@interface CBetterCoreDataManager()
- (void)managedObjectContextDidSaveNotification:(NSNotification *)inNotification;
@end

@implementation CBetterCoreDataManager

@synthesize defaultMergePolicy;

- (void)dealloc
{
[[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:NULL];

[defaultMergePolicy release];
defaultMergePolicy = NULL;
//
[super dealloc];
}


- (NSManagedObjectContext *)newManagedObjectContext
{
NSManagedObjectContext *theManagedObjectContext = [super newManagedObjectContext];
if (self.defaultMergePolicy != NULL)
	theManagedObjectContext.mergePolicy = self.defaultMergePolicy;

if ([NSThread isMainThread] == NO)
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:theManagedObjectContext];

return(theManagedObjectContext);
}

- (void)managedObjectContextDidSaveNotification:(NSNotification *)inNotification
{
if ([NSThread mainThread] != [NSThread currentThread])
	{
	[self performSelectorOnMainThread:@selector(managedObjectContextDidSaveNotification:) withObject:inNotification waitUntilDone:YES];
	return;
	}

@try
	{
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:inNotification];
	[self save];
	}
@catch (NSException * e)
	{
	[self presentError:[NSError errorWithException:e]];
	}
}


@end
