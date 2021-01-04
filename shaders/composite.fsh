/* shaders/composite.fsh
 * 29/12/2020
 * by TheAarnold
 **/
#version 120

#include "/include/settings.glsl"

uniform sampler2D gcolor;
uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;

uniform float near;
uniform float far;

varying vec2 texcoord;

void main()
{
	vec3 color = texture2D(gcolor, texcoord).rgb;

	float depth = (2.0 * near) / (far + near - texture2D(depthtex0, texcoord).z * (far - near));

	#ifdef DEPTH_DEBUG
		color = vec3(depth);
	#endif

	gl_FragData[0] = vec4(color, 1.0);
}
