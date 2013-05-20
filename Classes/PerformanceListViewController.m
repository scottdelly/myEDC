//
//  PerformanceListViewController.m
//  myEDC
//
//  Created by Scott Delly on 6/16/11.
//  Copyright 2011 Scott Delly. All rights reserved.
//

#import "PerformanceListViewController.h"


@implementation PerformanceListViewController

@synthesize performanceList;
@synthesize dayChooser;
@synthesize selectedArtist;
@synthesize selectedStageID;
@synthesize viewTitle;
@synthesize artistOnly, uniqueArtistsOnly, stageOnly, currentOnly, upcomingOnly, selectedOnly;


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationItem.hidesBackButton = NO;
	self.navigationItem.title = viewTitle;
    
    //TODO: make daychooser look at day objects
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"All", @"Day 1", @"Day 2", nil]];
	[segmentedControl addTarget:self action:@selector(updateTable:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 210, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.tintColor = [UIColor darkGrayColor];
	segmentedControl.momentary = NO;
	self.dayChooser = segmentedControl;
	[segmentedControl release];
    
	//defaultTintColor = [segmentedControl.tintColor retain];    // keep track of this for later
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:dayChooser];
	UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc]
												initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
												target:nil action:nil];
	
	self.toolbarItems = [NSArray arrayWithObjects:flexibleSpaceButtonItem,segmentBarItem,flexibleSpaceButtonItem,nil];
    
	[segmentBarItem release];
	[flexibleSpaceButtonItem release];
	
	if ([EDCDate currentTimeIntervalSince1970] < [EDCDate edcStartTimeIntervalSince1970]) {
		self.dayChooser.selectedSegmentIndex = 0;
	} else {
		int dayNumber = [EDCDate dayNumberFromIntervalSince1970:[EDCDate currentTimeIntervalSince1970]];
		self.dayChooser.selectedSegmentIndex = dayNumber+1;
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];	
	
	// Unselect the selected row if any
	NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
	if (selection){
		[self.tableView deselectRowAtIndexPath:selection animated:YES];
	}
	[self update];
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!currentOnly && !upcomingOnly) {
        self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
//This is needed for segmented controller
- (void)updateTable:(id)sender{
	[self update];
}

- (void)update{
	NSLog(@"Updating Performance List View Controller");
	double currentTime = [EDCDate currentTimeIntervalSince1970];
	double nextFifteen = currentTime+900; 
	double nextHour = currentTime+3600;
	
	NSLog(@"Forming predicate and sort");
	NSString *predicateString;
	NSArray *sortDescriptors;
	NSSortDescriptor *selectedSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"selected" ascending:NO];
	NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
	NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"artist.name" ascending:YES];
	if (artistOnly){
        NSLog(@"Request for specific artist's performances");
        predicateString = [NSString stringWithFormat:@"artist.artistID == %d", selectedArtist.artistID];
        sortDescriptors = [NSArray arrayWithObjects:dateSortDescriptor, nil];
    } else if (currentOnly) {
		NSLog(@"Request for currently playing performances only");
		predicateString = [NSString stringWithFormat:@"startTime<=%f && stopTime>=%f", currentTime, currentTime];
		sortDescriptors = [NSArray arrayWithObjects:selectedSortDescriptor, dateSortDescriptor, nameSortDescriptor, nil];
	} else if (upcomingOnly) {
		NSLog(@"Requests for upcoming performances only");
		predicateString = [NSString stringWithFormat:@"startTime>=%f && startTime<=%f", nextFifteen, nextHour];
		sortDescriptors = [NSArray arrayWithObjects:selectedSortDescriptor, dateSortDescriptor, nameSortDescriptor, nil];
	} else {
        if (dayChooser.selectedSegmentIndex > 0){
            NSLog(@"Request for all performances on day %d", dayChooser.selectedSegmentIndex-1);
            predicateString = [NSString stringWithFormat:@"day.dayID == %d",dayChooser.selectedSegmentIndex-1];
        } else {
            NSLog(@"Request for all performances");
            predicateString = nil;
        }
		sortDescriptors = [NSArray arrayWithObjects: nameSortDescriptor, dateSortDescriptor, nil];
		if (self.stageOnly) {
			NSLog(@"Selecting performances for stage %@", self.selectedStageID);
			predicateString = [predicateString stringByAppendingString:[NSString stringWithFormat:@" && stage.stageID == %@",self.selectedStageID]];
			sortDescriptors = [NSArray arrayWithObjects:dateSortDescriptor, nameSortDescriptor, nil];
		}
		if (self.selectedOnly) {
			NSLog(@"Requests for selected performances only");
			predicateString = [predicateString stringByAppendingString:[NSString stringWithFormat:@" && selected==YES"]];
			sortDescriptors = [NSArray arrayWithObjects:dateSortDescriptor, nameSortDescriptor, nil];
		}
	}
    //This line causes finished performances to not appear
	//predicateString = [predicateString stringByAppendingString:[NSString stringWithFormat:@" && stopTime > %f",[EDCDate currentTimeIntervalSince1970]-1800]];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
	NSLog(@"Searching for performances with the following predicate: %@", predicateString);
	PerformanceController *performanceController = [[PerformanceController alloc] init];
	self.performanceList = [performanceController fetchPerformancesWithSort:sortDescriptors andPredicate:predicate andLimit:0];
	[performanceController release];
	
    if (uniqueArtistsOnly){
        NSLog(@"Request for unique artists only");
        self.performanceList = [self.performanceList valueForKeyPath:@"@distinctUnionOfObjects.artist.artistID"];
    }
    
	NSLog(@"Found %i performances.", [self.performanceList count]);
	
	[selectedSortDescriptor release];
	[dateSortDescriptor release];
	[nameSortDescriptor release];
	
	[self.tableView reloadData];	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.performanceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{    
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    // Set up the cell...
    Performance *performance = [self.performanceList objectAtIndex:indexPath.row];
    cell.textLabel.text = performance.artist.name;
    //TODO: Show artist's next performance, or selected performance!!
     if ([performance.stopTime doubleValue] < [EDCDate currentTimeIntervalSince1970] || performance.status == @"Cancelled") {
         //Performance is done!
         cell.textLabel.textColor = [UIColor grayColor];
     } else if ([performance.startTime doubleValue] < [EDCDate currentTimeIntervalSince1970]) {
         //Performance is playing!
         cell.textLabel.textColor = [UIColor redColor];
     } else {
         cell.textLabel.textColor = [UIColor blackColor];
     }

    cell.detailTextLabel.text = performance.status;
     
     if ([performance.conflict boolValue]) {
         UISegmentedControl *conflictButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Conflict", nil]];
         [conflictButton addTarget:self action:@selector(conflictButtonPressedInRowAtIndexPath:) forControlEvents:UIControlEventValueChanged];
         conflictButton.frame = CGRectMake(0, 0, 52, 20);
         conflictButton.segmentedControlStyle = UISegmentedControlStyleBar;
         conflictButton.tintColor = [UIColor redColor];
         conflictButton.momentary = NO;
         [conflictButton setTag:[performance.performanceID intValue]];
         
         cell.accessoryView = conflictButton;
         [conflictButton release];
     } else {
         cell.accessoryView = nil;
         if ([performance.selected boolValue]) {
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
         } else {
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         }
     }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	ArtistDetailsViewController *artistDetailVC = [[ArtistDetailsViewController alloc] initWithNibName:@"ArtistDetailsViewController" bundle:nil];
    Performance *selectedPerformance =  [self.performanceList objectAtIndex:indexPath.row];
	artistDetailVC.artist = selectedPerformance.artist;
	[self.navigationController pushViewController:artistDetailVC animated:YES];
	[artistDetailVC release];
}

