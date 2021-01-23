#version 120

#include "/include/settings.glsl"

uniform sampler2D lightmap;
uniform sampler2D texture;
uniform vec4 entityColor;

#ifdef SHADOW_HARDWARE_FILTERING
	uniform sampler2DShadow shadowtex0;
#else
	uniform sampler2D shadowtex0;
#endif

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;

varying vec3 surfNormal;
varying vec3 lightDir;

uniform mat4 gbufferProjectionInverse, gbufferModelViewInverse;
uniform mat4 shadowModelView, shadowProjection;

uniform float viewWidth;
uniform float viewHeight;

#ifdef SHADOWS
	#include "/include/shadows/shadows.glsl"
#endif

void main()
{
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color.rgb = mix(color.rgb, entityColor.rgb, entityColor.a);
	color *= texture2D(lightmap, lmcoord);

	#ifdef SHADOWS
		color = computeShadow(color, -dot(surfNormal, lightDir));
	#endif

	gl_FragData[0] = color;
}
