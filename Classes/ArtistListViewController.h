//
//  ArtistListViewController.h
//  myEDC
//
//  Created by Scott Delly on 6/2/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistController.h"
#import "Artist.h"
#import "EDCDate.h"
#import "ArtistConstants.h"
#import "ArtistDetailsViewController.h"
#import "ConflictViewController.h"

@interface ArtistListViewController : UITableViewController {
	NSMutableArray *artistList;
	UISegmentedControl *dayChooser;
	
	NSString *viewTitle;
	
	BOOL stageOnly;
	BOOL currentOnly;
	BOOL upcomingOnly;
	BOOL selectedOnly;
}
@property (nonatomic, retain) NSMutableArray *artistList;

@property (nonatomic, retain) UISegmentedControl *dayChooser;

@property (nonatomic, retain) NSString *viewTitle;
@property (nonatomic, assign) int selectedStage;

@property (nonatomic, assign) BOOL stageOnly;
@property (nonatomic, assign) BOOL currentOnly;
@property (nonatomic, assign) BOOL upcomingOnly;
@property (nonatomic, assign) BOOL selectedOnly;

- (void)updateTable:(id)sender;
- (void)update;

- (void)conflictButtonPressedInRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)showConflictViewForPerformance:(NSNumber *)artistID;

@end
