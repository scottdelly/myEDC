//
//  PerformanceController.m
//  myEDC
//
//  Created by Scott Delly on 6/12/11.
//  Copyright 2011 Scott Delly. All rights reserved.
//

#import "PerformanceController.h"


@implementation PerformanceController

@synthesize managedObjectContext, entity, error;

- (id) init{
	if (self == [super init]) {
		myEDCAppDelegate *appDelegate = (myEDCAppDelegate*)[[UIApplication sharedApplication] delegate];
		self.managedObjectContext = appDelegate.managedObjectContext;
		self.entity = [NSEntityDescription entityForName:@"Performance" inManagedObjectContext:self.managedObjectContext];
	}
	return self;
}

- (void) addPerformance:(NSDictionary *)newPerformanceDictionary{
    int performanceID = [[newPerformanceDictionary objectForKey:PERF_ID_KEY] intValue];
	NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"performanceID == %i", performanceID];
	NSMutableArray *existingPerformanceList = [self fetchPerformancesWithSort:nil andPredicate:idPredicate andLimit:1];
	Performance *performanceInDB;
	if ([existingPerformanceList count]>0) {
		NSLog(@"Performance exists.  Updating");
		performanceInDB = [existingPerformanceList objectAtIndex:0];
	} else {
		NSLog(@"Performance is new.  Adding");
		performanceInDB = [NSEntityDescription insertNewObjectForEntityForName:@"Performance" inManagedObjectContext:self.managedObjectContext];
		performanceInDB.performanceID = [NSNumber numberWithInt:performanceID];
	}

	performanceInDB.artist = [newPerformanceDictionary objectForKey:ARTIST_KEY];

    int performanceStageID = [[newPerformanceDictionary objectForKey:STAGE_KEY] intValue];
    
    NSLog(@"Fetching Stages");
    StageController *stageController = [[StageController alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stageID == %i", performanceStageID];
    NSMutableArray *stageList = [[stageController fetchStagesWithSort:nil andPredicate:predicate] retain];
    [stageController release];
    
    if ([stageList count] > 0) {
        performanceInDB.stage = [stageList objectAtIndex:0];
        NSLog(@"Stage: %@ found for performance: %@", performanceInDB.stage.name, performanceInDB.performanceID);
    } else {
        NSLog(@"Stage not found for performance: %@", performanceInDB.performanceID);
        performanceInDB.stage = nil;
    }
    [stageList release];
    
    performanceInDB.startTime = [NSNumber numberWithDouble:[[newPerformanceDictionary objectForKey:PERF_START_KEY] timeIntervalSince1970]];
    performanceInDB.stopTime = [NSNumber numberWithDouble:[[newPerformanceDictionary objectForKey:PERF_STOP_KEY] timeIntervalSince1970]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE h:mm a"];
    performanceInDB.startTimeString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[performanceInDB.startTime doubleValue]]];
    performanceInDB.stopTimeString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[performanceInDB.stopTime doubleValue]]];
    [dateFormatter release];
 /* TODO: Add day model info   
    performanceInDB.playDay = [NSNumber numberWithInt:[EDCDate dayNumberFromIntervalSince1970:[performanceInDB.startTime doubleValue]]];
    if ([performanceInDB.startTime doubleValue] > [EDCDate edcEndTimeIntervalSince1970]) {
        performanceInDB.status = @"Cancelled";
    } else {
        performanceInDB.status = [NSString stringWithFormat:@"%@ on %@", performanceInDB.startTimeString, performanceInDB.stage.name];
    }
  */
    performanceInDB.updated = [NSNumber numberWithBool:YES];
    
	if (![managedObjectContext save:&error]) {
		NSLog(@"Unable to save new performance %@ to database: %@", [newPerformanceDictionary objectForKey:PERF_ID_KEY], [error localizedDescription]);
	}
}

- (void) selectPerformance:(Performance *)selectedPerformance withSelection:(BOOL)isSelected{
	selectedPerformance.selected = [NSNumber numberWithBool:isSelected];
	[self discoverConflicts];
}

