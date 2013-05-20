//
//  UpdateController.h
//  myEDC
//
//  Created by Scott Delly on 6/9/11.
//  Copyright 2011 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VersionController.h"
@class VersionController;
#import "ArtistController.h"
@class ArtistController;
#import "StageController.h"
@class StageController;
#import "PerformanceController.h"
@class PerformanceController;
#import "DayController.h"
@class DayController;
#import "Artist.h"
@class Artist;
#import "Stage.h"
@class Stage;
#import "Performance.h"
@class Performance;
#import "Day.h"
@class Day;
#import "Version.h"
@class Version;
#import "EDCDate.h"
#import "RootViewController.h"
#import "Reachability.h"

@interface UpdateController : NSObject {
	NSManagedObjectContext *managedObjectContext;
    NSEntityDescription *entity;
	NSError *error;
    UINavigationController *navigationController;
    
	ArtistController *artistController;
	StageController *stageController;
    PerformanceController *performanceController;
    DayController *dayController;
    VersionController *versionController;

    Version *versionInDB;

	NSString *internetReachability;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSEntityDescription *entity;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) UINavigationController *navigationController;

@property (nonatomic, retain) ArtistController *artistController;
@property (nonatomic, retain) StageController *stageController;
@property (nonatomic, retain) PerformanceController *performanceController;
@property (nonatomic, retain) DayController *dayController;
@property (nonatomic, retain) VersionController *versionController;

@property (nonatomic, retain) Version *versionInDB;

- (void)beginDatabaseUpdate;

- (void)checkForUpdates;
- (void)updateVersion;
- (void)updateDays;
- (void)updateStages;
- (void)updateArtists;
- (void)updatePerformances;

- (BOOL)isUpToDate;

- (BOOL)checkInternet;

@end
