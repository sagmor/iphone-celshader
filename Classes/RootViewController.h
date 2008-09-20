//
//  RootViewController.h
//  CelShader
//
//  Created by Sebastian Gamboa on 17-08-08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CelShadingViewController;
@class OptionsViewController;

@interface RootViewController : UIViewController {

	IBOutlet UIButton *infoButton;
	CelShadingViewController *celShadingViewController;
	OptionsViewController *optionsViewController;
	UINavigationBar *optionsNavigationBar;
}

@property (nonatomic, retain) UIButton *infoButton;
@property (nonatomic, retain) CelShadingViewController *celShadingViewController;
@property (nonatomic, retain) UINavigationBar *optionsNavigationBar;
@property (nonatomic, retain) OptionsViewController *optionsViewController;

- (IBAction)toggleView;

@end
