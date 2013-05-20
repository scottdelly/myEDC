//
//  SplashViewController.m
//  myEDC
//
//  Created by Scott Delly on 6/7/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import "SplashViewController.h"


@implementation SplashViewController
@synthesize currentActionLabel, spinner;
@synthesize splashTimer;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	currentActionLabel.text = @"Loading...";
	[spinner startAnimating];
	spinner.hidden = NO;
	updater = [[UpdateController alloc] init];
    [updater checkForUpdates];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    
    
    //[self pushRootViewController];
	[self performSelector:@selector(pushRootViewController) withObject:nil afterDelay:2];
}

- (void)update{
	return;
}

- (void)pushRootViewController{
    RootViewController *rootVC = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
	[self.navigationController pushViewController:rootVC animated:YES];
	[rootVC release];
}

#pragma mark -
#pragma mark Checking Internet Connection
																																			  
-(BOOL)checkInternet{
  //Test for Internet Connection
  NSLog(@"——–");NSLog(@"Testing Internet Connectivity");
  Reachability *r = [Reachability reachabilityWithHostName:@"www.carnivalapps.com"];
  NetworkStatus internetStatus = [r currentReachabilityStatus];
  BOOL internet;
  if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
	  internet = NO;
  } else {
	  internet = YES;
  }
  return internet;
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
	currentActionLabel = nil;
	spinner = nil;
}


- (void)dealloc {
	currentActionLabel = nil;
	spinner = nil;
    updater = nil;
	[splashTimer release];
    [super dealloc];
}


@end
