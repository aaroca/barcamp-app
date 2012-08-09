//
//  CCoreDataManager.h
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

#import <CoreData/CoreData.h>

@protocol CCoreDataManagerDelegate;

@interface CCoreDataManager : NSObject {
	NSString *name;
	NSURL *modelURL;
	NSURL *persistentStoreURL;
	NSString *storeType;
	BOOL forceReplace;
	NSDictionary *storeOptions;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
	id threadStorageKey;
	id <CCoreDataManagerDelegate> delegate;
}

+ (NSURL *)modelURLForName:(NSString *)inName;

@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSURL *modelURL;
@property (readwrite, retain) NSURL *persistentStoreURL;
@property (readwrite, retain) NSString *storeType;
@property (readwrite, assign) BOOL forceReplace;
@property (readwrite, retain) NSDictionary *storeOptions;

@property (readwrite, nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readwrite, nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (readwrite, nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (readwrite, assign) id <CCoreDataManagerDelegate> delegate;

- (id)init;

/// You don't need to call this. Subclasses can override to change default behavior.
- (NSManagedObjectContext *)newManagedObjectContext;

- (BOOL)migrate:(NSError **)outError;

- (BOOL)save:(NSError **)outError;
- (void)save;

- (void)presentError:(NSError *)inError;

@end

#pragma mark -

@protocol CCoreDataManagerDelegate <NSObject>

@optional
- (void)coreDataManager:(CCoreDataManager *)inCoreDataManager didCreateNewManagedObjectContext:(NSManagedObjectContext *)inManagedObjectContext;
- (void)coreDataManager:(CCoreDataManager *)inCoreDataManager presentError:(NSError *)inError;

@end
