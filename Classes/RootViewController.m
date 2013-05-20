//
//  RootViewController.m
//  myEDC
//
//  Created by Scott Delly on 6/2/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

@synthesize mainList;
@synthesize upNextButton, disclosureButton;
@synthesize countDownLabel;
@synthesize rootTableView;
@synthesize nextUp;
@synthesize countDown;

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
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"myEDC";
	
	self.mainList = [NSMutableArray arrayWithObjects:@"Now Playing",@"On Deck",@"Artists",@"Stages",@"My Schedule",@"Help",@"About",nil];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"myEDC";
	
	[self update];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	// Unselect the selected row if any
	NSIndexPath *selection = [self.rootTableView indexPathForSelectedRow];
	if (selection){
	[self.rootTableView deselectRowAtIndexPath:selection animated:YES];
	}
	[self.rootTableView reloadData];
}

- (void)update{
	NSLog(@"Updating RootViewController");
	if (self.countDown != nil) {
		[self.countDown invalidate];
	}
	double currentTime = [EDCDate currentTimeIntervalSince1970];
	//more than 2 hrs until edc
	if (currentTime < [EDCDate twoHoursBeforeEDCStartTimeIntervalSince1970]) {
		NSLog(@"EDC Hasnt started yet!");
		
		NSString *buttonText = [NSString stringWithFormat:@"EDC Starts In:"];
		[self.upNextButton setTitle:buttonText forState:UIControlStateNormal];
		self.countDownLabel.hidden = NO;
		self.disclosureButton.hidden = YES;
		upNextButton.enabled = NO;
		
		NSTimer *newTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
															 target: self
														   selector: @selector(edcCountDown:)
														   userInfo: nil
															repeats: YES];
		self.countDown = newTimer;	
		
		//before end of edc	
	} else if (currentTime < [EDCDate edcEndTimeIntervalSince1970]) {
		NSLog(@"EDC is in progress!");

		double nextFifteen = currentTime+900;		
		NSLog(@"Forming predicate");
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected == YES && startTime>%f", nextFifteen];
		
		NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:dateSortDescriptor, nil];
		
		PerformanceController *performanceController = [[PerformanceController alloc] init];
		NSMutableArray *performanceList = [[performanceController fetchPerformancesWithSort:sortDescriptors andPredicate:predicate andLimit:1] retain];

		[sortDescriptors release];
		[dateSortDescriptor release];
		[performanceController release];
		
		if ([performanceList count]>0) {
			self.nextUp = [performanceList objectAtIndex:0];
			
			NSString *buttonText = [NSString stringWithFormat:@"%@ on %@",[nextUp.artist name], [nextUp.stage name]];
			[self.upNextButton setTitle:buttonText forState:UIControlStateNormal];
			self.countDownLabel.hidden = NO;
			self.disclosureButton.hidden = NO;
			upNextButton.enabled = YES;
			
			NSTimer *newTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
																 target: self
															   selector: @selector(artistCountDown:)
															   userInfo: nil
																repeats: YES];
			self.countDown = newTimer;
		} else {
			NSLog(@"No artists have been set to 'See'.");
			NSString *buttonText = @"Choose some artists to 'See'.";
			[self.upNextButton setTitle:buttonText forState:UIControlStateNormal];
			self.disclosureButton.hidden = YES;
			self.countDownLabel.hidden = YES;
			upNextButton.enabled = NO;
		}
		[performanceList release];
	} else {
		NSLog(@"EDC is over.");
		NSString *buttonText = @"Visit carnivalapps.com for more!";
		[self.upNextButton setTitle:buttonText forState:UIControlStateNormal];
		[self.upNextButton removeTarget:self action:@selector(upNextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self.disclosureButton removeTarget:self action:@selector(upNextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self.upNextButton addTarget:self action:@selector(visitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self.disclosureButton addTarget:self action:@selector(visitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		upNextButton.enabled = YES;
		self.disclosureButton.hidden = NO;
		self.countDownLabel.hidden = YES;
	}	
}

- (IBAction) visitButtonPressed:(id)sender{
	WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
	webVC.viewTitle = @"Carnival Apps";
	webVC.pageToLoad = @"http://www.carnivalapps.com/";
	webVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController pushViewController:webVC animated:YES];
}

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
	upNextButton = nil;
	disclosureButton = nil;
	countDownLabel = nil;
	rootTableView = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mainList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = [self.mainList objectAtIndex:indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    PerformanceListViewController *performanceListVC;
	//ArtistListViewController *artistListVC;
	StageListViewController *stageListVC;
	WebViewController *webVC;
	
	switch ([indexPath row]) {
		case 0:
            performanceListVC = [[PerformanceListViewController alloc] initWithNibName:@"PerformanceListViewController" bundle:nil];
            performanceListVC.viewTitle = @"Now Playing";
            performanceListVC.artistOnly=NO;
            performanceListVC.uniqueArtistsOnly=NO;
            performanceListVC.currentOnly=YES;
            performanceListVC.upcomingOnly=NO;
            performanceListVC.selectedOnly=NO;
            performanceListVC.stageOnly = NO;
            [self.navigationController pushViewController:performanceListVC animated:YES];
            [performanceListVC release];
            break;
		case 1:
            performanceListVC = [[PerformanceListViewController alloc] initWithNibName:@"PerformanceListViewController" bundle:nil];
            performanceListVC.viewTitle = @"On Deck";
            performanceListVC.artistOnly=NO;
            performanceListVC.uniqueArtistsOnly=NO;
            performanceListVC.currentOnly=NO;
            performanceListVC.upcomingOnly=YES;
            performanceListVC.selectedOnly=NO;
            performanceListVC.stageOnly = NO;
            [self.navigationController pushViewController:performanceListVC animated:YES];
            [performanceListVC release];
            break;
		case 2:
            performanceListVC = [[PerformanceListViewController alloc] initWithNibName:@"PerformanceListViewController" bundle:nil];
            performanceListVC.viewTitle = @"On Deck";
            performanceListVC.artistOnly=NO;
            performanceListVC.uniqueArtistsOnly=YES;
            performanceListVC.currentOnly=NO;
            performanceListVC.upcomingOnly=NO;
            performanceListVC.selectedOnly=NO;
            performanceListVC.stageOnly = NO;
            [self.navigationController pushViewController:performanceListVC animated:YES];
            [performanceListVC release];
            break;
		case 3:
			stageListVC = [[StageListViewController alloc] initWithNibName:@"StageListViewController" bundle:nil];
			[self.navigationController pushViewController:stageListVC animated:YES];
			[stageListVC release];
			break;
		case 4:            
            performanceListVC = [[PerformanceListViewController alloc] initWithNibName:@"PerformanceListViewController" bundle:nil];
            performanceListVC.viewTitle = @"My Schedule";
            performanceListVC.currentOnly=NO;
            performanceListVC.upcomingOnly=NO;
            performanceListVC.selectedOnly=YES;
            performanceListVC.stageOnly = NO;
            [self.navigationController pushViewController:performanceListVC animated:YES];
            [performanceListVC release];
            break;
        case 5:
			webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
			webVC.viewTitle = @"myEDC Help";
			webVC.pageToLoad = @"http://www.carnivalapps.com/myedc/2011/help.php";
			[self.navigationController pushViewController:webVC animated:YES];
			[webVC release];
			break;
		case 6:
			webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
			webVC.viewTitle = @"About myEDC";
			webVC.pageToLoad = @"http://www.carnivalapps.com/myedc/2011/about.php";
			[self.navigationController pushViewController:webVC animated:YES];
			[webVC release];
			break;
		default:
			break;
	}
}

// This method is run every 0.5 seconds by the timer created in the function runTimer
- (void)edcCountDown:(NSTimer*)theTimer{
	
	double currentTime = [EDCDate currentTimeIntervalSince1970];
	double edcStartTime = [EDCDate edcStartTimeIntervalSince1970];
	
	NSDictionary *timeObjects = [EDCDate differenceBetweenTimeIntervalsSince1970WithStartTime:currentTime andEndTime:edcStartTime];
	NSString *countdownLabelText = [NSString stringWithFormat:@"%iD %iH %iM %iS",	[[timeObjects objectForKey:@"days"] intValue], 
																					[[timeObjects objectForKey:@"hours"] intValue], 
																					[[timeObjects objectForKey:@"minutes"] intValue], 
																					[[timeObjects objectForKey:@"seconds"] intValue]];
	self.countDownLabel.text = countdownLabelText;
}

- (void) artistCountDown:(NSTimer*)theTimer{
	if (self.nextUp == nil) {
		NSLog(@"artistCountDown does not have an artist!");
		NSString *buttonText = @"There has been a problem finding your next show. Please restart myEDC.";
		[self.upNextButton setTitle:buttonText forState:UIControlStateNormal];
		self.disclosureButton.hidden = YES;
		self.countDownLabel.hidden = YES;
		upNextButton.enabled = NO;
		return;
	} else {
		double currentTime = [EDCDate currentTimeIntervalSince1970];
		double artistStartTime = [self.nextUp.startTime doubleValue];
		NSDictionary *timeObjects = [EDCDate differenceBetweenTimeIntervalsSince1970WithStartTime:currentTime andEndTime:artistStartTime];
		NSString *countdownLabelText = [NSString stringWithFormat:@"%iH %iM %iS",	[[timeObjects objectForKey:@"hours"] intValue], 
																					[[timeObjects objectForKey:@"minutes"] intValue],
																					[[timeObjects objectForKey:@"seconds"] intValue]];
		self.countDownLabel.text = countdownLabelText;
	}

}

- (IBAction) upNextButtonPressed:(id)sender{
	ArtistDetailsViewController *artistDetailVC = [[ArtistDetailsViewController alloc] initWithNibName:@"ArtistDetailsViewController" bundle:nil];
	artistDetailVC.artist = nextUp.artist;
	
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
	[mainList release];
	[nextUp release];
	upNextButton = nil;
	disclosureButton = nil;
	countDownLabel = nil;
	rootTableView = nil;
	[countDown release];
    [super dealloc];
}


@end

