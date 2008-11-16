//
//  MD2Model.m
//  CelShader
//
//  Created by Sebastian Gamboa on 08-09-08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MD2Model.h"
#include <stdio.h>
#include <math.h>
#include "MFOptions.h"
#include "CelShaderAppDelegate.h"

/* Table of precalculated normals */
vec3_t anorms_table[162] = {
#include "anorms.h"
};

float dot_product (vec3_t a, vec3_t b)		// Calculate The Angle Between The 2 Vectors
{
	return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];		// Return The Angle
}

float magnitude (vec3_t v)				// Calculate The Length Of The Vector
{
	return sqrtf (v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);	// Return The Length Of The Vector
}

void normalize (vec3_t v)					// Creates A Vector With A Unit Length Of 1
{
	float m = magnitude (v);				// Calculate The Length Of The Vector 
	
	if (m != 0.0f)						// Make Sure We Don't Divide By 0 
	{
		v[0] /= m;					// Normalize The 3 Components 
		v[1] /= m;
		v[2] /= m;
	}
}

void rotate_vector (MATRIX m, vec3_t v, vec3_t d)		// Rotate A Vector Using The Supplied Matrix
{
	d[0] = (m.data[0] * v[0]) + (m.data[4] * v[1]) + (m.data[8]  * v[2]);	// Rotate Around The X Axis
	d[1] = (m.data[1] * v[0]) + (m.data[5] * v[1]) + (m.data[9]  * v[2]);	// Rotate Around The Y Axis
	d[2] = (m.data[2] * v[0]) + (m.data[6] * v[1]) + (m.data[10] * v[2]);	// Rotate Around The Z Axis
}

@implementation MD2Model
- (MD2Model *)initWithModelPath:(NSString *)modelPath andTexturePath:(NSString *)texturePath cellShaded:(bool)cellShaded {
	modelFile = modelPath;
	textureFile = texturePath;
    isCellShaded = cellShaded;
	
    header      = NULL;
    skins       = NULL;
    texcoords   = NULL;
    triangles   = NULL;
    frames      = NULL;
    glcmds      = NULL;
	vertex		= NULL;
	normals		= NULL;
	
	shaderFile = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"txt"];

    return self;
}

