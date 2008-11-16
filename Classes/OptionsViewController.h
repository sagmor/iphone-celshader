//
//  OptionsViewController.h
//  CelShader
//
//  Created by Sebastian Gamboa on 17-08-08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController {
    IBOutlet UISlider *animationSpeed;
    IBOutlet UISwitch *activateCelShading;
    IBOutlet UISwitch *activateTexture;
}

@end
