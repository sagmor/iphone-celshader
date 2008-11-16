//
//  MainViewController.h
//  CelShader
//
//  Created by Sebastian Gamboa on 13-11-08.
//  Copyright 2008 SagMor. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModelSelectionController, OptionsViewController, CelShadingViewController;


@interface MainViewController : UIViewController {
	ModelSelectionController *modelSelectionView;
	OptionsViewController *optionsView;
	CelShadingViewController *cellShadingView;
}

- (IBAction)selectModel:(id)sender;
- (IBAction)setOptions:(id)sender;
- (IBAction)showModel:(id)sender;


@end