- (void) deletePerformance:(Performance *)oldPerformance{
    int performanceID = [oldPerformance.performanceID intValue];
	NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"performanceID == %i", performanceID];
	NSMutableArray *existingPerformanceList = [self fetchPerformancesWithSort:nil andPredicate:idPredicate andLimit:1];
	Performance *performanceInDB;
	if ([existingPerformanceList count]>0) {
		NSLog(@"Deleting %@ %@", oldPerformance.performanceID, oldPerformance.performanceID);
		performanceInDB = [existingPerformanceList objectAtIndex:0];
		[self.managedObjectContext deleteObject:performanceInDB];
	} else {
		NSLog(@"Performance to delete is not in DB!");
	}
}

- (NSMutableArray *) fetchPerformancesWithSort:(NSArray *)newSort andPredicate:(NSPredicate *)newPredicate andLimit:(int)newLimit{
	NSFetchRequest *request= [[NSFetchRequest alloc] init];
	[request setEntity:self.entity];
	
	[request setSortDescriptors:newSort];
	[request setPredicate:newPredicate];
    if (newLimit > 0){
        [request setFetchLimit:newLimit];
    }
	NSMutableArray *mutableFetchResults = [[[managedObjectContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
	[request release];
	if (mutableFetchResults == nil) {
		//Handle the error
		NSLog(@"Cant load existing performance data!");
	}
	return mutableFetchResults;
}

- (NSMutableArray *) getPerformancesForArtist:(Artist *)artist{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDescriptor, nil];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"artist.artistID == %i", artist.artistID];
    return [self fetchPerformancesWithSort:sortDescriptors andPredicate:predicate andLimit:0];
}

- (NSMutableArray *) getPerformancesForStage:(Stage *)stage{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDescriptor, nil];
    [sortDescriptor release];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stage.stageID == %i", stage.stageID];
    return [self fetchPerformancesWithSort:sortDescriptors andPredicate:predicate andLimit:0];
}

- (int) numberOfPerformances{
    NSMutableArray *performanceArray = [[self fetchPerformancesWithSort:nil andPredicate:nil andLimit:0] retain];
	int performanceCount = [performanceArray count];
	[performanceArray release];
	return performanceCount;
}

- (void) discoverConflicts{
	NSLog(@"Releasing all conflicts");
	NSMutableArray *allPerformanceList = [[self fetchPerformancesWithSort:nil andPredicate:nil andLimit:0] retain];
	for (Performance *tmpPerformance in allPerformanceList) {
		tmpPerformance.conflict = [NSNumber numberWithBool:NO];
	}
	[allPerformanceList release];
	
	NSLog(@"Determining new conflicts");
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected == YES"];
	NSMutableArray *selectedPerformanceList = [[self fetchPerformancesWithSort:nil andPredicate:predicate andLimit:0] retain];
	
	for (Performance *tmpPerformance in selectedPerformanceList) {
		NSMutableArray *conflictingPerformancesList = [[self discoverConflictsForPerformance:tmpPerformance] retain];
		if ([conflictingPerformancesList count] > 0) {
			NSLog(@"Conflicting performances found for %@", tmpPerformance.performanceID);
			tmpPerformance.conflict = [NSNumber numberWithBool:YES];
			for (Performance *conflictingPerformance in conflictingPerformancesList) {
				conflictingPerformance.conflict = [NSNumber numberWithBool:YES];
			}
		} else {
			NSLog(@"No conflicts found for %@", tmpPerformance.performanceID);
		}
	}
	[selectedPerformanceList release];
}

- (NSMutableArray *)discoverConflictsForPerformance:(Performance *)mainPerformance{
	NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObjects: dateSortDescriptor, nil];
	[dateSortDescriptor release];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((startTime <= %f && stopTime >=%f) || (startTime <= %f && stopTime >= %f)) && selected == YES" ,
							  [mainPerformance.startTime doubleValue]+900, [mainPerformance.startTime doubleValue]+900, [mainPerformance.stopTime doubleValue]-900, [mainPerformance.stopTime doubleValue]-900];
	NSMutableArray *conflictingPerformanceList = [self fetchPerformancesWithSort:sortDescriptors andPredicate:predicate andLimit:0];
	[conflictingPerformanceList removeObject:mainPerformance];
	return [conflictingPerformanceList autorelease];
}

@end
