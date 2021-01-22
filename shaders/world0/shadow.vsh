/* shaders/shadow.vsh
 * 30 Dec 2020
 * by TheAarnold
 **/
#version 120

#include "/include/settings.glsl"
#include "/include/shadows/distortion.glsl"

varying vec2 texcoord;

void main()
{
	gl_Position = ftransform();
	distort(gl_Position.xyz);
	texcoord.xy = gl_MultiTexCoord0.xy;
}
