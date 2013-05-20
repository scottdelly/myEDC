//
//  ArtistController.m
//  myEDC
//
//  Created by Scott Delly on 6/8/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import "ArtistController.h"


@implementation ArtistController

@synthesize managedObjectContext, entity, error;

- (id) init{
	if (self == [super init]) {
		myEDCAppDelegate *appDelegate = (myEDCAppDelegate*)[[UIApplication sharedApplication] delegate];
		self.managedObjectContext = appDelegate.managedObjectContext;
		self.entity = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:self.managedObjectContext];
	}
	return self;
}

- (void) addArtist:(NSDictionary *)newArtistDictionary{
	int artistID = [[newArtistDictionary objectForKey:ARTIST_ID_KEY] intValue];
	NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"artistID == %i", artistID];
	NSMutableArray *existingArtistList = [self fetchArtistsWithSort:nil andPredicate:idPredicate andLimit:1];
	Artist *artistInDB;
	if ([existingArtistList count]>0) {
		NSLog(@"Artist exists.  Updating");
		artistInDB = [existingArtistList objectAtIndex:0];
	} else {
		NSLog(@"Artist is new.  Adding");
		artistInDB = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.managedObjectContext];
		artistInDB.artistID = [NSNumber numberWithInt:artistID];
	}
	artistInDB.name = [newArtistDictionary objectForKey:ARTIST_NAME_KEY];
	
	artistInDB.imageURL = [newArtistDictionary objectForKey:IMAGE_KEY];
	artistInDB.bio = [newArtistDictionary objectForKey:BIO_KEY];
	artistInDB.listenURL = [newArtistDictionary objectForKey:LISTEN_KEY];
	artistInDB.updated = [NSNumber numberWithBool:YES];

	if (![managedObjectContext save:&error]) {
		NSLog(@"Unable to save new artist %@ to database: %@", [newArtistDictionary objectForKey:ARTIST_NAME_KEY], [error localizedDescription]);
	}
}


- (void) deleteArtist:(Artist *)oldArtist{
	int artistID = [oldArtist.artistID intValue];
	NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"artistID == %i", artistID];
	NSMutableArray *existingArtistList = [self fetchArtistsWithSort:nil andPredicate:idPredicate andLimit:1];
	Artist *artistInDB;
	if ([existingArtistList count]>0) {
		NSLog(@"Deleting %@ %@", oldArtist.artistID, oldArtist.name);
		artistInDB = [existingArtistList objectAtIndex:0];
		[self.managedObjectContext deleteObject:artistInDB];
	} else {
		NSLog(@"Artist to delete is not in DB!");
	}
	
}

- (NSMutableArray *) fetchArtistsWithSort:(NSArray *)newSort andPredicate:(NSPredicate *)newPredicate andLimit:(int)newLimit{
	
	NSFetchRequest *request= [[NSFetchRequest alloc] init];
	[request setEntity:self.entity];
	
	[request setSortDescriptors:newSort];
	[request setPredicate:newPredicate];
	[request setFetchLimit:newLimit];

	NSMutableArray *mutableFetchResults = [[[managedObjectContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
	[request release];
	if (mutableFetchResults == nil) {
		//Handle the error
		NSLog(@"Cant load existing artist data!");
	}
	return mutableFetchResults;
}

- (int) numberOfArtists{
	NSMutableArray *artistArray = [[self fetchArtistsWithSort:nil andPredicate:nil andLimit:0] retain];
	int artistCount = [artistArray count];
	[artistArray release];
	return artistCount;
}

- (void)dealloc{
	[managedObjectContext release];
	[entity release];
	[error release];
	[super dealloc];
}

@end
