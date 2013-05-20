//
//  HelpViewController.h
//  myEDC
//
//  Created by Scott Delly on 6/6/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate> {
	NSString *viewTitle;
	UIWebView *webView;
	NSString *pageToLoad;
	
	UIActivityIndicatorView *spinner;
	UILabel *loadingLabel;
}

@property (nonatomic, retain) NSString *viewTitle;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *pageToLoad;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;


- (void)update;

@end
