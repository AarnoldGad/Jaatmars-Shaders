/* include/shadows/shadows.glsl
* 3 Jan 2020
* by TheAarnold
**/

#include "distortion.glsl"

vec3 toViewSpace(in vec3 pos)
{
	vec4 invProjDiag = vec4(gbufferProjectionInverse[0].x, gbufferProjectionInverse[1].y, gbufferProjectionInverse[2].zw);
	vec3 intPos = pos * 2.0 - 1.0;
	vec4 viewSpace = invProjDiag * intPos.xyzz + gbufferProjectionInverse[3];
	return viewSpace.xyz / viewSpace.w;
}

vec3 toWorldSpace(in vec3 pos)
{
	return mat3(gbufferModelViewInverse) * pos + gbufferModelViewInverse[3].xyz;
}

vec3 toLightSpace(in vec3 pos)
{
	vec3 lightSpace = mat3(shadowModelView) * pos + shadowModelView[3].xyz;
	vec3 projDiag = vec3(shadowProjection[0].x, shadowProjection[1].y, shadowProjection[2].z);
	return projDiag * lightSpace + shadowProjection[3].xyz;
}

vec3 getShadowPosition()
{
	vec3 screenPos = vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z);
	vec3 shadowPos = toLightSpace(toWorldSpace(toViewSpace(screenPos)));
	distort(shadowPos);
	shadowPos = shadowPos * 0.5 + 0.5;

	float shadowBias = 0.0002;
	shadowPos.z -= shadowBias;

	return shadowPos;
}

void computeShadow(inout vec4 color, in vec3 shadowPos)
{
	//float shadowAmount = shadowPos.z > texture2D(shadowtex0, shadowPos.xy).x ? 0.55 : 0.0;
	float shadowAmount = clamp(shadow2D(shadowtex0, shadowPos).x, SHADOW_BRIGHTNESS, 1.0);
	color.xyz *= shadowAmount;
}
