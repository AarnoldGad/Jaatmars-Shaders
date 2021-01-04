/* shaders/composite.vsh
 * 29/12/2020
 * by TheAarnold
 **/
#version 120

#include "/include/settings.glsl"

varying vec2 texcoord;

void main()
{
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}
