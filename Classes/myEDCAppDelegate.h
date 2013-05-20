//
//  myEDCAppDelegate.h
//  myEDC
//
//  Created by Scott Delly on 6/2/10.
//  Copyright Scott Delly 2010. All rights reserved.
//

#import "EDCDate.h"
#import "UpdateController.h"
@class UpdateController;

@interface myEDCAppDelegate : NSObject <UIApplicationDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
	
	UINavigationController *navigationController;
	
	UIViewController *splashViewController;
    UpdateController *updateConntroller;
	NSTimer *databaseUpdateTimer;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) UIViewController *splashViewController;
@property (nonatomic, retain) UpdateController *updateController;

@property (nonatomic, retain) NSTimer *databaseUpdateTimer;

- (NSString *)applicationDocumentsDirectory;

- (void) updateDatabaseOnline:(NSTimer *)timer;

@end