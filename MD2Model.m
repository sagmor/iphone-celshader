//
//  MD2Model.m
//  CelShader
//
//  Created by Sebastian Gamboa on 08-09-08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MD2Model.h"
#include <stdio.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


@implementation MD2Model
- (MD2Model *)initFromFile:(NSString *)filepath {
    file = filepath;
    
    header      = NULL;
    skins       = NULL;
    texcoords   = NULL;
    triangles   = NULL;
    frames      = NULL;
    glcmds      = NULL;

    return self;
}

- (bool)load{
    if (header) {
        NSLog(@"Model already loaded");
        return NO;
    }
    
    header = (MD2Header *)malloc(sizeof (MD2Header));
    
    if(!header) {
        NSLog(@"Couldn't alocate memory for header");
        return NO;
    }
        
    FILE *fp; 
    int i; 
    fp = fopen ([file cStringUsingEncoding:NSASCIIStringEncoding], "rb");
    
    if (!fp) {
        NSLog(@"Couldn't open %@", file);
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
    
    NSLog(@"Loaded model from file: %@", file);
            
    return YES;

}

- (void)draw {
    int i, j, n = 0; 
    GLfloat s, t; 
    // vec3_t v; 
    MD2Frame *pframe; 
    MD2Vertex *pvert;
    GLfloat *vertexArray;
    
    
    /* Check if n is in a valid range */
    if ((n < 0) || (n > header->num_frames - 1)) 
        return; 
    
    /* Enable model's texture */
    // glBindTexture (GL_TEXTURE_2D, tex_id);
    
    /* Draw the model */
    // glBegin(GL_TRIANGLES);
    vertexArray = (GLfloat *)malloc(9 * sizeof(GLfloat) * header->num_tris);
    /* Draw each triangle */
    for (i = 0; i < header->num_tris; ++i) 
    { 
        /* Draw each vertex */
        for (j = 0; j < 3; ++j) 
        { 
            pframe = &frames[n]; 
            pvert = &pframe->verts[triangles[i].vertex[j]]; 
            /* Compute texture coordinates */ 
            s = (GLfloat)texcoords[triangles[i].st[j]].s / header->skinwidth; 
            t = (GLfloat)texcoords[triangles[i].st[j]].t / header->skinheight; 
            /* Pass texture coordinates to OpenGL */ 
            // glTexCoord2f (s, t); 
            /* Normal vector */ 
            // glNormal3fv (anorms_table[pvert->normalIndex]); 
            /* Calculate vertex real position */ 
            vertexArray[i*9 + j*3 + 0] = (pframe->scale[0] * pvert->v[0]) + pframe->translate[0]; 
            vertexArray[i*9 + j*3 + 1] = (pframe->scale[1] * pvert->v[1]) + pframe->translate[1]; 
            vertexArray[i*9 + j*3 + 2] = (pframe->scale[2] * pvert->v[2]) + pframe->translate[2]; 
            // v[0] = (pframe->scale[0] * pvert->v[0]) + pframe->translate[0]; 
            // v[1] = (pframe->scale[1] * pvert->v[1]) + pframe->translate[1]; 
            // v[2] = (pframe->scale[2] * pvert->v[2]) + pframe->translate[2];
            // glVertexPointer(3, GL_FLOAT, 0, v);
            // glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
            // glVertex3f(v[0],v[1],v[2]);
            
        }
    }
    glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
    glVertexPointer(3, GL_FLOAT, 0, vertexArray);
    glDrawArrays(GL_TRIANGLES, 0, 9 * header->num_tris);
    glFlush();
    free(vertexArray);
    // glEnd();
}

@end
