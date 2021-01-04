/* shaders/gbuffers_textured.fsh
 * 30/12/2020
 * by TheAarnold
 **/
#version 120

#include "/include/settings.glsl"

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 glcolor;
varying vec3 surfNormal;
varying vec3 sunNormal;
varying float NdotL;

uniform sampler2D texture;
uniform sampler2D lightmap;
uniform sampler2D shadowtex0;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform float viewWidth;
uniform float viewHeight;

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

vec3 distort(in vec3 pos, in float bias)
{
	float distort = length(pos.xy) * bias + 1.0 - bias;
	pos.xy /= distort;
	return pos;
}

void computeShadow(inout vec4 color)
{
	if (NdotL > 0.0)
	{
		float shadowMapBias = 1.0 - 25.6 / shadowDistance;

		vec3 screenPos = vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z);
		vec3 shadowPos = toLightSpace(toWorldSpace(toViewSpace(screenPos)));
		//shadowPos = distort(shadowPos, shadowMapBias);
		shadowPos = shadowPos * 0.5 + 0.5;
		shadowPos.z -= 0.0002;

		if (shadowPos.x < 1.0 && shadowPos.y < 1.0 &&
			 shadowPos.x > 0.0 && shadowPos.y > 0.0)
		{
			float litDepth = texture2D(shadowtex0, shadowPos.xy).x;
			float shadowFactor = shadowPos.z > litDepth ? 0.5 : 0.0;

			color.xyz *= (1.0 - shadowFactor);
		}
	}
	else
	{
		color.xyz *= 0.5;
	}

}

void main()
{
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color *= texture2D(lightmap, lmcoord);

	#ifdef SHADOWS
		computeShadow(color);
	#endif

	gl_FragData[0] = color;
}
