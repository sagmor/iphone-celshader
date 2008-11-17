//
//  CelShadingView.m
//  CelShader
//
//  Created by Sebastian Gamboa on 17-08-08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "CelShadingView.h"
#import "CelShaderAppDelegate.h"
#import "MFOptions.h"



#define USE_DEPTH_BUFFER 0

// A class extension to declare private methods
@interface CelShadingView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end

@implementation CelShadingView

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;

// You must implement this
+ (Class)layerClass {
	return [CAEAGLLayer class];
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
	if ((self = [super initWithCoder:coder])) {
		
		[self setMultipleTouchEnabled:YES];
		
		// Get the layer
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		MFOptions *options = [(CelShaderAppDelegate *)[[UIApplication sharedApplication] delegate] options];
		
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if (!context || ![EAGLContext setCurrentContext:context]) {
			[self release];
			return nil;
		}
        
        model = [[MD2Model alloc] initWithModelPath:[options modelPath] andTexturePath:[options texturePath] cellShaded:[options cellShaded]];
        [model load];
		
		animationInterval = 1.0 / [options rotationSpeed];
        // [self startAnimation];
	}
	return self;
}

- (void)drawView {
	MFOptions *options = [(CelShaderAppDelegate *)[[UIApplication sharedApplication] delegate] options];
	
	// Replace the implementation of this method to do your own custom drawing
	
	//const GLfloat squareVertices[] = {
	//	-0.5f, -0.5f,
	//	0.5f,  -0.5f,
	//	-0.5f,  0.5f,
	//	0.5f,   0.5f,
	//};
    
    //const GLfloat cubeVertices[] = {
    //	// FRONT
    //    -0.5f, -0.5f,  0.5f,
    //    0.5f, -0.5f,  0.5f,
    //    -0.5f,  0.5f,  0.5f,
    //    0.5f,  0.5f,  0.5f,
    //    // BACK
    //    -0.5f, -0.5f, -0.5f,
    //    -0.5f,  0.5f, -0.5f,
    //    0.5f, -0.5f, -0.5f,
    //    0.5f,  0.5f, -0.5f,
    //    // LEFT
    //    -0.5f, -0.5f,  0.5f,
    //    -0.5f,  0.5f,  0.5f,
    //    -0.5f, -0.5f, -0.5f,
    //    -0.5f,  0.5f, -0.5f,
    //    // RIGHT
    //    0.5f, -0.5f, -0.5f,
    //    0.5f,  0.5f, -0.5f,
    //    0.5f, -0.5f,  0.5f,
    //    0.5f,  0.5f,  0.5f,
    //    // TOP
    //    -0.5f,  0.5f,  0.5f,
    //    0.5f,  0.5f,  0.5f,
    //    -0.5f,  0.5f, -0.5f,
    //    0.5f,  0.5f, -0.5f,
    //    // BOTTOM
    //    -0.5f, -0.5f,  0.5f,
    //    -0.5f, -0.5f, -0.5f,
    //    0.5f, -0.5f,  0.5f,
    //    0.5f, -0.5f, -0.5f,
    //};
    
    // const float lightAmbient[] = { 0.2f, 0.1f, 0.1f, 1.0f };
    // const float lightDiffuse[] = { 0.8f, 0.8f, 0.8f, 1.0f };
    // const float matAmbient[] = { 1.0f, 1.0f, 1.0f, 1.0f };
    // const float matDiffuse[] = { 1.0f, 1.0f, 1.0f, 1.0f };
    
    
	//const GLubyte squareColors[] = {
	//	255, 255,   0, 255,
	//	0,   255, 255, 255,
	//	0,     0,   0,   0,
	//	255,   0, 255, 255,
    //
    //      255, 255,   0, 255,
	//	0,   255, 255, 255,
	//	0,     0,   0,   0,
	//	255,   0, 255, 255,
    //};
	
	[EAGLContext setCurrentContext:context];
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	glEnable(GL_DEPTH_TEST);
	// glEnable(GL_CULL_FACE);
	
	
    // glEnable(GL_LIGHTING);
    // glEnable(GL_LIGHT0);
    // glEnable(GL_COLOR_MATERIAL);
	
	//glDepthRangef (40.0f, -40.0f);
    
    // glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, matAmbient);
	// glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, matDiffuse);
    // glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 20.0f);
    
	glViewport(0, 0, backingWidth, backingHeight);
	
	glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
	glOrthof(-30.0f, 30.0f, -40.0f, 40.0f, -40.0f, 40.0f);
	glMatrixMode(GL_MODELVIEW);
	
    // glScalex(.1, .1, .1);
    
    // glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
	// glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
	
    glDepthFunc(GL_LESS);
    glDepthMask(GL_TRUE);
	glCullFace(GL_FRONT);
	glClearColor(0.9f, 0.9f, 0.9f, 0.0f);
    
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
	glLoadIdentity();
	glPushMatrix();
	glTranslatef([options x], [options y], 0.0f);
	glRotatef([options rotation], 0.0f, 1.0f, 0.0f);
	glScalef([options zoom], [options zoom], [options zoom]);
    [model draw];
    glPopMatrix();
	// glFlush();
    
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (void)layoutSubviews {
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	[self drawView];
}


- (BOOL)createFramebuffer {
	
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	if (USE_DEPTH_BUFFER) {
		glGenRenderbuffersOES(1, &depthRenderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
	}
    
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	return YES;
}


- (void)destroyFramebuffer {
	
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	if(depthRenderbuffer) {
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}


- (void)startAnimation {
	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(tick) userInfo:nil repeats:YES];
}


- (void)stopAnimation {
	self.animationTimer = nil;
}


- (void)setAnimationTimer:(NSTimer *)newTimer {
	[animationTimer invalidate];
	animationTimer = newTimer;
}


- (void)setAnimationInterval:(NSTimeInterval)interval {
	
	animationInterval = interval;
	if (animationTimer) {
		[self stopAnimation];
		[self startAnimation];
	}
}


- (void)dealloc {
	
	[self stopAnimation];
	
	if ([EAGLContext currentContext] == context) {
		[EAGLContext setCurrentContext:nil];
	}
	[model release];
	[context release];	
	[super dealloc];
}





/*
- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	// Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([touches count] == 2) {
		UITouch *touch1 = [[touches allObjects] objectAtIndex:0];
		UITouch *touch2 = [[touches allObjects] objectAtIndex:1];
		initialDistance = [self distanceBetweenTwoPoints:[touch1 locationInView:self] 
												 toPoint:[touch2 locationInView:self]];
		zoomMode = YES;
	} else if ([touches count] == 1) {
		UITouch *touch = [touches anyObject];
		startTouchPosition = [touch locationInView:self];
		if ([touch tapCount] == 2) {
			MFOptions *options = [(CelShaderAppDelegate *)[[UIApplication sharedApplication] delegate] options];
			options.x = 0.0f;
			options.y = 0.0f;
			options.rotation = 0.0f;
			options.zoom = 1.0f;
			[self drawView];
		}
		zoomMode = NO;
	} 
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	MFOptions *options = [(CelShaderAppDelegate *)[[UIApplication sharedApplication] delegate] options];
	
	if ([touches count] == 2) {
		UITouch *touch1 = [[touches allObjects] objectAtIndex:0];
		UITouch *touch2 = [[touches allObjects] objectAtIndex:1];
		float currentDistance = [self distanceBetweenTwoPoints:[touch1 locationInView:self] 
													   toPoint:[touch2 locationInView:self]];
		options.zoom = options.zoom + (initialDistance - currentDistance)/100;
		if (options.zoom < 0.01f) options.zoom = 0.01f;
		initialDistance = currentDistance;
		zoomMode = YES;
	} else if ([touches count] == 1 && !zoomMode) {
		UITouch *touch = [touches anyObject];
		CGPoint currentTouchPosition = [touch locationInView:self];
		options.x = options.x - (startTouchPosition.x - currentTouchPosition.x)/10;
		options.y = options.y + (startTouchPosition.y - currentTouchPosition.y)/10;
		startTouchPosition = currentTouchPosition;
	} else {
		return;
	}
	
	[self drawView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	zoomMode = NO;
}

- (void)tick {
	MFOptions *options = [(CelShaderAppDelegate *)[[UIApplication sharedApplication] delegate] options];
	options.rotation = options.rotation + 2.0f;
	[self drawView];
}

- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
	
	float x = toPoint.x - fromPoint.x;
	float y = toPoint.y - fromPoint.y;
	
	return sqrt(x * x + y * y);
}

@end
