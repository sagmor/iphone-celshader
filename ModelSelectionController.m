//
//  ModelSelectionController.m
//  CelShader
//
//  Created by Sebastian Gamboa on 13-11-08.
//  Copyright 2008 SagMor. All rights reserved.
//

#import "ModelSelectionController.h"
#import "CelShaderAppDelegate.h"
#import "MFOptions.h"

@implementation ModelSelectionController

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		availableModels = [[NSArray alloc] initWithObjects:@"massm", @"blade", @"darth_vader", @"helicopter", @"banana", nil];
		self.title = @"Choose Model";
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [availableModels count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:CellIdentifier] autorelease];
    }
	[cell setText:[availableModels objectAtIndex:indexPath.row]];
	
    // Configure the cell
    return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	CelShaderAppDelegate *appDelegate = (CelShaderAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if ([[appDelegate options] modelName] == [availableModels objectAtIndex:indexPath.row])
		return UITableViewCellAccessoryCheckmark;
	else
		return UITableViewCellAccessoryNone;
		
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CelShaderAppDelegate *appDelegate = (CelShaderAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[appDelegate options] setModelName:[availableModels objectAtIndex:indexPath.row]];
	[tableView reloadData];
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)dealloc {
	[availableModels release];
    [super dealloc];
}


@end

