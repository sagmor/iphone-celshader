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
		// Get the layer
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if (!context || ![EAGLContext setCurrentContext:context]) {
			[self release];
			return nil;
		}
        
        // model = [[MD2Model alloc] initFromFile: [[NSBundle mainBundle] pathForResource:@"blade" ofType:@"md2"]];
        // [model load];
		
		animationInterval = 10000.0; //1.0 / 60.0;
        [self startAnimation];
	}
	return self;
}

- (void)drawView {
	
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
    
    // const float lightAmbient[] = { 0.2f, 0.0f, 0.0f, 1.0f };
    // const float lightDiffuse[] = { 0.5f, 0.0f, 0.0f, 1.0f };
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
    // glEnable(GL_DEPTH_TEST);
    // glEnable(GL_CULL_FACE);
    // glEnable(GL_LIGHTING);
    // glEnable(GL_LIGHT0);
    // glEnable(GL_COLOR_MATERIAL);
    
    // glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, matAmbient);
	// glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, matDiffuse);
    
    // glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 20.0f);
    
	glViewport(0, 0, backingWidth, backingHeight);
	
	glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
	glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, -1.0f, 1.0f);
	glMatrixMode(GL_MODELVIEW);
	// glRotatef(3.0f, 0.0f, 1.0f, 0.4f);
    // glScalex(.1, .1, .1);
    
    // glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
	// glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
	
    // glDepthFunc(GL_LEQUAL);
	glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    // glClearDepthf(-1.0f);
    
	glClear(GL_COLOR_BUFFER_BIT); // | GL_DEPTH_BUFFER_BIT);
	
	// glVertexPointer(3, GL_FLOAT, 0, cubeVertices);
	// glEnableClientState(GL_VERTEX_ARRAY);
	
    // glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
	// glEnableClientState(GL_COLOR_ARRAY);
	
    // FRONT AND BACK
    // glColor4f(1.0f, 0.0f, 0.0f, 1.0f);
    // glNormal3f(0.0f, 0.0f, 1.0f);
    // glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    // glNormal3f(0.0f, 0.0f, -1.0f);
    // glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
   
    // LEFT AND RIGHT
    // glColor4f(0.0f, 1.0f, 0.0f, 1.0f);
    // glNormal3f(-1.0f, 0.0f, 0.0f);
    // glDrawArrays(GL_TRIANGLE_STRIP, 8, 4);
    // glNormal3f(1.0f, 0.0f, 0.0f);
    // glDrawArrays(GL_TRIANGLE_STRIP, 12, 4);
    
    // TOP AND BOTTOM
    // glColor4f(0.0f, 0.0f, 1.0f, 1.0f);
    // glNormal3f(0.0f, 1.0f, 0.0f);
    // glDrawArrays(GL_TRIANGLE_STRIP, 16, 4);
    // glNormal3f(0.0f, -1.0f, 0.0f);
    // glDrawArrays(GL_TRIANGLE_STRIP, 20, 4);
    
    GLfloat array[] = { 0.0f, 0.0f, 1.0f,
                        0.5f, 0.0f, 1.0f,
                        0.0f, 0.5f, 1.0f,
                        0.5f, 0.5f, 1.0f, };
    
    glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
    glNormal3f(0.0f, 1.0f, 0.0f);
    glVertexPointer(3, GL_FLOAT, 0, array);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    // [model draw];
    
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
	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
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
	
	[context release];	
	[super dealloc];
}






- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	// Drawing code
}


@end
