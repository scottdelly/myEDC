//
//  ArtistDetailsViewController.h
//  myEDC
//
//  Created by Scott Delly on 6/2/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistController.h"
#import "Artist.h"
#import "PerformanceController.h"
#import "WebViewController.h"

@interface ArtistDetailsViewController : UIViewController {
	//UIImageView *artistImageView;
	UILabel *artistNameLabel;
	UILabel *playInfoLabel;
	UITextView *bioTextView;
	UIButton *listenButton;
	
	Artist *artist;
	
	UISegmentedControl *visitChooser;
}

//@property (nonatomic, retain) IBOutlet UIImageView *artistImageView;
@property (nonatomic, retain) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *playInfoLabel;
@property (nonatomic, retain) IBOutlet UITextView *bioTextView;
@property (nonatomic, retain) IBOutlet UIButton *listenButton;

@property (nonatomic, retain) Artist *artist;

@property (nonatomic, retain) UISegmentedControl *visitChooser;


- (void)changeVisit:(id)sender;
- (IBAction)listenButtonPressed:(id)sender;

- (void)update;

@end
