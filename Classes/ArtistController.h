//
//  ArtistController.h
//  myEDC
//
//  Created by Scott Delly on 6/8/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myEDCAppDelegate.h"
#import "EDCDate.h"
#import "ArtistConstants.h"
#import "Artist.h"
@class Artist;

@interface ArtistController : NSObject {
	NSManagedObjectContext *managedObjectContext;
	NSEntityDescription *entity;
	NSError *error;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSEntityDescription *entity;
@property (nonatomic, retain) NSError *error;

- (void) addArtist:(NSDictionary *)newArtistDictionary;
- (void) deleteArtist:(Artist *)oldArtist;
- (NSMutableArray *) fetchArtistsWithSort:(NSArray *)newSort andPredicate:(NSPredicate *)newPredicate andLimit:(int)newLimit;
- (int) numberOfArtists;

@end
