//
//  MFOptions.h
//  CelShader
//
//  Created by Sebastian Gamboa on 13-11-08.
//  Copyright 2008 SagMor. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MFOptions : NSObject {
	NSString *_modelName;
	float _rotationSpeed;
	BOOL _cellShaded;
	BOOL _textured;
	float _x;
	float _y;
	float _rotation;
	float _zoom;
}

@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, readonly) NSString *modelPath;
@property (nonatomic, readonly) NSString *texturePath;
@property (nonatomic, assign) float rotationSpeed;
@property (nonatomic, assign) BOOL cellShaded;
@property (nonatomic, assign) BOOL textured;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float rotation;
@property (nonatomic, assign) float zoom;

@end
