//
//  RootViewController.h
//  myEDC
//
//  Created by Scott Delly on 6/2/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ArtistController.h"
//#import "Artist.h"
//@class Artist;
#import "Performance.h"
@class Performance;
#import "PerformanceController.h"
#import "EDCDate.h"
#import "PerformanceListViewController.h"
//#import "ArtistListViewController.h"
#import "StageListViewController.h"
#import "ArtistDetailsViewController.h"
#import "WebViewController.h"

@interface RootViewController : UIViewController <UITableViewDelegate> {
	NSMutableArray *mainList;
	UIButton *upNextButton;
	UIButton *disclosureButton;
	UILabel *countDownLabel;
	UITableView *rootTableView;
	NSTimer *countDown;
	Performance *nextUp;
}

@property (nonatomic, retain) NSMutableArray *mainList;
@property (nonatomic, retain) IBOutlet UIButton *upNextButton;
@property (nonatomic, retain) IBOutlet UIButton *disclosureButton;
@property (nonatomic, retain) IBOutlet UILabel *countDownLabel;
@property (nonatomic, retain) IBOutlet UITableView *rootTableView;
@property (nonatomic, retain) NSTimer *countDown;
@property (nonatomic, retain) Performance *nextUp;

- (void) edcCountDown:(NSTimer*)theTimer;
- (void) artistCountDown:(NSTimer*)theTimer;
- (IBAction) upNextButtonPressed:(id)sender;
- (IBAction) visitButtonPressed:(id)sender;

- (void)update;

@end