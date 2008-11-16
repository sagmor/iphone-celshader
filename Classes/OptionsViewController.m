//
//  OptionsViewController.m
//  CelShader
//
//  Created by Sebastian Gamboa on 17-08-08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "OptionsViewController.h"
#import "CelShaderAppDelegate.h"
#import "MFOptions.h"

@implementation OptionsViewController


- (void)viewDidLoad {
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	self.title = @"Options";
}

- (void)viewWillAppear:(BOOL)animated {
	CelShaderAppDelegate *appDelegate = (CelShaderAppDelegate *)[[UIApplication sharedApplication] delegate];
	[activateCelShading setOn:[[appDelegate options] cellShaded]];
	[activateTexture setOn:[[appDelegate options] textured]];
	[animationSpeed setValue:[[appDelegate options] rotationSpeed]];
}

- (void)viewWillDisappear:(BOOL)animated {
	CelShaderAppDelegate *appDelegate = (CelShaderAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[appDelegate options] setCellShaded:[activateCelShading isOn]];
	[[appDelegate options] setTextured:[activateTexture isOn]];
	[[appDelegate options] setRotationSpeed:[animationSpeed value]];
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


@end
