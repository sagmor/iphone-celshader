//
//  MainViewController.m
//  CelShader
//
//  Created by Sebastian Gamboa on 13-11-08.
//  Copyright 2008 SagMor. All rights reserved.
//

#import "MainViewController.h"
#import "ModelSelectionController.h"
#import "OptionsViewController.h"
#import "CelShadingViewController.h"


@implementation MainViewController


// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		modelSelectionView = nil;
		optionsView = nil;
		cellShadingView = nil;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	self.title = @"CelShader";
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	[modelSelectionView release];
	modelSelectionView = nil;
	[optionsView release];
	optionsView = nil;
	[cellShadingView release];
	cellShadingView = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)selectModel:(id)sender{
	if (!modelSelectionView) {
		modelSelectionView = [[ModelSelectionController alloc] initWithStyle:UITableViewStyleGrouped];
	}
	[[self navigationController] pushViewController:modelSelectionView animated:YES];
}

- (IBAction)setOptions:(id)sender{
	if (!optionsView) {
		optionsView = [[OptionsViewController alloc] initWithNibName:@"OptionsView" bundle:nil];
	}
	[[self navigationController] pushViewController:optionsView animated:YES];
}

- (IBAction)showModel:(id)sender{
	[cellShadingView release];
	cellShadingView = [[CelShadingViewController alloc] initWithNibName:@"CelShadingView" bundle:nil];
	[[self navigationController] pushViewController:cellShadingView animated:YES];
}


@end
