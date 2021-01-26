/* shaders/world0/composite.vsh
 * 29 Dec 2020
 * by TheAarnold
 **/
#version 120

#define VERTEX_SHADER

#include "/include/settings.glsl"

varying vec2 texcoord;

void main()
{
	gl_Position = ftransform();
	texcoord = gl_MultiTexCoord0.xy;
}
