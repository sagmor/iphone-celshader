//
//  CelShaderAppDelegate.m
//  CelShader
//
//  Created by Sebastian Gamboa on 17-08-08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "CelShaderAppDelegate.h"
#import "RootViewController.h"
#import "MainViewController.h"
#import "MFOptions.h"

@implementation CelShaderAppDelegate


@synthesize window;
@synthesize rootViewController;
@synthesize mainViewController;
@synthesize navigationController;
@synthesize options;



- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[window addSubview:[navigationController view]];
	// [window addSubview:[rootViewController view]];
	// [navigationController pushViewController:mainViewController animated:NO];
	[window makeKeyAndVisible];
	options = [[MFOptions alloc] init];
}


- (void)dealloc {
	[rootViewController release];
	[window release];
	[options release];
	[super dealloc];
}

@end
