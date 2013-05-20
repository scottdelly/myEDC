//
//  DayController.h
//  myEDC
//
//  Created by Scott Delly on 6/15/11.
//  Copyright 2011 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myEDCAppDelegate.h"
#import "EDCDate.h"
#import "Day.h"
#import "DayConstants.h"

@interface DayController : NSObject {
   	NSManagedObjectContext *managedObjectContext;
	NSEntityDescription *entity;
	NSError *error; 
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSEntityDescription *entity;
@property (nonatomic, retain) NSError *error;

- (void) addDay:(NSDictionary *)newDayDictionary;
- (void) deleteDay:(Day *)oldDay;

- (NSMutableArray *) fetchDaysWithSort:(NSArray *)newSort andPredicate:(NSPredicate *)newPredicate;
- (int) numberOfDays;

@end
