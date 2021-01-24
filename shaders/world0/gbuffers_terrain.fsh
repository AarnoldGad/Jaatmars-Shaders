/* shaders/world0/gbuffers_terrain.fsh
 * 22 Jan 2020
 * by TheAarnold
 **/
#version 120

#include "/include/settings.glsl"

uniform sampler2D texture;
uniform sampler2D lightmap;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;

varying vec3 surfaceNormal;
varying vec3 lightDir;
varying float NdotL;

uniform mat4 gbufferProjectionInverse, gbufferModelViewInverse;
uniform mat4 shadowModelView, shadowProjection;

uniform float viewWidth;
uniform float viewHeight;

#ifdef SHADOWS
	#ifdef SHADOW_HARDWARE_FILTERING
		uniform sampler2DShadow shadowtex0;
	#else
		uniform sampler2D shadowtex0;
	#endif

	varying vec3 shadowPos;

	#include "/include/shadows/shadows.fsh"
#endif

void main()
{
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color *= texture2D(lightmap, lmcoord);
/*
	vec3 normal = surfaceNormal;

	normal = mat3(gbufferModelViewInverse) * normal;
	normal = mat3(shadowModelView) * normal;

	color = vec4(normal.x, normal.y, normal.z, 1.0);*/

	#ifdef SHADOWS
		color = computeShadow(color, shadowPos, NdotL);
	#endif

	gl_FragData[0] = color;
}
