//
//  CCoreDataManager.m
//  TouchCode
//
//  Created by Jonathan Wight on 3/3/07.
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

#import "CCoreDataManager.h"

#if TARGET_OS_IPHONE == 1
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#define THREAD_PARANOIA 1

@interface CCoreDataManager ()
@property (readonly, retain) id threadStorageKey;

- (NSPersistentStoreCoordinator *)newPersistentStoreCoordinatorWithOptions:(NSDictionary *)inOptions error:(NSError **)outError;

+ (NSURL *)modelURLForName:(NSString *)inName;
+ (NSURL *)persistentStoreURLForName:(NSString *)inName storeType:(NSString *)inStoreType forceReplace:(BOOL)inForceReplace;
+ (NSString *)applicationSupportFolder;
- (id)threadStorageKey;

- (void)applicationWillTerminate:(NSNotification *)inNotification;
@end

#pragma mark -

@implementation CCoreDataManager

@synthesize name;
@synthesize storeType;
@synthesize forceReplace;
@synthesize storeOptions;
@synthesize persistentStoreCoordinator;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize threadStorageKey;
@synthesize delegate;

#if 0
+ (void)load
{
#warning Setting core data debugging

NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

[[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"com.apple.CoreData.ThreadingDebug"];

[thePool release];
}
#endif

- (id)init
{
if ((self = [super init]) != NULL)
	{
	#if TARGET_OS_IPHONE == 1
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];
	#else
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:[NSApplication sharedApplication]];
	#endif

	storeType = NSSQLiteStoreType;
	}
return(self);
}

- (void)dealloc
{
#if TARGET_OS_IPHONE == 1
[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];
#else
[[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationWillTerminateNotification object:[NSApplication sharedApplication]];
#endif

[self save];

self.modelURL = NULL;
self.persistentStoreURL = NULL;
self.storeType = NULL;
self.storeOptions = NULL;

[name release];
name = NULL;
[persistentStoreCoordinator release];
persistentStoreCoordinator = NULL;
[managedObjectModel release];
managedObjectModel = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSURL *)modelURL
{
if (modelURL == NULL && self.name != NULL)
	{
	modelURL = [[self class] modelURLForName:self.name];
	}
return(modelURL);
}

- (void)setModelURL:(NSURL *)inModelURL
{
if (modelURL != inModelURL)
	{
	[modelURL release];
	modelURL = [inModelURL retain];
	}
}

- (NSURL *)persistentStoreURL
{
if (persistentStoreURL == NULL && self.name != NULL)
	{
	persistentStoreURL = [[[self class] persistentStoreURLForName:self.name storeType:self.storeType forceReplace:self.forceReplace] retain];
	}
return(persistentStoreURL);
}

- (void)setPersistentStoreURL:(NSURL *)inPersistentStoreURL
{
if (persistentStoreURL != inPersistentStoreURL)
	{
	[persistentStoreURL release];
	persistentStoreURL = [inPersistentStoreURL retain];
	}
}

- (NSManagedObjectModel *)managedObjectModel
{
@synchronized(self)
	{
	if (managedObjectModel == NULL)
		{
//		NSLog(@"Creating MOM: %@", [self.modelURL.path lastPathComponent]);
		NSAssert([[NSFileManager defaultManager] fileExistsAtPath:self.modelURL.path], @"MOM file doesn't exist.");
		managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
		}
	}
return(managedObjectModel);
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
@synchronized(self)
	{
	if (persistentStoreCoordinator == NULL)
		{
		persistentStoreCoordinator = [[self newPersistentStoreCoordinatorWithOptions:self.storeOptions error:NULL] retain];

//		#if THREAD_PARANOIA == 1
//		NSAssert([NSThread isMainThread] == YES, @"Should not create persistentStoreCoordinate from non-main thread");
//		#endif /* THREAD_PARANOIA == 1 */

		}
	}

return(persistentStoreCoordinator);
}

- (NSPersistentStoreCoordinator *)newPersistentStoreCoordinatorWithOptions:(NSDictionary *)inOptions error:(NSError **)outError
{
NSPersistentStoreCoordinator *thePersistentStoreCoordinator = NULL;

NSError *theError = NULL;
NSManagedObjectModel *theManagedObjectModel = self.managedObjectModel;
if (theManagedObjectModel == NULL)
	return(NULL);
thePersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:theManagedObjectModel];
NSPersistentStore *thePersistentStore = [thePersistentStoreCoordinator addPersistentStoreWithType:self.storeType configuration:NULL URL:self.persistentStoreURL options:inOptions error:&theError];
if (thePersistentStore == NULL)
	{
	[self presentError:theError];
	}

if (outError)
	*outError = theError;
return(thePersistentStoreCoordinator);
}

- (NSManagedObjectContext *)managedObjectContext
{
NSManagedObjectContext *theManagedObjectContext = NULL;

NSString *theThreadStorageKey = [self threadStorageKey];

theManagedObjectContext = [[[NSThread currentThread] threadDictionary] objectForKey:theThreadStorageKey];
if (theManagedObjectContext == NULL)
	{
	theManagedObjectContext = [[self newManagedObjectContext] autorelease];
	if (theManagedObjectContext == NULL)
		return(NULL);
	[[[NSThread currentThread] threadDictionary] setObject:theManagedObjectContext forKey:theThreadStorageKey];
	}
return(theManagedObjectContext);
}

#pragma mark -

