//
//  SplashViewController.h
//  myEDC
//
//  Created by Scott Delly on 6/7/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myEDCAppDelegate.h"
#import "RootViewController.h"
#import "UpdateController.h"

@interface SplashViewController : UIViewController {
	
	UILabel *currentActionLabel;
	UIActivityIndicatorView *spinner;
	UpdateController *updater;
	NSTimer *splashTimer;
}
@property (nonatomic, retain) IBOutlet UILabel *currentActionLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, retain) NSTimer *splashTimer;

- (void)pushRootViewController;
- (void)update;

@end
