/* include/shadows/shadows.glsl
* 3 Jan 2020
* by TheAarnold
**/

#include "distortion.glsl"

vec3 getShadowPosition()
{
	// Screen Space
	vec3 screenSpace = vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z);
	// To View Space
	vec4 invProjDiag = vec4(gbufferProjectionInverse[0].x, gbufferProjectionInverse[1].y, gbufferProjectionInverse[2].zw);
	vec3 intPos = screenSpace * 2.0 - 1.0;
	vec4 viewSpace = invProjDiag * intPos.xyzz + gbufferProjectionInverse[3];
	viewSpace.xyz /= viewSpace.w;
	// To World Space
	vec3 worldSpace = mat3(gbufferModelViewInverse) * viewSpace.xyz + gbufferModelViewInverse[3].xyz;
	// To Light Space
	vec3 lightSpace = mat3(shadowModelView) * worldSpace + shadowModelView[3].xyz;
	vec3 projDiag = vec3(shadowProjection[0].x, shadowProjection[1].y, shadowProjection[2].z);
	vec3 shadowPos = projDiag * lightSpace + shadowProjection[3].xyz;

	distort(shadowPos);
	shadowPos = shadowPos * 0.5 + 0.5;

	return shadowPos;
}

float getShadowBrightness(in vec3 shadowPos, in float exposition)
{
	bool isFaceToLight = exposition > 0.0;
	bool isNotTooFar = shadowPos.x > 0.0 && shadowPos.y > 0.0 && shadowPos.x < 1.0 && shadowPos.y < 1.0;

	if (isFaceToLight)
	{
		if (isNotTooFar)
		{
			#ifdef SHADOW_HARDWARE_FILTERING
				float shadowAmount = 1.0 - clamp(shadow2D(shadowtex0, shadowPos).x, 0.0, 1.0);
			#else
				float shadowAmount = shadowPos.z > texture2D(shadowtex0, shadowPos.xy).x ? 1.0 : 0.0;
			#endif

			if (exposition < 0.2)
				return min(SHADOW_BRIGHTNESS + (1.0 - shadowAmount) * (1.0 - SHADOW_BRIGHTNESS), SHADOW_BRIGHTNESS + (1.0 - SHADOW_BRIGHTNESS) * 5.0 * exposition);

			return SHADOW_BRIGHTNESS + (1.0 - shadowAmount) * (1.0 - SHADOW_BRIGHTNESS);
		}
		else
		{
			if (exposition < 0.2)
				return SHADOW_BRIGHTNESS + (1.0 - SHADOW_BRIGHTNESS) * 5.0 * exposition;
			else
				return 1.0;
		}
	}
	else
		return SHADOW_BRIGHTNESS;
}

vec4 computeShadow(in vec4 color, in float exposition)
{
	vec3 shadowPos = getShadowPosition();

	//float shadowBias = 0.00002;
	//shadowPos.z -= shadowBias;

	color.xyz *= getShadowBrightness(shadowPos, exposition);

	return color;
}
