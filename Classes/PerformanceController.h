//
//  PerformanceController.h
//  myEDC
//
//  Created by Scott Delly on 6/12/11.
//  Copyright 2011 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myEDCAppDelegate.h"
#import "EDCDate.h"
#import "PerformanceConstants.h"
#import "Performance.h"
@class Performance;
#import "Stage.h"
@class Stage;
#import "Artist.h"
@class Artist;

@interface PerformanceController : NSObject {
	NSManagedObjectContext *managedObjectContext;
	NSEntityDescription *entity;
	NSError *error;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSEntityDescription *entity;
@property (nonatomic, retain) NSError *error;

- (void) addPerformance:(NSDictionary *)newPerformanceDictionary;
- (void) selectPerformance:(Performance *)selectedPerformance withSelection:(BOOL)isSelected;
- (void) deletePerformance:(Performance *)oldPerformance;
- (NSMutableArray *) fetchPerformancesWithSort:(NSArray *)newSort andPredicate:(NSPredicate *)newPredicate andLimit:(int)newLimit;
- (NSMutableArray *) getPerformancesForArtist:(Artist *)artist;
- (NSMutableArray *) getPerformancesForStage:(Stage *)stage;
- (int) numberOfPerformances;

- (void) discoverConflicts;
- (NSMutableArray *) discoverConflictsForPerformance:(Performance *)mainPerformance;

@end
