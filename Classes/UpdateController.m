//
//  updateController.m
//  myEDC
//
//  Created by Scott Delly on 6/9/11.
//  Copyright 2011 Scott Delly. All rights reserved.
//

#import "UpdateController.h"


@implementation UpdateController

@synthesize managedObjectContext, entity, error;
@synthesize versionController, dayController;
@synthesize navigationController, performanceController, stageController, artistController;
@synthesize versionInDB;

- (void)beginDatabaseUpdate{
	BOOL internetAvailable = self.checkInternet; //Test for Internet
	
	if (internetAvailable == 0) {
		//No internet connection
		NSLog(@"No Internet Connection");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"myEDC cannot connect to the internet to download the latest EDC information." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
	} else {
		//Connected to Internet
		NSLog(@"Internet Connection Available");
        self.checkForUpdates;
        
       // NSLog(@"Done Updating. Database contains %i Performances, %i Artists, %i Stages, and %i days", performanceController.numberOfPerformances,artistController.numberOfArtists, stageController.numberOfStages, dayController.numberofDays);
        
        NSLog(@"Discovering performance conflicts");
        [self.performanceController discoverConflicts];
	}
}

- (void)checkForUpdates{
    NSLog(@"Checking if update is needed.");
    BOOL daysUpdateNeeded = YES;
    BOOL performancesUpdateNeeded = YES;
	BOOL artistsUpdateNeeded = YES;
	BOOL stagesUpdateNeeded = YES;
	
    NSMutableArray *currentVersionArray = [versionController.fetchVersions objectAtIndex:0];
    		
	NSLog(@"Retrieving on-line version data");
	
	NSStringEncoding *enc;
	NSURL *versionURL = [NSURL URLWithString:@"http://www.carnivalapps.com/myedc/2010/versionInfo.txt"];
	NSString *latestVersion = [NSString stringWithContentsOfURL:versionURL usedEncoding:&enc error:&error];//this line needs to have "&enc"
	
	NSArray *versionItems = [latestVersion componentsSeparatedByString:@":"];
	
    int newStagesVersionNumber = [[versionItems objectAtIndex:0] intValue];
    int newArtistsVersionNumber = [[versionItems objectAtIndex:1] intValue];
    
    /* new code
    int newDaysVersionNumber = [[versionItems objectAtIndex:0] intValue];
    int newStagesVersionNumber = [[versionItems objectAtIndex:1] intValue];
	int newArtistsVersionNumber = [[versionItems objectAtIndex:2] intValue];
	int newPerformancesVersionNumber = [[versionItems objectAtIndex:3] intValue];
    */
    
    //NSLog(@"Latest days version is: %i", newDaysVersionNumber);
    NSLog(@"Latest stages version is: %i", newStagesVersionNumber);
	NSLog(@"Latest artists version is: %i", newArtistsVersionNumber);    
	//NSLog(@"Latest performances version is: %i", newPerformancesVersionNumber);
	
	/*
	if ([currentVersionArray count]>0) {
		NSLog(@"Version data exists");
		
		versionInDB = [currentVersionArray objectAtIndex:0];
		NSNumber *artistsVersion = versionInDB.artistsVersion;
		int avNum = [artistsVersion intValue];
		NSNumber *stagesVersion = versionInDB.stagesVersion;
		int svNum = [stagesVersion intValue];
		NSLog(@"Current artists version %i and current stages version %i", avNum, svNum);
        
		artistsUpdateNeeded = (avNum<newArtistsVersionNumber);
		stagesUpdateNeeded = (svNum<newStagesVersionNumber);
		
		versionInDB.artistsVersion = [NSNumber numberWithInt:newArtistsVersionNumber];
		versionInDB.stagesVersion = [NSNumber numberWithInt:newStagesVersionNumber];
		
		if (![managedObjectContext save:&error]) {
			NSLog(@"Unable to save new version information");
		}
		
	} else {
		NSLog(@"Version data does not exist.  Adding");
		Version *newVersion = [NSEntityDescription insertNewObjectForEntityForName:@"Version" inManagedObjectContext:self.managedObjectContext];
		newVersion.artistsVersion = [NSNumber numberWithInt:newArtistsVersionNumber];
		newVersion.stagesVersion = [NSNumber numberWithInt:newStagesVersionNumber];
		
		if (![managedObjectContext save:&error]) {
			NSLog(@"Unable to save new version information");
		}
	}
     */
	[versionItems release];
    
    /*if (stagesUpdateNeeded){
        [self updateStages];
    }
    
    if (artistsUpdateNeeded){
        [self updateArtists];
    }*/
    [self updateStages];
    [self updateArtists];
    return nil;
}

