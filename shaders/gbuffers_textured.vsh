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

uniform float shadowAngle;

void main()
{
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;

	surfNormal = normalize(gl_NormalMatrix * gl_Normal);

	float alpha = shadowAngle * 2 * pi;
	float delta = -sunPathRotation * 0.017453292;

	vec3 uAlpha = vec3(-sin(alpha), cos(alpha), 0);
	vec3 uDelta = vec3(0, -sin(delta), cos(delta));

	sunNormal = normalize(gbufferModelView * vec4(-cross(uAlpha, uDelta), 1.0)).xyz;
	surfaceExposition = -dot(surfNormal, sunNormal);
}
