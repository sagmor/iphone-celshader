//
//  MFOptions.m
//  CelShader
//
//  Created by Sebastian Gamboa on 13-11-08.
//  Copyright 2008 SagMor. All rights reserved.
//

#import "MFOptions.h"

static const NSString *MFDefaultModel = @"blade";
static const float MFDefaultRotationSpeed = 60.0;
static const BOOL MFDefaultCellShadeState = YES;
static const BOOL MFDefaultTexturedState = YES;

@implementation MFOptions

@synthesize modelName = _modelName;
@synthesize rotationSpeed = _rotationSpeed;
@synthesize cellShaded = _cellShaded;
@synthesize textured = _textured;
@synthesize x = _x;
@synthesize y = _y;
@synthesize rotation = _rotation;
@synthesize zoom = _zoom;

- (id)init {
	_modelName = [MFDefaultModel copy];
	_rotationSpeed = MFDefaultRotationSpeed;
	_cellShaded = MFDefaultCellShadeState;
	_textured = MFDefaultTexturedState;
	_x = 0.0f;
	_y = 0.0f;
	_zoom = 1.0f;
	_rotation = 0.0f;
	
	return self;
}

- (NSString *)modelPath {
	return [[NSBundle mainBundle] pathForResource:_modelName ofType:@"md2"];
}

- (NSString *)texturePath {
	return [[NSBundle mainBundle] pathForResource:_modelName ofType:@"png"];
}

@end