- (bool)load{
	FILE *fp; 
    int i,j,n=0; 
	
	MD2Frame *pframe; 
    MD2Vertex *pvert;
	
    if (header) {
        NSLog(@"Model already loaded");
        return NO;
    }
    
    header = (MD2Header *)malloc(sizeof (MD2Header));
    
    if(!header) {
        NSLog(@"Couldn't alocate memory for header");
        return NO;
    }
	
    fp = fopen ([modelFile cStringUsingEncoding:NSASCIIStringEncoding], "rb");
    
    if (!fp) {
        NSLog(@"Couldn't open %@", modelFile);
        return NO;
    }
    
    /* Read header */
    fread (header, 1, sizeof (MD2Header), fp);
    
    if ((header->ident != IDP2) || (header->version != MD2_HEADER_VERSION)) {
        NSLog(@"Header validation error");
        return NO;
    }
    
    /* Memory allocations */
    skins       = (MD2Skin *)malloc(sizeof (MD2Skin) * header->num_skins);
    texcoords   = (MD2TexCoord *)malloc(sizeof (MD2TexCoord) * header->num_st);
    triangles   = (MD2Triangle *)malloc(sizeof (MD2Triangle) * header->num_tris);
    frames      = (MD2Frame *)malloc(sizeof (MD2Frame) * header->num_frames);
    glcmds      = (MD2GLCmnd *)malloc(sizeof (MD2GLCmnd) * header->num_glcmds);
    
    /* Read model data */
    fseek (fp, header->offset_skins, SEEK_SET);
    fread (skins, sizeof (MD2Skin), header->num_skins, fp);
    
    fseek (fp, header->offset_st, SEEK_SET); 
    fread (texcoords, sizeof (MD2TexCoord), header->num_st, fp); 
    
    fseek (fp, header->offset_tris, SEEK_SET); 
    fread (triangles, sizeof (MD2Triangle), header->num_tris, fp); 
    
    fseek (fp, header->offset_glcmds, SEEK_SET); 
    fread (glcmds, sizeof (MD2GLCmnd), header->num_glcmds, fp); 
    
    /* Read frames */ 
    fseek (fp, header->offset_frames, SEEK_SET); 
    for (i = 0; i < header->num_frames; ++i) 
    { 
        /* Memory allocation for vertices of this frame */ 
        frames[i].verts = (MD2Vertex *)malloc(sizeof (MD2Vertex) * header->num_vertices); 
        
        /* Read frame data */ 
        fread (frames[i].scale, sizeof (vec3_t), 1, fp); 
        fread (frames[i].translate, sizeof (vec3_t), 1, fp); 
        fread (frames[i].name, sizeof (char), 16, fp); 
        fread (frames[i].verts, sizeof (MD2Vertex), header->num_vertices, fp); 
    } 
    fclose (fp);
	
	vertex = (GLfloat *)malloc(9 * header->num_tris * sizeof(GLfloat));
	normals = (GLfloat *)malloc(9 * header->num_tris * sizeof(GLfloat));
	textures = (GLfloat *)malloc(6 * header->num_tris * sizeof(GLfloat));
	
	for (i = 0; i < header->num_tris; ++i) 
    { 
        /* Draw each vertex */
        for (j = 0; j < 3; ++j) 
        { 
            pframe = &frames[n]; 
            pvert = &pframe->verts[triangles[i].vertex[j]]; 
            /* Compute texture coordinates */ 
            // s = (GLfloat)texcoords[triangles[i].st[j]].s / header->skinwidth; 
            // t = (GLfloat)texcoords[triangles[i].st[j]].t / header->skinheight; 
            /* Pass texture coordinates to OpenGL */ 
            // glTexCoord2f (s, t); 
            /* Normal vector */ 
            // glNormal3fv (anorms_table[pvert->normalIndex]); 
            normals[i*9 + j*3 + 0] = anorms_table[pvert->normalIndex][0]; 
            normals[i*9 + j*3 + 1] = anorms_table[pvert->normalIndex][1]; 
            normals[i*9 + j*3 + 2] = anorms_table[pvert->normalIndex][2]; 
            /* Calculate vertex real position */ 
            vertex[i*9 + j*3 + 0] = (pframe->scale[0] * pvert->v[0]) + pframe->translate[0]; 
            vertex[i*9 + j*3 + 1] = (pframe->scale[1] * pvert->v[1]) + pframe->translate[1]; 
            vertex[i*9 + j*3 + 2] = (pframe->scale[2] * pvert->v[2]) + pframe->translate[2];
			
			textures[i*6 + j*2 + 0] = (GLfloat)texcoords[triangles[i].st[j]].s / header->skinwidth;
			textures[i*6 + j*2 + 1] = (GLfloat)texcoords[triangles[i].st[j]].t / header->skinheight;
        }
    }
	
	char Line[255];						// Storage For 255 Characters
	
	
	FILE *In = NULL;					// File Pointer
	
	glShadeModel (GL_SMOOTH);				// Enables Smooth Color Shading
	glDisable (GL_LINE_SMOOTH);				// Initially Disable Line Smoothing
	
	glEnable (GL_CULL_FACE);				// Enable OpenGL Face Culling
	glDisable (GL_LIGHTING);				// Disable OpenGL Lighting
	
	In = fopen ([shaderFile cStringUsingEncoding:NSASCIIStringEncoding], "r");			// Open The Shader File
	
	if (In)							// Check To See If The File Opened
	{
		for (i = 0; i < 32; i++)			// Loop Though The 32 Greyscale Values
		{
			if (feof (In))				// Check For The End Of The File
				break;
			
			fgets (Line, 255, In);			// Get The Current Line
			
			// Copy Over The Value
			shaderData[i][0] = shaderData[i][1] = shaderData[i][2] = (unsigned char)atoi(Line);
			shaderData[i][3] = 250;
		}
		
		fclose (In);					// Close The File
	}
	else
		return NO;					// It Went Horribly Horribly Wrong
	
	CGImageRef tex = [UIImage imageWithContentsOfFile:textureFile].CGImage;
	if (tex) {
		CGContextRef texContext;
		textureData = (GLubyte *) malloc(header->skinwidth * header->skinheight * 4);
		texContext = CGBitmapContextCreate(textureData, header->skinwidth, header->skinheight, 8, header->skinwidth * 4, CGImageGetColorSpace(tex), kCGImageAlphaPremultipliedLast);
		CGContextDrawImage(texContext, CGRectMake(0.0, 0.0, (CGFloat)header->skinwidth, (CGFloat)header->skinheight), tex);
		CGContextRelease(texContext);
	}
	
	glGenTextures (1, &texId);			// Get A Free Texture ID
	glActiveTexture(GL_TEXTURE0);
	glBindTexture (GL_TEXTURE_2D, texId);	// Bind This Texture. From Now On It Will Be 1D
	glTexImage2D (GL_TEXTURE_2D, 0, GL_RGBA, header->skinwidth, header->skinheight, 0, GL_RGBA , GL_UNSIGNED_BYTE, textureData);
	glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);	
	glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	
	
	
	glGenTextures (1, &shaderTexture[0]);			// Get A Free Texture ID
	glActiveTexture(GL_TEXTURE1);
	glBindTexture (GL_TEXTURE_2D, shaderTexture[0]);	// Bind This Texture. From Now On It Will Be 1D
	glTexImage2D (GL_TEXTURE_2D, 0, GL_RGBA, 32, 1, 0, GL_RGBA , GL_UNSIGNED_BYTE, shaderData);
	// For Crying Out Loud Don't Let OpenGL Use Bi/Trilinear Filtering!
	glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);	
	glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
	
    NSLog(@"Loaded model from file: %@", modelFile);
            
    return YES;

}

