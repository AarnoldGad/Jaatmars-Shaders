#version 120

#include "/include/settings.glsl"

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;

varying vec3 surfNormal;
varying vec3 lightDir;

uniform float shadowAngle;
uniform mat4 gbufferModelView;

void main() {
	gl_Position = ftransform();
	texcoord = gl_MultiTexCoord0.xy;
	lmcoord  = gl_MultiTexCoord1.xy;
	glcolor = gl_Color;

	surfNormal = normalize(gl_NormalMatrix * gl_Normal);

	float alpha = shadowAngle * 2 * pi;
	float delta = -sunPathRotation * 0.017453292;

	vec3 uAlpha = vec3(-sin(alpha), cos(alpha), 0);
	vec3 uDelta = vec3(0, -sin(delta), cos(delta));

	lightDir = normalize(gbufferModelView * vec4(-cross(uAlpha, uDelta), 1.0)).xyz;
}
