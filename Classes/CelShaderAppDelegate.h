//
//  CelShaderAppDelegate.h
//  CelShader
//
//  Created by Sebastian Gamboa on 17-08-08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class MainViewController;
@class MFOptions;

@interface CelShaderAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet RootViewController *rootViewController;
	IBOutlet MainViewController *mainViewController;
	IBOutlet UINavigationController *navigationController;
	MFOptions *options;
	
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, readonly) MFOptions *options;

@end

