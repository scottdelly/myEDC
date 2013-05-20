//
//  HelpViewController.m
//  myEDC
//
//  Created by Scott Delly on 6/6/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize viewTitle;
@synthesize pageToLoad;
@synthesize webView;
@synthesize spinner;
@synthesize loadingLabel;

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
	self.navigationItem.title = self.viewTitle;
	
	self.webView.delegate = self;
	
	NSString *urlAddress = pageToLoad;
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [spinner stopAnimating];  
    spinner.hidden = YES;
	loadingLabel.hidden = YES;
    NSLog(@"webView has finished loading");
}

- (void)webViewDidStartLoad:(UIWebView *)webView {     
    [spinner startAnimating];     
    spinner.hidden = NO;
    NSLog(@"webView has started to load.");
}

- (void)update{
	NSLog(@"Web View Controller.  Nothing to update.");
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
	webView = nil;
	spinner = nil;
	loadingLabel = nil;
}


- (void)dealloc {
	[pageToLoad release];
	webView = nil;
	spinner = nil;
	loadingLabel = nil;
    [super dealloc];
}


@end
