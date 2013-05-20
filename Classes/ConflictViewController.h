//
//  ConflictViewController.h
//  myEDC
//
//  Created by Scott Delly on 6/11/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistController.h"
#import "Artist.h"
#import "EDCDate.h"
#import "ArtistDetailsViewController.h"

@interface ConflictViewController : UITableViewController {
	Performance *mainPerformance;
	NSMutableArray *performanceList;
}
@property (nonatomic, retain) Performance *mainPerformance;
@property (nonatomic, retain) NSMutableArray *performanceList;

- (void)update;
- (void)changeVisit:(id)sender;

@end
