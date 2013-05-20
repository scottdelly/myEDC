//
//  DayController.m
//  myEDC
//
//  Created by Scott Delly on 6/15/11.
//  Copyright 2011 Scott Delly. All rights reserved.
//

#import "DayController.h"


@implementation DayController
@synthesize managedObjectContext, entity, error;

- (void) addDay:(NSDictionary *)newDayDictionary{
    int dayID = [[newDayDictionary objectForKey:DAY_ID_KEY] intValue];
	NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"dayID == %i", dayID];
	NSMutableArray *existingDayList = [self fetchDaysWithSort:nil andPredicate:idPredicate];
	Day *dayInDB;
	if ([existingDayList count]>0) {
		NSLog(@"Day exists.  Updating");
		dayInDB = [existingDayList objectAtIndex:0];
	} else {
		NSLog(@"Day is new.  Adding");
		dayInDB = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:self.managedObjectContext];
		dayInDB.dayID = [NSNumber numberWithInt:dayID];
	}
	
	dayInDB.name = [newDayDictionary objectForKey:DAY_NAME_KEY];
    dayInDB.startTime = [newDayDictionary objectForKey:DAY_START_KEY];
    dayInDB.stopTime = [newDayDictionary objectForKey:DAY_STOP_KEY];
	dayInDB.updated = [NSNumber numberWithBool:YES];
    
	if (![managedObjectContext save:&error]) {
		NSLog(@"Unable to save new day %@ to database: %@", [newDayDictionary objectForKey:DAY_NAME_KEY], [error localizedDescription]);
	}
}
- (void) deleteDay:(Day *)oldDay{
    int dayID = [oldDay.dayID intValue];
	NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"dayID == %i", dayID];
	NSMutableArray *existingDayList = [self fetchDaysWithSort:nil andPredicate:idPredicate];
	Day *dayInDB;
	if ([existingDayList count]>0) {
		NSLog(@"Deleting %@ %@", oldDay.dayID, oldDay.name);
		dayInDB = [existingDayList objectAtIndex:0];
		[self.managedObjectContext deleteObject:dayInDB];
	} else {
		NSLog(@"Day to delete is not in DB!");
	}
}

- (NSMutableArray *) fetchDaysWithSort:(NSArray *)newSort andPredicate:(NSPredicate *)newPredicate andLimit:(int)newLimit{
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
	[request setEntity:self.entity];
	
	[request setSortDescriptors:newSort];
	[request setPredicate:newPredicate];
    if (newLimit > 0){
        [request setFetchLimit:newLimit];
    }
	NSLog(@"Fetching with predicate: %@", [newPredicate predicateFormat]);
	
	NSMutableArray *mutableFetchResults = [[[managedObjectContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
	[request release];
	if (mutableFetchResults == nil) {
		//Handle the error
		NSLog(@"Cant load existing day data!");
	}
	return mutableFetchResults;
}

- (int) numberOfDays{
	NSMutableArray *dayArray = [[self fetchDaysWithSort:nil andPredicate:nil andLimit:0] retain];
	int dayCount = [dayArray count];
	[dayArray release];
	return dayCount;
}

- (void)dealloc{
	[managedObjectContext release];
	[entity release];
	[error release];
	[super dealloc];
}

@end
