/* shaders/gbuffers_textured.fsh
 * 30 Dec 2020
 * by TheAarnold
 **/
#version 120

#include "/include/settings.glsl"

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 glcolor;
varying vec3 surfNormal;
varying vec3 sunNormal;
varying float surfaceExposition;

uniform sampler2D texture;
uniform sampler2D lightmap;
uniform sampler2D shadowtex0;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform float viewWidth;
uniform float viewHeight;

#include "/include/shadows.glsl"

void main()
{
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color *= texture2D(lightmap, lmcoord);

	#ifdef SHADOWS
		computeShadow(color, getShadowPosition());
	#endif

	gl_FragData[0] = color;
}
