/* shaders/gbuffers_skytextured.fsh
 * 3 Jan 2020
 * by TheAarnold
 **/
#version 120

uniform sampler2D texture;

varying vec2 texcoord;
varying vec4 glcolor;

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;

/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}
