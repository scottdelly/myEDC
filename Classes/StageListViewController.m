//
//  StageListViewController.m
//  myEDC
//
//  Created by Scott Delly on 6/2/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import "StageListViewController.h"


@implementation StageListViewController

@synthesize stageList;
@synthesize context;
@synthesize dayList, playDayToday;

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
	self.navigationItem.title = @"Stages";
		
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self update];
}

- (void)update{
	NSLog(@"Fetching Stages");
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"stageID" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
	[sortDescriptor release];
	
	StageController *stageController = [[StageController alloc] init];
	self.stageList = [stageController fetchStagesWithSort:sortDescriptors andPredicate:nil andLimit:0];
	[stageController release];
	
	[self.tableView reloadData];
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
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

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
    return [self.stageList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	Stage *stage = [self.stageList objectAtIndex:indexPath.row];
	
	cell.textLabel.text = stage.name;
		
	NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:dateSortDescriptor, nil];
	[dateSortDescriptor release];
	
	double currentTime = [EDCDate currentTimeIntervalSince1970];
	double nextTwoHours = currentTime+7200;
	double nextFifteen = currentTime+900;
	
	//Find all performances on this stage that are starting before the next 2 hours and have not stopped
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stage.stageID == %i && startTime < %f && stopTime > %f", indexPath.row, nextTwoHours, currentTime];

	PerformanceController *performanceController = [[PerformanceController alloc] init];
	NSMutableArray *performanceList = [[performanceController fetchPerformancesWithSort:sortDescriptors andPredicate:predicate andLimit:2] retain];
	[performanceController release];
	
	Performance *shownPerformance;
	NSString *cellSubtext;

	if ([performanceList count] == 0) {
		NSLog(@"No Performances found for Stage %@", [[self.stageList objectAtIndex:indexPath.row] name]);
		cellSubtext = @"No Performances Playing";
	} else {
		shownPerformance = [performanceList objectAtIndex:0];
		if ([shownPerformance.stopTime intValue] < nextFifteen && [performanceList count] > 1) {
			//current performance is done within 15 minutes and there is another up next so show 'up next'
			shownPerformance = [performanceList objectAtIndex:1];
			
			NSDate *tmpDate = [NSDate dateWithTimeIntervalSince1970:[shownPerformance.startTime doubleValue]];
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"h:mm a"];
			NSString *formattedDate = [dateFormatter stringFromDate:tmpDate];
			[dateFormatter release];
			
			cellSubtext = [NSString stringWithFormat:@"Up Next: %@ @ %@",shownPerformance.artist.name, formattedDate];
		} else {
			//current performance is not done within 15 minutes or there is not another performance after the current one
			if ([shownPerformance.startTime intValue] <= currentTime) {
				//Current performance is now playing
				cellSubtext = [NSString stringWithFormat:@"Now Playing: %@",shownPerformance.artist.name];
			} else {
				//Current Performance is coming up
				NSDate *tmpDate = [NSDate dateWithTimeIntervalSince1970:[shownPerformance.startTime doubleValue]];
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"h:mm a"];
				NSString *formattedDate = [dateFormatter stringFromDate:tmpDate];
				[dateFormatter release];
				
				cellSubtext = [NSString stringWithFormat:@"Up Next: %@ @ %@",shownPerformance.artist.name, formattedDate];
			}
		}
		if ([shownPerformance.selected boolValue]) {
			//cell.textLabel.textColor = [UIColor redColor];
			cell.detailTextLabel.textColor = [UIColor redColor];
		} else {
			//cell.textLabel.textColor = [UIColor blackColor];
			cell.detailTextLabel.textColor = [UIColor blackColor];
		}
	}
	
	[performanceList release];	
	cell.detailTextLabel.text = cellSubtext;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    PerformanceListViewController *performanceListVC = [[PerformanceListViewController alloc] initWithNibName:@"PerformanceListViewController" bundle:nil];
	performanceListVC.stageOnly = YES;
	performanceListVC.selectedStageID = indexPath.row;
	performanceListVC.viewTitle = [[self.stageList objectAtIndex:indexPath.row] name];
	[self.navigationController pushViewController:performanceListVC animated:YES];
	[performanceListVC release];
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
	[stageList release];
	[context release];
	[dayList release];
	[playDayToday release];
	[super dealloc];
}

@end

