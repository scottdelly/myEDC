//
//  PerformanceListViewController.h
//  myEDC
//
//  Created by Scott Delly on 6/16/11.
//  Copyright 2011 Scott Delly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerformanceController.h"
#import "Performance.h"
@class Performance;
#import "Artist.h"
@class Artist;
#import "Stage.h"
@class Stage;
#import "EDCDate.h"
#import "PerformanceConstants.h"
#import "ArtistDetailsViewController.h"
#import "ConflictViewController.h"


@interface PerformanceListViewController : UITableViewController {
    NSMutableArray *performanceList;
	UISegmentedControl *dayChooser;
	
	NSString *viewTitle;
    Artist *selectedArtist;
	int *selectedStageID;
	
    BOOL artistOnly;
    BOOL uniqueArtistsOnly;
	BOOL stageOnly;
	BOOL currentOnly;
	BOOL upcomingOnly;
	BOOL selectedOnly;
}

@property (nonatomic, retain) NSMutableArray *performanceList;

@property (nonatomic, retain) UISegmentedControl *dayChooser;

@property (nonatomic, retain) NSString *viewTitle;
@property (nonatomic, retain) Artist *selectedArtist;

@property (nonatomic, assign) int *selectedStageID;
@property (nonatomic, assign) BOOL artistOnly;
@property (nonatomic, assign) BOOL uniqueArtistsOnly;
@property (nonatomic, assign) BOOL stageOnly;
@property (nonatomic, assign) BOOL currentOnly;
@property (nonatomic, assign) BOOL upcomingOnly;
@property (nonatomic, assign) BOOL selectedOnly;

- (void)updateTable:(id)sender;
- (void)update;

- (void)conflictButtonPressedInRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)showConflictViewForPerformance:(NSNumber *)performanceID;

@end
