/* shaders/world0/shadow.fsh
 * 29 Dec 2020
 * by TheAarnold
 **/
#version 120

#include "/include/settings.glsl"

uniform sampler2D texture;

varying vec2 texcoord;

void main()
{
	vec4 color = texture2D(texture, texcoord);
	gl_FragData[0] = color;
}
