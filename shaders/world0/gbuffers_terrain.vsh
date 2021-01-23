/* shaders/world0/gbuffers_terrain.vsh
 * 22 Jan 2020
 * by TheAarnold
 **/
#version 120

#include "/include/settings.glsl"

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;

varying vec3 normal;
varying vec3 lightDir;
varying float NdotL;

uniform mat4 gbufferModelViewInverse, gbufferProjectionInverse;

uniform vec3 shadowLightPosition;

#ifdef SHADOWS
	varying vec3 shadowPos;

	uniform mat4 shadowModelView, shadowProjection;

	#include "/include/shadows/shadows.vsh"
#endif

void main()
{
	gl_Position = ftransform();
	texcoord = gl_MultiTexCoord0.xy;
	lmcoord  = gl_MultiTexCoord1.xy;
	glcolor = gl_Color;

	vec3 position = (gbufferModelViewInverse * gbufferProjectionInverse * gl_Position).xyz;

	normal = normalize(gl_NormalMatrix * gl_Normal);
	lightDir = normalize(shadowLightPosition);
	NdotL = dot(normal, lightDir);

	#ifdef SHADOWS
		shadowPos = computeShadowPosition(position, normal, NdotL);
	#endif
}
