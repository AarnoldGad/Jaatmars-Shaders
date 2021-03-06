/* shaders/world0/gbuffers_hand.fsh
 * 23 Jan 2020
 * by TheAarnold
 **/
#version 120

#define FRAGMENT_SHADER

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

	#include "/include/shadows/shadows.glsl"
#endif

void main()
{
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color *= texture2D(lightmap, lmcoord);

	#ifdef SHADOWS
		color = computeShadow(color, shadowPos, NdotL, 0.0);
	#endif

	gl_FragData[0] = color;
}
