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

	float shadowBias = 0.0001 * (1.0 - surfaceExposition);
	shadowPos.z -= shadowBias;

	return shadowPos;
}

float filter(in vec3 pos, in sampler2D depthMap)
{
	float shadowAmount;

	const vec2 texelSize = vec2(1.0 / shadowMapResolution);
	const float sampleSpacing = 1.0;
	const int sampleBound = 2;

	for (int x = -sampleBound; x <= sampleBound; x++)
	{
		for (int y = -sampleBound; y <= sampleBound; y++)
		{
			vec2 texelPos = pos.xy + vec2(float(x) * sampleSpacing, float(y) * sampleSpacing) * texelSize;

			if (texelPos.x < 1.0 && texelPos.y < 1.0 &&
				 texelPos.x > 0.0 && texelPos.y > 0.0)
				shadowAmount += pos.z > texture2D(depthMap, texelPos).x ? 1.0 : 0.0;
		}
	}

	const float sampleCount = float((sampleBound * 2 + 1) * (sampleBound * 2 + 1));
	return shadowAmount / sampleCount;
}

void computeShadow(inout vec4 color, in vec3 shadowPos)
{
	bool isNotTooFar = shadowPos.x < 1.0 && shadowPos.y < 1.0 &&
							 shadowPos.x > 0.0 && shadowPos.y > 0.0;

	bool isFaceToLight = surfaceExposition > 0.0;

	if (isFaceToLight)
	{
		if (isNotTooFar)
		{
			float shadowAmount = filter(shadowPos, shadowtex0);

			color.xyz *= (1.0 - max(shadowAmount * SHADOW_BRIGHTNESS, SHADOW_BRIGHTNESS * (1.0 - surfaceExposition)));
		}
		else
		{
			color.xyz *= (1.0 - SHADOW_BRIGHTNESS * (1.0 - surfaceExposition));
		}
	}
	else
	{
		color.xyz *= (1.0 - SHADOW_BRIGHTNESS);
	}
}