- (NSManagedObjectContext *)newManagedObjectContext
{
NSPersistentStoreCoordinator *thePersistentStoreCoordinator = self.persistentStoreCoordinator;
NSAssert(thePersistentStoreCoordinator != NULL, @"No persistent store coordinator!");
NSManagedObjectContext *theManagedObjectContext = [[NSManagedObjectContext alloc] init];
[theManagedObjectContext setPersistentStoreCoordinator:thePersistentStoreCoordinator];

if (self.delegate && [self.delegate respondsToSelector:@selector(coreDataManager:didCreateNewManagedObjectContext:)])
	[self.delegate coreDataManager:self didCreateNewManagedObjectContext:theManagedObjectContext];

return(theManagedObjectContext);
}

- (BOOL)migrate:(NSError **)outError;
{
BOOL theResult = NO;
@synchronized(self)
	{
	NSAssert(persistentStoreCoordinator == NULL, @"Cannot migrate persistent store with it already open.");

	NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

	NSDictionary *theOptions = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
		NULL];

	NSError *theError = NULL;
	[[self newPersistentStoreCoordinatorWithOptions:theOptions error:&theError] autorelease];

	if (theError)
		[theError retain];

	[thePool release];

	if (theError)
		[theError autorelease];

	if (outError)
		*outError = theError;

	theResult = theError == NULL;
    }

return(theResult);
}

- (BOOL)save:(NSError **)outError;
{
BOOL theResult = NO;

[self.managedObjectContext lock];

#if TARGET_OS_IPHONE == 0
[self.managedObjectContext commitEditing];
#endif

if ([self.managedObjectContext hasChanges] == NO)
	theResult = YES;
else
	{
	[self.managedObjectContext processPendingChanges];
	theResult = [self.managedObjectContext save:outError];
	}

[self.managedObjectContext unlock];

return(theResult);
}

- (void)save
{
NSError *theError = NULL;
if ([self save:&theError] == NO)
	{
	[self presentError:theError];
	}
}

#pragma mark -

- (void)presentError:(NSError *)inError
{
if (self.delegate && [self.delegate respondsToSelector:@selector(coreDataManager:presentError:)])
	{
	[self.delegate coreDataManager:self presentError:inError];
	}
else
	{
	#if TARGET_OS_IPHONE == 1
	fprintf(stderr, "ERROR: %s (%s)\n", [[inError description] UTF8String], [[inError.userInfo description] UTF8String]);
	#else
	[[NSApplication sharedApplication] presentError:inError];
	#endif
	}
}

- (void)applicationWillTerminate:(NSNotification *)inNotification
{
#pragma unused (inNotification)

[self save];
}

#pragma mark -

+ (NSURL *)modelURLForName:(NSString *)inName
{
	//Prefer momd due to bug: http://iphonedevelopment.blogspot.com/2009/09/core-data-migration-problems.html?showComment=1288228237972#c8106487879723961055
NSString *theModelPath = [[NSBundle mainBundle] pathForResource:inName ofType:@"momd"];
if (theModelPath == NULL)
	theModelPath = [[NSBundle mainBundle] pathForResource:inName ofType:@"mom"];
NSURL *theModelURL = [NSURL fileURLWithPath:theModelPath];
return(theModelURL);
}

+ (NSURL *)persistentStoreURLForName:(NSString *)inName storeType:(NSString *)inStoreType forceReplace:(BOOL)inForceReplace
{
inStoreType = inStoreType ? inStoreType : NSSQLiteStoreType;

NSString *thePathExtension = NULL;
if ([inStoreType isEqualToString:NSSQLiteStoreType])
	thePathExtension = @"sqlite";
else if ([inStoreType isEqualToString:NSBinaryStoreType])
	thePathExtension = @"db";

NSString *theStorePath = [[self applicationSupportFolder] stringByAppendingPathComponent:[inName stringByAppendingPathExtension:thePathExtension]];

if (inForceReplace == YES)
	{
	NSError *theError = NULL;
	if ([[NSFileManager defaultManager] fileExistsAtPath:theStorePath] == YES)
		{
		[[NSFileManager defaultManager] removeItemAtPath:theStorePath error:&theError];
		}
	}

if ([[NSFileManager defaultManager] fileExistsAtPath:theStorePath] == NO)
	{
	NSError *theError = NULL;
	NSString *theSourceFile = [[NSBundle mainBundle] pathForResource:inName ofType:thePathExtension];
	if ([[NSFileManager defaultManager] fileExistsAtPath:theSourceFile] == YES)
		{
		BOOL theResult = [[NSFileManager defaultManager] copyItemAtPath:theSourceFile toPath:theStorePath error:&theError];
		if (theResult == NO)
			{
			return(NULL);
			}
		}
	}

NSURL *thePersistentStoreURL = [NSURL fileURLWithPath:theStorePath];

return(thePersistentStoreURL);
}

+ (NSString *)applicationSupportFolder
{
NSArray *thePaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
NSString *theBasePath = ([thePaths count] > 0) ? [thePaths objectAtIndex:0] : NSTemporaryDirectory();

NSString *theBundleName = [[[[NSBundle mainBundle] bundlePath] lastPathComponent] stringByDeletingPathExtension];
NSString *theApplicationSupportFolder = [theBasePath stringByAppendingPathComponent:theBundleName];

if ([[NSFileManager defaultManager] fileExistsAtPath:theApplicationSupportFolder] == NO)
	{
	NSError *theError = NULL;
	if ([[NSFileManager defaultManager] createDirectoryAtPath:theApplicationSupportFolder withIntermediateDirectories:YES attributes:NULL error:&theError] == NO)
		return(NULL);
	}

return(theApplicationSupportFolder);
}

- (id)threadStorageKey
{
@synchronized(self)
	{
	if (threadStorageKey == NULL)
		{
		threadStorageKey = [[NSString alloc] initWithFormat:@"%@:%p", NSStringFromClass([self class]), self];
		}
	}
return(threadStorageKey);
}

@end
