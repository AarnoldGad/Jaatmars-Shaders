/* shaders/world0/gbuffers_textured.vsh
 * 30 Dec 2020
 * by TheAarnold
 **/
#version 120

#define VERTEX_SHADER

#include "/include/settings.glsl"

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 glcolor;

void main()
{
	gl_Position = ftransform();
	texcoord = gl_MultiTexCoord0.xy;
	lmcoord  = gl_MultiTexCoord1.xy;
	glcolor = gl_Color;
}
