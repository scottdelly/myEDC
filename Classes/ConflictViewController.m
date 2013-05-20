//
//  ConflictViewController.m
//  myEDC
//
//  Created by Scott Delly on 6/11/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import "ConflictViewController.h"


@implementation ConflictViewController

@synthesize mainPerformance;
@synthesize performanceList;


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
		
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)update{
	NSLog(@"Updating Conflict View Controller");
	[self.tableView reloadData];	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationItem.hidesBackButton = NO;
	self.navigationItem.title = @"Conflicts";
		
    PerformanceController *performanceController = [[PerformanceController alloc] init];
	self.performanceList = [[performanceController discoverConflictsForPerformance:self.mainPerformance] retain];
	[performanceController release];

	//insert main artist into conflict list
	[self.performanceList insertObject:self.mainPerformance atIndex:0];
	
	// Unselect the selected row if any
	NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
	if (selection){
		[self.tableView deselectRowAtIndexPath:selection animated:YES];
	}
	[self update];
}
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
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
    return [self.performanceList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    	
    // Set up the cell...
	
	Performance *performance = [self.performanceList objectAtIndex:indexPath.row];
	cell.textLabel.text = performance.artist.name;
	
	UILabel *secondLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10.0, 52.0, 310.0, 15.0)] autorelease];
	secondLabel.font = [UIFont systemFontOfSize:14.0];
	secondLabel.textAlignment = UITextAlignmentLeft;
	secondLabel.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:secondLabel];
	
	if ([performance.stopTime doubleValue] < [EDCDate currentTimeIntervalSince1970]) {
		//Artist is done!
		cell.textLabel.textColor = [UIColor grayColor];
	} else if ([performance.startTime doubleValue] < [EDCDate currentTimeIntervalSince1970]) {
		//Artist is playing!
		cell.textLabel.textColor = [UIColor redColor];
	} else {
		cell.textLabel.textColor = [UIColor blackColor];
	}
	
	secondLabel.text = [NSString stringWithFormat:@"%@ - %@ @ %@",performance.startTimeString, performance.stopTimeString, performance.stage.name];
	
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Skip", @"See", nil]];
	[segmentedControl addTarget:self action:@selector(changeVisit:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 100, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = NO;	
	segmentedControl.selectedSegmentIndex = 1;
	[segmentedControl setTag:[performance.performanceID intValue]];
	cell.accessoryView = segmentedControl;
	[segmentedControl release];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	ArtistDetailsViewController *artistDetailVC = [[ArtistDetailsViewController alloc] initWithNibName:@"ArtistDetailsViewController" bundle:nil];
	artistDetailVC.artist = [[self.performanceList objectAtIndex:indexPath.row] artist];
	[self.navigationController pushViewController:artistDetailVC animated:YES];
	[artistDetailVC release];
}

- (void)changeVisit:(id)sender{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	int tmpPerformanceID = segmentedControl.tag;
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"performanceID==%i",tmpPerformanceID];
	PerformanceController *performanceController = [[PerformanceController alloc] init];
	NSMutableArray *tmpPerformanceList = [[performanceController fetchPerformancesWithSort:nil andPredicate:predicate andLimit:1] retain];

	Performance *performance;
	
	if ([tmpPerformanceList count] > 0) {
		NSLog(@"Performance found for 'Seeing' detail view controller");
		performance = [tmpPerformanceList objectAtIndex:0];
		[performanceController selectPerformance:performance withSelection:[segmentedControl selectedSegmentIndex]];
	} else {
		NSLog(@"Performance to to skip/see not found!");
	}
	[tmpPerformanceList release];
	[performanceController release];
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
	[mainPerformance release];
	[performanceList release];
    [super dealloc];
}


@end

