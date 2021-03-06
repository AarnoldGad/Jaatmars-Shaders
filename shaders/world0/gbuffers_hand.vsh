/* shaders/world0/gbuffers_hand.vsh
 * 23 Jan 2020
 * by TheAarnold
 **/
#version 120

#define VERTEX_SHADER

#include "/include/settings.glsl"

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;

varying vec3 surfaceNormal;
varying vec3 lightDir;
varying float NdotL;

uniform mat4 gbufferModelViewInverse, gbufferProjectionInverse;
uniform mat4 shadowModelView, shadowProjection;

uniform vec3 shadowLightPosition;

attribute vec3 mc_Entity;

#ifdef SHADOWS
	varying vec3 shadowPos;

	#include "/include/shadows/shadows.glsl"
#endif

void main()
{
	gl_Position = ftransform();
	texcoord = gl_MultiTexCoord0.xy;
	lmcoord  = gl_MultiTexCoord1.xy;
	glcolor = gl_Color;

	vec3 position = (gbufferModelViewInverse * gbufferProjectionInverse * gl_Position).xyz;

	surfaceNormal = normalize(gl_NormalMatrix * gl_Normal);
	lightDir = normalize(shadowLightPosition);
	NdotL = dot(surfaceNormal, lightDir);

	#ifdef SHADOWS
		shadowPos = computeShadowPosition(position, surfaceNormal, NdotL, 0.0);
	#endif
}
