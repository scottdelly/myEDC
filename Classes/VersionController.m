//
//  VersionController.m
//  myEDC
//
//  Created by Scott Delly on 6/15/11.
//  Copyright 2011 Scott Delly. All rights reserved.
//

#import "VersionController.h"


@implementation VersionController
@synthesize managedObjectContext, entity, error;


-(void)updateVersionEntity:(NSDictionary *)newVersionDictionary{
	Version *versionInDB;
    NSMutableArray *existingVersionList = self.fetchVersions;
	if ([existingVersionList count]>0) {
		NSLog(@"Version exists.  Updating");
		versionInDB = [existingVersionList objectAtIndex:0];
	} else {
		NSLog(@"Version is new.  Adding");
		versionInDB = [NSEntityDescription insertNewObjectForEntityForName:@"Version" inManagedObjectContext:self.managedObjectContext];
	}
	
	versionInDB.daysVersion = [newVersionDictionary objectForKey:DAYS_VER_KEY];
    versionInDB.stagesVersion = [newVersionDictionary objectForKey:STAGES_VER_KEY];
    versionInDB.artistsVersion = [newVersionDictionary objectForKey:ARTISTS_VER_KEY];
	versionInDB.performancesVersion = [newVersionDictionary objectForKey:PERF_VER_KEY];
    
	if (![managedObjectContext save:&error]) {
		NSLog(@"Unable to save new version to database: %@", [error localizedDescription]);
	}

}

-(NSMutableArray *) fetchVersions{
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSLog(@"Fetching Version Infromation");
	NSMutableArray *mutableFetchResults = [[[managedObjectContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
	[request release];
	if (mutableFetchResults == nil) {
		//Handle the error
		NSLog(@"Cant load existing version data!");
	}
    return mutableFetchResults;
}

- (void)dealloc{
	[managedObjectContext release];
	[entity release];
	[error release];
	[super dealloc];
}

@end
