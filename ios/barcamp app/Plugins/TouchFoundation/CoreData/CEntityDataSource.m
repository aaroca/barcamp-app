//
//  CEntityDataSource.m
//  TouchCode
//
//  Created by Jonathan Wight on 5/5/09.
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

#import "CEntityDataSource.h"

@interface CEntityDataSource ()
@property (readwrite, nonatomic, retain) NSArray *items;
@end

@implementation CEntityDataSource

@synthesize managedObjectContext;
@synthesize entityDescription;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)inManagedObjectContext entityDescription:(NSEntityDescription *)inEntityDescription
{
if ((self = [self init]) != NULL)
	{
	self.managedObjectContext = inManagedObjectContext;
	self.entityDescription = inEntityDescription;
	}
return(self);
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)inManagedObjectContext entityName:(NSString *)inEntityName
{
NSEntityDescription *theEntityDescription = [NSEntityDescription entityForName:inEntityName inManagedObjectContext:inManagedObjectContext];
if ((self = [self initWithManagedObjectContext:inManagedObjectContext entityDescription:theEntityDescription]) != NULL)
	{
	}
return(self);
}

- (void)dealloc
{
self.managedObjectContext = NULL;
self.entityDescription = NULL;
self.predicate = NULL;
self.items = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSPredicate *)predicate
{
return(predicate);
}

- (void)setPredicate:(NSPredicate *)inPredicate
{
if (predicate != inPredicate)
	{
	[predicate autorelease];
	predicate = [inPredicate retain];
	//
	self.items = NULL;
    }
}

- (NSArray *)sortDescriptors
{
return(sortDescriptors);
}

- (void)setSortDescriptors:(NSArray *)inSortDescriptors
{
if (sortDescriptors != inSortDescriptors)
	{
	[sortDescriptors autorelease];
	sortDescriptors = [inSortDescriptors retain];
	//
	self.items = NULL;
    }
}

- (NSArray *)items
{
if (items == NULL)
	{
	[self fetch:NULL];
	}
return(items);
}

- (void)setItems:(NSArray *)inItems
{
if (items != inItems)
	{
	[items autorelease];
	items = [inItems retain];
    }
}

- (BOOL)fetch:(NSError **)outError
{
NSFetchRequest *theRequest = [[[NSFetchRequest alloc] init] autorelease];
[theRequest setEntity:self.entityDescription];
if (self.sortDescriptors)
	[theRequest setSortDescriptors:self.sortDescriptors];
if (self.predicate)
	[theRequest setPredicate:self.predicate];

NSArray *theArray = [self.managedObjectContext executeFetchRequest:theRequest error:outError];

self.items = theArray;

return(theArray != NULL);
}

@end
