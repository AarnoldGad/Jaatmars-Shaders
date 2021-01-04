/* include/shadows.glsl
* 3 Jan 2020
* by TheAarnold
**/

const float maxShadow = 0.45;

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

void distort(inout vec3 pos)
{
 float bias = 1.0 - 25.6 / shadowDistance;
 float distortFactor = length(pos.xy) * bias + 1.0 - bias;
 pos.xy /= distortFactor;
}

vec3 getShadowPosition()
{
	vec3 screenPos = vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z);
	vec3 shadowPos = toLightSpace(toWorldSpace(toViewSpace(screenPos)));
	//shadowPos = distort(shadowPos);
	shadowPos.z *= 0.2;
	shadowPos = shadowPos * 0.5 + 0.5;
	shadowPos.z -= 0.0002;

	return shadowPos;
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
			float litDepth = texture2D(shadowtex0, shadowPos.xy).x;
			float shadowFactor = shadowPos.z > litDepth ? maxShadow : 0.0;

			color.xyz *= (1.0 - max(shadowFactor, maxShadow * (1.0 - surfaceExposition)));
		}
		else
		{
			color.xyz *= (1.0 - maxShadow * (1.0 - surfaceExposition));
		}
	}
	else
	{
		color.xyz *= (1.0 - maxShadow);
	}
}
