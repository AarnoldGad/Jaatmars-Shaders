/* shaders/gbuffers_textured.vsh
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

uniform vec3 sunPosition;
uniform mat4 gbufferModelView;

void main()
{
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;

	surfNormal = normalize(gl_NormalMatrix * gl_Normal);
	sunNormal = normalize((gbufferModelView * gl_Vertex).xyz - sunPosition);
	surfaceExposition = -dot(surfNormal, sunNormal);
}
