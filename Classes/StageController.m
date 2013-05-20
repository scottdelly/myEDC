//
//  StageController.m
//  myEDC
//
//  Created by Scott Delly on 6/10/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import "StageController.h"


@implementation StageController
@synthesize managedObjectContext, entity, error;

- (id) init{
	if (self = [super init]) {
		myEDCAppDelegate *appDelegate = (myEDCAppDelegate*)[[UIApplication sharedApplication] delegate];
		self.managedObjectContext = appDelegate.managedObjectContext;
		self.entity = [NSEntityDescription entityForName:@"Stage" inManagedObjectContext:self.managedObjectContext];
	}
	return self;
}

- (void) addStage:(NSDictionary *)newStageDictionary{
	int stageID = [[newStageDictionary objectForKey:STAGE_ID_KEY] intValue];
	NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"stageID == %i", stageID];
	NSMutableArray *existingStageList = [self fetchStagesWithSort:nil andPredicate:idPredicate];
	Stage *stageInDB;
	if ([existingStageList count]>0) {
		NSLog(@"Stage exists.  Updating");
		stageInDB = [existingStageList objectAtIndex:0];
	} else {
		NSLog(@"Stage is new.  Adding");
		stageInDB = [NSEntityDescription insertNewObjectForEntityForName:@"Stage" inManagedObjectContext:self.managedObjectContext];
		stageInDB.stageID = [NSNumber numberWithInt:stageID];
	}
	
	stageInDB.name = [newStageDictionary objectForKey:STAGE_NAME_KEY];
	stageInDB.updated = [NSNumber numberWithBool:YES];

	if (![managedObjectContext save:&error]) {
		NSLog(@"Unable to save new stage %@ to database: %@", [newStageDictionary objectForKey:STAGE_NAME_KEY], [error localizedDescription]);
	}
}

- (void) deleteStage:(Stage *)oldStage{
	int stageID = [oldStage.stageID intValue];
	NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"stageID == %i", stageID];
	NSMutableArray *existingStageList = [self fetchStagesWithSort:nil andPredicate:idPredicate];
	Stage *stageInDB;
	if ([existingStageList count]>0) {
		NSLog(@"Deleting %@ %@", oldStage.stageID, oldStage.name);
		stageInDB = [existingStageList objectAtIndex:0];
		[self.managedObjectContext deleteObject:stageInDB];
	} else {
		NSLog(@"Stage to delete is not in DB!");
	}
	
}

- (NSMutableArray *) fetchStagesWithSort:(NSArray *)newSort andPredicate:(NSPredicate *)newPredicate andLimit:(int)newLimit{
	
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
		NSLog(@"Cant load existing stage data!");
	}
	return mutableFetchResults;
}

- (int) numberOfStages{
	NSMutableArray *stageArray = [[self fetchStagesWithSort:nil andPredicate:nil] retain];
	int stageCount = [stageArray count];
	[stageArray release];
	return stageCount;
}

- (void)dealloc{
	[managedObjectContext release];
	[entity release];
	[error release];
	[super dealloc];
}

@end
