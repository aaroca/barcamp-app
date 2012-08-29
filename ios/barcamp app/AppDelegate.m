//
//  AppDelegate.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "AppDelegate.h"

#import "NewsViewController.h"
#import "TracksViewController.h"
#import "HeadquarterViewController.h"
#import "FTShare.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize share = _share;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    // Init social share library.
    self.share = [[FTShare alloc] initWithReferencedController:nil];
    
    // Create News section view controller.
    NewsViewController* newsViewController = [[NewsViewController alloc] initWithNibName:@"NewsView" bundle:nil];
    newsViewController.title = @"Noticias";
    UINavigationController* newsNavigationViewController = [[UINavigationController alloc] initWithRootViewController:newsViewController];
    newsNavigationViewController.navigationBar.tintColor = [UIColor colorWithRed:0.718 green:0.278 blue:0.298 alpha:1] /*#b7474c*/;
    newsNavigationViewController.tabBarItem.image = [UIImage imageNamed:@"news.png"];
    [newsViewController release];
    
    // Create Tracks section view controller.
    TracksViewController* tracksViewController = [[TracksViewController alloc] initWithNibName:@"TracksView" bundle:nil];
    tracksViewController.title = @"Ponencias";
    UINavigationController* tracksNavigationViewController = [[UINavigationController alloc] initWithRootViewController:tracksViewController];
    tracksNavigationViewController.navigationBar.tintColor = [UIColor colorWithRed:0.718 green:0.278 blue:0.298 alpha:1] /*#b7474c*/;
    tracksNavigationViewController.tabBarItem.image = [UIImage imageNamed:@"talks.png"];
    [tracksViewController release];
    
    // Create Headquarter section view controller.
    HeadquarterViewController* headquarterViewController = [[HeadquarterViewController alloc] initWithNibName:@"HeadquarterView" bundle:nil];
    headquarterViewController.title = @"Headquarter";
    UINavigationController* headquarterNavigationViewController = [[UINavigationController alloc] initWithRootViewController:headquarterViewController];
    headquarterNavigationViewController.navigationBar.tintColor = [UIColor colorWithRed:0.718 green:0.278 blue:0.298 alpha:1] /*#b7474c*/;
    headquarterNavigationViewController.tabBarItem.image = [UIImage imageNamed:@"headquarter.png"];
    [headquarterViewController release];
    
    // Create tabbed view controller with all other view controllers.
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = [NSArray arrayWithObjects:newsNavigationViewController, tracksNavigationViewController, headquarterNavigationViewController, nil];
    tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.718 green:0.278 blue:0.298 alpha:1] /*#b7474c*/;
    [newsNavigationViewController release];
    [tracksNavigationViewController release];
    [headquarterNavigationViewController release];
    
    // Set main view controller.
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"barcamp_app" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"barcamp_app.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - URL Handler

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (self.share.facebook) {
        return [self.share.facebook handleOpenURL:url];
    }
    return YES;
}

@end
