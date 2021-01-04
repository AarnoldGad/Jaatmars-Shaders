/* shaders/shadow.vsh
 * 30 Dec 2020
 * by TheAarnold
 **/
#version 120

#include "/include/settings.glsl"

varying vec2 texcoord;

void main()
{
	gl_Position = ftransform();

	float shadowMapBias = 1.0 - 25.6 / shadowDistance;
	float distort = length(gl_Position.xy) * shadowMapBias + (1.0 - shadowMapBias);

	//gl_Position.xy = distort;
	gl_Position.z *= 0.2;
	texcoord = gl_MultiTexCoord0.xy;
}
