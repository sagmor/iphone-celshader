//
//  MD2Model.h
//  CelShader
//
//  Created by Sebastian Gamboa on 08-09-08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IDP2 844121161
#define MD2_HEADER_VERSION 8

/* MD2 header */
typedef struct md2_header_t
{
    long ident;                  /* magic number: "IDP2" */
    long version;                /* version: must be 8 */
    
    long skinwidth;              /* texture width */
    long skinheight;             /* texture height */
    
    long framesize;              /* size in bytes of a frame */
    
    long num_skins;              /* number of skins */
    long num_vertices;           /* number of vertices per frame */
    long num_st;                 /* number of texture coordinates */
    long num_tris;               /* number of triangles */
    long num_glcmds;             /* number of opengl commands */
    long num_frames;             /* number of frames */
    
    long offset_skins;           /* offset skin data */
    long offset_st;              /* offset texture coordinate data */
    long offset_tris;            /* offset triangle data */
    long offset_frames;          /* offset frame data */
    long offset_glcmds;          /* offset OpenGL command data */
    long offset_end;             /* offset end of file */
} MD2Header;

/* Vector */
typedef float vec3_t[3];

/* Texture name */
typedef struct md2_skin_t
{
    char name[64];              /* texture file name */
} MD2Skin;

/* Texture coords */
typedef struct md2_texCoord_t
{
    short s;
    short t;
} MD2TexCoord;

/* Triangle info */
typedef struct md2_triangle_t
{
    unsigned short vertex[3];   /* vertex indices of the triangle */
    unsigned short st[3];       /* tex. coord. indices */
} MD2Triangle;

/* Compressed vertex */
typedef struct md2_vertex_t
{
    unsigned char v[3];         /* position */
    unsigned char normalIndex;  /* normal vector index */
} MD2Vertex;

/* Model frame */
typedef struct md2_frame_t
{
    vec3_t scale;               /* scale factor */
    vec3_t translate;           /* translation vector */
    char name[16];              /* frame name */
    MD2Vertex *verts; /* list of frame's vertices */
} MD2Frame;

typedef long MD2GLCmnd;

@interface MD2Model : NSObject {
    NSString *file;
    
    MD2Header *header;
    MD2Skin *skins;
    MD2TexCoord *texcoords;
    MD2Triangle *triangles;
    MD2Frame *frames;
    MD2GLCmnd *glcmds;
}

- (MD2Model *)initFromFile:(NSString *)filepath;
- (bool)load;
- (void)draw;
@end
