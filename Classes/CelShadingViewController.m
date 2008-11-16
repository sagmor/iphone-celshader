//
//  CelShadingViewController.m
//  CelShader
//
//  Created by Sebastian Gamboa on 17-08-08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "CelShadingViewController.h"
#import "CelShadingView.h"
#import "CelShaderAppDelegate.h"
#import "MFOptions.h"

@implementation CelShadingViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
	}
	return self;
}


 - (void)viewDidLoad {
	 MFOptions *options = [(CelShaderAppDelegate *)[[UIApplication sharedApplication] delegate] options];
	 self.title = [options modelName];
 }
 


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[(CelShadingView *)self.view startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
	[(CelShadingView *)self.view stopAnimation];
}


@end
