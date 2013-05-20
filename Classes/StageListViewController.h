//
//  StageListViewController.h
//  myEDC
//
//  Created by Scott Delly on 6/2/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerformanceListViewController.h"
#import "Stage.h"
@class Stage;
#import "Performance.h"
@class Performance;
#import "EDCDate.h"
#import "ArtistController.h"
#import "StageController.h"

@interface StageListViewController : UITableViewController {
	NSMutableArray *stageList;
	NSManagedObjectContext *context;
	NSMutableArray *dayList;
	NSNumber *playDayToday;
}
@property (nonatomic, retain) NSMutableArray *stageList;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSMutableArray *dayList;
@property (nonatomic, retain) NSNumber *playDayToday;

- (void)update;


@end
