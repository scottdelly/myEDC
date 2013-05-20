//
//  ArtistDetailsViewController.m
//  myEDC
//
//  Created by Scott Delly on 6/2/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import "ArtistDetailsViewController.h"


@implementation ArtistDetailsViewController

//@synthesize artistImageView;
@synthesize artistNameLabel, playInfoLabel, bioTextView, listenButton;
@synthesize artist;
@synthesize visitChooser;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationItem.hidesBackButton = NO;

	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Skip", @"See", nil]];
	[segmentedControl addTarget:self action:@selector(changeVisit:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 140, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = NO;
	self.visitChooser = segmentedControl;
	[segmentedControl release];
	
	//defaultTintColor = [segmentedControl.tintColor retain];    // keep track of this for later
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.visitChooser];
	self.navigationItem.rightBarButtonItem = segmentBarItem;
	[segmentBarItem release];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self update];
}

- (void)update{
	/*
    if ([self.artist.stopTime doubleValue] < [EDCDate currentTimeIntervalSince1970]) {
		self.visitChooser.hidden = YES;
	}*/
	//self.visitChooser.selectedSegmentIndex = [self.artist.selected boolValue];
	self.artistNameLabel.text = self.artist.name;
		
	self.playInfoLabel.text = self.artist.status;
	self.bioTextView.text = self.artist.bio;
	/*
	if ([self.artist.imageURL length]>0) {
		self.artistImageView.image = [UIImage imageNamed:self.artist.imageURL];
	} else {
		self.artistImageView.image = [UIImage imageNamed:@"generic.jpg"];
	}*/
	if ([self.artist.listenURL length]>0) {
		NSString *buttonText = [NSString stringWithFormat:@"Listen to %@", self.artist.name];
		[self.listenButton setTitle:buttonText forState:UIControlStateNormal];
	} else {
		NSString *buttonText = [NSString stringWithFormat:@"No audio for %@", self.artist.name];
		[self.listenButton setTitle:buttonText forState:UIControlStateNormal];
		self.listenButton.enabled = NO;
	}
}

- (void)changeVisit:(id)sender{
//TODO: Finish this!!!
	PerformanceController *performanceController = [[PerformanceController alloc] init];
	//[artistController selectArtist:self.artist withSelection:[self.visitChooser selectedSegmentIndex]];
	[PerformanceController release];
}

- (IBAction)listenButtonPressed:(id)sender{
	NSString *listenURL = self.artist.listenURL;
	
	WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
	webVC.viewTitle = [NSString stringWithFormat:@"Listen to %@",self.artist.name];
	webVC.pageToLoad = listenURL;
	webVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController pushViewController:webVC animated:YES];
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
	//artistImageView = nil;
	artistNameLabel = nil;
	playInfoLabel = nil;
	bioTextView = nil;
	listenButton = nil;
}

- (void)dealloc {
	//artistImageView = nil;
	artistNameLabel = nil;
	playInfoLabel = nil;
	bioTextView = nil;
	listenButton = nil;
	[artist release];
	[visitChooser release];
    [super dealloc];
}


@end
