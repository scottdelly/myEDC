//
//  myEDCAppDelegate.m
//  myEDC
//
//  Created by Scott Delly on 6/2/10.
//  Copyright Scott Delly 2010. All rights reserved.
//

#import "myEDCAppDelegate.h"

@implementation myEDCAppDelegate

@synthesize window;
@synthesize navigationController, splashViewController, updateController;
@synthesize databaseUpdateTimer;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	NSLog(@"Local time is %@", [NSDate date]);
	NSLog(@"Unix time is %f", [[NSDate date] timeIntervalSince1970]);
	
	double appTime = [EDCDate currentTimeIntervalSince1970];
	
	NSDate *tmpDate = [NSDate dateWithTimeIntervalSince1970:appTime];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEE h:mm a"];
	NSString *formattedDate = [dateFormatter stringFromDate:tmpDate];
	[dateFormatter release];
	
	NSLog(@"App Time is %f\n%@", appTime, formattedDate);
		
    // Override point for customization after app launch
	

	
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
	
	self.splashViewController = [navigationController visibleViewController];
	
    NSTimer *newTimer = [NSTimer scheduledTimerWithTimeInterval: 600.0
                                                         target: self
                                                       selector: @selector(updateDatabaseOnline:)
                                                       userInfo: nil
                                                        repeats: YES];
	self.databaseUpdateTimer = newTimer;
    self.updateController.navigationController = self.navigationController;
}

- (void) updateDatabaseOnline:(NSTimer *)timer{
    NSLog(@"Update Database Online Now");
	[self.updateController beginDatabaseUpdate];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"myEDC has encountered an error from which it cannot recover.  myEDC will now crash." delegate:self cancelButtonTitle:nil otherButtonTitles:@":(",nil];
			[alert show];
			exit(1);
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"myEDC.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"myEDC has encountered an error from which it cannot recover.  myEDC will now crash." delegate:self cancelButtonTitle:nil otherButtonTitles:@":(",nil];
		[alert show];
		exit(1);
    }    
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	[window release];
	[splashViewController release];
	[databaseUpdateTimer release];
	[super dealloc];
}


@end