- (void)conflictButtonPressedInRowAtIndexPath:(id)sender {
	UIButton *conflictButton = (UIButton *)sender;
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[spinner startAnimating];
	UITableViewCell *cell = (UITableViewCell *)[sender superview];
	cell.accessoryView = spinner;
	[spinner release];
	
	NSNumber *tmpPerformanceID = [NSNumber numberWithInt:conflictButton.tag];
	
	[self performSelector:@selector(showConflictViewForPerformanceWithID:) withObject:tmpPerformanceID afterDelay:0];
	NSLog(@"Conflict button pressed for PerformanceID %i", [tmpPerformanceID intValue]);
}

- (void)showConflictViewForPerformanceWithID:(NSNumber *)performanceID{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"performanceID == %s", performanceID];
    
    PerformanceController *performanceController = [[PerformanceController alloc] init];
    NSMutableArray *performanceList = [[performanceController fetchPerformancesWithSort:nil andPredicate:predicate andLimit:1] retain];
    Performance *performance = [performanceList objectAtIndex:0];
    
	ConflictViewController *conflictVC = [[ConflictViewController alloc] initWithNibName:@"ConflictViewController" bundle:nil];
	conflictVC.mainPerformance = performance;
	[self.navigationController pushViewController:conflictVC animated:YES];
	[conflictVC release];
}

- (void)dealloc{
	[dayChooser release];
	[viewTitle release];	
	[performanceList release];
    [super dealloc];
}

@end