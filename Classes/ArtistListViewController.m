//
//  ArtistListViewController.m
//  myEDC
//
//  Created by Scott Delly on 6/2/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import "ArtistListViewController.h"


@implementation ArtistListViewController

@synthesize artistList;
@synthesize dayChooser;
@synthesize viewTitle;
@synthesize stageOnly, currentOnly, upcomingOnly, selectedOnly;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationItem.hidesBackButton = NO;
	self.navigationItem.title = viewTitle;

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

//This is needed for segmented controller
- (void)updateTable:(id)sender{
	[self update];
}

- (void)update{
	NSLog(@"Updating Artist List View Controller");
	double currentTime = [EDCDate currentTimeIntervalSince1970];
	double nextFifteen = currentTime+900; 
	double nextHour = currentTime+3600;
	
	NSLog(@"Forming predicate and sort");
	NSString *predicateString;
	NSArray *sortDescriptors;
	NSSortDescriptor *selectedSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"selected" ascending:NO];
	NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
	NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	if (currentOnly) {
		NSLog(@"Request for currently playing artists only");
		predicateString = [NSString stringWithFormat:@"startTime<=%f && stopTime>=%f", currentTime, currentTime];
		sortDescriptors = [NSArray arrayWithObjects:selectedSortDescriptor, dateSortDescriptor, nameSortDescriptor, nil];
	} else if (upcomingOnly) {
		NSLog(@"Requests for upcoming artists only");
		predicateString = [NSString stringWithFormat:@"startTime>=%f && startTime<=%f", nextFifteen, nextHour];
		sortDescriptors = [NSArray arrayWithObjects:selectedSortDescriptor, dateSortDescriptor, nameSortDescriptor, nil];
	} else {
		//Normal operation
		switch (dayChooser.selectedSegmentIndex) {
			case 0:
				NSLog(@"dayChooser returning 0");
				predicateString = @"(playDay==0 || playDay==1)";
				break;
			case 1:
				NSLog(@"dayChooser returning 1");
				predicateString = @"playDay==0";
				break;
			case 2:
				NSLog(@"dayChooser returning 2");
				predicateString = @"playDay==1";
				break;
			default:
				NSLog(@"dayChooser not returning value");
				predicateString = @"(playDay==0 || playDay==1)";
				break;				
		}
		sortDescriptors = [NSArray arrayWithObjects: nameSortDescriptor, dateSortDescriptor, nil];
		if (self.stageOnly) {
			NSLog(@"Selecting artists for stage %i", self.selectedStage);
			predicateString = [predicateString stringByAppendingString:[NSString stringWithFormat:@" && stage.stageID == %i",self.selectedStage]];
			sortDescriptors = [NSArray arrayWithObjects:dateSortDescriptor, nameSortDescriptor, nil];
		}
		if (self.selectedOnly) {
			NSLog(@"Requests for selected artists only");
			predicateString = [predicateString stringByAppendingString:[NSString stringWithFormat:@" && selected==YES"]];
			sortDescriptors = [NSArray arrayWithObjects:dateSortDescriptor, nameSortDescriptor, nil];
		}
	}
	predicateString = [predicateString stringByAppendingString:[NSString stringWithFormat:@" && stopTime > %f",[EDCDate currentTimeIntervalSince1970]-1800]];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
	NSLog(@"Searching for artists with the following predicate: %@", predicateString);
	ArtistController *artistController = [[ArtistController alloc] init];
	self.artistList = [artistController fetchArtistsWithSort:sortDescriptors andPredicate:predicate andLimit:0];
	[artistController release];
	
	NSLog(@"Found %i artists.", [self.artistList count]);
	
	[selectedSortDescriptor release];
	[dateSortDescriptor release];
	[nameSortDescriptor release];
	
	[self.tableView reloadData];	
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
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.artistList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	Artist *artist = [self.artistList objectAtIndex:indexPath.row];
	cell.textLabel.text = artist.name;
/* TODO: Show artists next performance, or selected performance!!
	if ([artist.stopTime doubleValue] < [EDCDate currentTimeIntervalSince1970] || artist.status == @"Cancelled") {
		//Artist is done!
		cell.textLabel.textColor = [UIColor grayColor];
	 } else if ([artist.startTime doubleValue] < [EDCDate currentTimeIntervalSince1970]) {
		 //Artist is playing!
		 cell.textLabel.textColor = [UIColor redColor];
	 } else {
		 cell.textLabel.textColor = [UIColor blackColor];
	 }

	cell.detailTextLabel.text = artist.status;

	if ([artist.conflict boolValue]) {
		UISegmentedControl *conflictButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Conflict", nil]];
		[conflictButton addTarget:self action:@selector(conflictButtonPressedInRowAtIndexPath:) forControlEvents:UIControlEventValueChanged];
		conflictButton.frame = CGRectMake(0, 0, 52, 20);
		conflictButton.segmentedControlStyle = UISegmentedControlStyleBar;
		conflictButton.tintColor = [UIColor redColor];
		conflictButton.momentary = NO;
		[conflictButton setTag:[artist.artistID intValue]];
		
		cell.accessoryView = conflictButton;
		[conflictButton release];
	} else {
		cell.accessoryView = nil;
		if ([artist.selected boolValue]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		} else {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}
 */
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	ArtistDetailsViewController *artistDetailVC = [[ArtistDetailsViewController alloc] initWithNibName:@"ArtistDetailsViewController" bundle:nil];
	artistDetailVC.artist = [self.artistList objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:artistDetailVC animated:YES];
	[artistDetailVC release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[dayChooser release];
	[viewTitle release];	
	[artistList release];
    [super dealloc];
}


@end

