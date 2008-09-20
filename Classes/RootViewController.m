//
//  RootViewController.m
//  CelShader
//
//  Created by Sebastian Gamboa on 17-08-08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "RootViewController.h"
#import "CelShadingViewController.h"
#import "CelShadingView.h"
#import "OptionsViewController.h"


@implementation RootViewController

@synthesize infoButton;
@synthesize optionsNavigationBar;
@synthesize celShadingViewController;
@synthesize optionsViewController;


- (void)viewDidLoad {
	
	CelShadingViewController *viewController = [[CelShadingViewController alloc] initWithNibName:@"CelShadingView" bundle:nil];
	self.celShadingViewController = viewController;
	[viewController release];
	
	[self.view insertSubview:celShadingViewController.view belowSubview:infoButton];
}


- (void)loadOptionsViewController {
	
	OptionsViewController *viewController = [[OptionsViewController alloc] initWithNibName:@"OptionsView" bundle:nil];
	self.optionsViewController = viewController;
	[viewController release];
	
	// Set up the navigation bar
	UINavigationBar *aNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
	aNavigationBar.barStyle = UIBarStyleBlackOpaque;
	self.optionsNavigationBar = aNavigationBar;
	[aNavigationBar release];
	
	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleView)];
	UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"CelShader"];
	navigationItem.rightBarButtonItem = buttonItem;
	[optionsNavigationBar pushNavigationItem:navigationItem animated:NO];
	[navigationItem release];
	[buttonItem release];
}


- (IBAction)toggleView {	
	/*
	 This method is called when the info or Done button is pressed.
	 It flips the displayed view from the main view to the flipside view and vice-versa.
	 */
	if (optionsViewController == nil) {
		[self loadOptionsViewController];
	}
	
	CelShadingView *celShadingView = (CelShadingView *)celShadingViewController.view;
	UIView *optionsView = optionsViewController.view;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:([celShadingView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
	
	if ([celShadingView superview] != nil) {
        [celShadingView stopAnimation];
		[optionsViewController viewWillAppear:YES];
		[celShadingViewController viewWillDisappear:YES];
		[celShadingView removeFromSuperview];
        [infoButton removeFromSuperview];
		[self.view addSubview:optionsView];
		[self.view insertSubview:optionsNavigationBar aboveSubview:optionsView];
		[celShadingViewController viewDidDisappear:YES];
		[optionsViewController viewDidAppear:YES];

	} else {
		[celShadingViewController viewWillAppear:YES];
		[optionsViewController viewWillDisappear:YES];
		[optionsView removeFromSuperview];
		[optionsNavigationBar removeFromSuperview];
		[self.view addSubview:celShadingView];
		[self.view insertSubview:infoButton aboveSubview:celShadingViewController.view];
		[optionsViewController viewDidDisappear:YES];
		[celShadingViewController viewDidAppear:YES];
        [celShadingView startAnimation];
	}
	[UIView commitAnimations];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
    UIView *celShadingView = celShadingViewController.view;
    
    if ([celShadingView superview] != nil && optionsViewController != nil) {
        [optionsViewController release];
        optionsViewController = nil;
    }
}


- (void)dealloc {
	[infoButton release];
	[optionsNavigationBar release];
	[celShadingViewController release];
	[optionsViewController release];
	[super dealloc];
}


@end