- (void)draw {
	MFOptions *options = [(CelShaderAppDelegate *)[[UIApplication sharedApplication] delegate] options];
	int i,j;
	float tmpShade;						// Temporary Shader Value
	
	MATRIX tmpMatrix;					// Temporary MATRIX Structure
	vec3_t tmpVector, tmpNormal;				// Temporary VECTOR Structures
	GLfloat *shadeTexture = (GLfloat *)malloc(6 * header->num_tris * sizeof(GLfloat));

	lightAngle[0] = 0.0f;					// Set The X Direction
	lightAngle[1] = 10.0f;					// Set The Y Direction
	lightAngle[2] = 1.0f;					// Set The Z Direction
	
	normalize(lightAngle);					// Normalize The Light Direction
	
	const float lightAmbient[] = { 0.2f, 0.1f, 0.1f, 1.0f };
    const float lightDiffuse[] = { 0.8f, 0.8f, 0.8f, 1.0f };
    const float matAmbient[] = { 1.0f, 1.0f, 1.0f, 1.0f };
    const float matDiffuse[] = { 1.0f, 1.0f, 1.0f, 1.0f };
	
	
	if (![options cellShaded]) {
		glEnable(GL_LIGHTING);
		glEnable(GL_LIGHT0);
		glEnable(GL_COLOR_MATERIAL);
    
		glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, matAmbient);
		glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, matDiffuse);
		glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 20.0f);
	
		glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
		glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
	}
    

    glPushMatrix();
    glRotatef(-90, 1, 0, 0);
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	
	glGetFloatv(GL_MODELVIEW_MATRIX, tmpMatrix.data);
	
	if ([options cellShaded]) {
		for (i = 0; i < header->num_tris; i++) {
			for (j = 0; j < 3; j++) {
				tmpNormal[0] = normals[i*9 + j*3 + 0]; 
				tmpNormal[1] =  normals[i*9 + j*3 + 1]; 
				tmpNormal[2] = normals[i*9 + j*3 + 2];
			
				rotate_vector(tmpMatrix, tmpNormal, tmpVector);
				normalize(tmpVector);
			
				// Calculate The Shade Value
				tmpShade = dot_product(tmpVector, lightAngle);
				if (tmpShade < 0.0f)
					tmpShade = 0.0f;	// Clamp The Value to 0 If Negative
			
				shadeTexture[i*6 + j*2 + 0] = tmpShade;
				shadeTexture[i*6 + j*2 + 1] = 0;
				
			}
		}
	}

	glEnable(GL_DEPTH_TEST);
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(3, GL_FLOAT, 0, vertex);
	glEnableClientState(GL_NORMAL_ARRAY);
	glNormalPointer(GL_FLOAT, 0, normals);
	
	if ([options textured]) {
		glActiveTexture(GL_TEXTURE0);
		glClientActiveTexture(GL_TEXTURE0);
		glEnable(GL_TEXTURE_2D);
		glBindTexture (GL_TEXTURE_2D, texId);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glTexCoordPointer(2, GL_FLOAT, 0, textures);
	}
	
	if ([options cellShaded]) {
		glActiveTexture(GL_TEXTURE1);
		glClientActiveTexture(GL_TEXTURE1);
		glEnable(GL_TEXTURE_2D);
		glBindTexture (GL_TEXTURE_2D, shaderTexture[0]);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glTexCoordPointer(2, GL_FLOAT, 0, shadeTexture);
	}
	
	if ([options cellShaded] && [options textured])
		glTexEnvx(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_ADD);
	
    glDrawArrays(GL_TRIANGLES, 0, 3 * header->num_tris);
	
	free(shadeTexture);
    glPopMatrix();
}

- (void)dealloc {
	if (header    != NULL) free(header);
	if (skins     != NULL) free(skins);
	if (texcoords != NULL) free(texcoords);
	if (triangles != NULL) free(triangles);
	if (frames    != NULL) free(frames);
	if (glcmds	  != NULL) free(glcmds);
	if (vertex    != NULL) free(vertex);
	if (normals   != NULL) free(normals);
	if (textures   != NULL) free(textures);
	//if (shaderTexture[0]   != 0) glDeleteTextures (1, &shaderTexture[0]);		// Delete The Shader Texture
	// glDeleteTextures (1, &texId);					// Delete the Texture

	[super dealloc];
}

@end