- (void)updateDays{
    
}
- (void)updateVersion{
    
}

- (void)updateArtists{
    NSLog(@"Updating Artists");
    //get artistList from artist controller		
    
    NSMutableArray *existingArtistList = [[artistController fetchArtistsWithSort:nil andPredicate:nil andLimit:0] retain];
    
    NSLog(@"Removing 'Updated' flag on %i artists", [existingArtistList count]);
    for (Artist *tmp in existingArtistList) {
        tmp.updated = [NSNumber numberWithBool:NO];
    }
    NSMutableArray *artistListArray= [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.carnivalapps.com/myedc/2010/artists.plist"]];
    
    for(NSDictionary *dict in artistListArray){
        NSLog(@"Adding artist %@", [dict objectForKey:ARTIST_NAME_KEY]);
        [artistController addArtist:dict];
    }
    [artistListArray release];
    [existingArtistList release];
    
    NSLog(@"Searching for outdated artists");
    
    NSPredicate *outdatedPredicate = [NSPredicate predicateWithFormat:@"updated==%@", [NSNumber numberWithBool:NO]];
    NSMutableArray *outdatedArtistList = [[artistController fetchArtistsWithSort:nil andPredicate:outdatedPredicate andLimit:0] retain];
    
    NSLog(@"Deleting %i old artists", [outdatedArtistList count]);
    for(Artist *oldArtist in outdatedArtistList){
        [artistController deleteArtist:oldArtist];
    }
    
    [outdatedArtistList release];
}

- (void)updateStages{
    NSLog(@"Downloading Stages");
    NSMutableArray *stageListArray = [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.carnivalapps.com/myedc/2010/stages.plist"]];	
    
    NSLog(@"Updating Stages");
    NSMutableArray *existingStageList = [[self.stageController fetchStagesWithSort:nil andPredicate:nil] retain];
    
    NSLog(@"Removing 'Updated' flag on all stages");
    for (Stage *tmp in existingStageList) {
        tmp.updated = [NSNumber numberWithBool:NO];
    }
    for(NSDictionary *dict in stageListArray){
        NSLog(@"Adding Stage %@", [dict objectForKey:STAGE_NAME_KEY]);
        [stageController addStage:dict];
    }
    [existingStageList release];
    [stageListArray release];
    
    NSLog(@"Searching for outdated stages");
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"updated==%@", [NSNumber numberWithBool:NO]];
    NSMutableArray *outdatedStageList = [[stageController fetchStagesWithSort:nil andPredicate:predicate] retain];
    
    NSLog(@"Deleting %i old stages", [outdatedStageList count]);
    for(Stage *del in outdatedStageList){
        [stageController deleteStage:del];
    }
    [outdatedStageList release];
}
- (void)updatePerformances{
    
}

- (void)updateVisibleViewControllerWithNewInfo{
    UIViewController *visibleViewController = [navigationController visibleViewController];
	NSLog(@"Calling update on %@", [visibleViewController nibName]);
	[visibleViewController update];
}

- (BOOL)isUpToDate{
    return false;
}


#pragma mark -
#pragma mark Checking Internet Connection

-(BOOL)checkInternet{
    //Test for Internet Connection
    NSLog(@"——–");NSLog(@"Testing Internet Connectivity");
    Reachability *r = [Reachability reachabilityWithHostName:@"www.carnivalapps.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    BOOL internet;
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
        internet = NO;
    } else {
        internet = YES;
    }
    return internet;
}

- (void)dealloc {
	[managedObjectContext release];
	[artistController release];
	[stageController release];
    [super dealloc];
}



@end
