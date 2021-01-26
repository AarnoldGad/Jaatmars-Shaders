/* shaders/world0/shadow.vsh
 * 30 Dec 2020
 * by TheAarnold
 **/
#version 120

#define VERTEX_SHADER

#include "/include/settings.glsl"
#include "/include/shadows/distortion.glsl"

varying vec2 texcoord;

void main()
{
	gl_Position = ftransform();

	gl_Position.xyz = distort(gl_Position.xyz);

	texcoord.xy = gl_MultiTexCoord0.xy;
}
