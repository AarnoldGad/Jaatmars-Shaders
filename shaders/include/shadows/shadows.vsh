/* include/shadows/shadows.vsh
* 23 Jan 2020
* by TheAarnold
**/

#include "distortion.glsl"

vec3 diag3(in mat4 matrix)
{
	return vec3(matrix[0].x, matrix[1].y, matrix[2].z);
}

float getDepthBias(in vec3 pos, in float exposition)
{
	float bias = 0.0003;

	float distortionFactor = length(pos.xy) * shadowMapBias + 1.0 - shadowMapBias;
	float scale = distortionFactor * shadowDistance / 128.0;
	scale = 4.0 * scale * scale;

	return bias * scale;
}

vec3 getNormalOffset(in vec3 pos, in vec3 normal, in float exposition)
{
	normal.z = -normal.z; // normal.z not in the right direction ?
	float maxBias = 0.25 / shadowMapResolution;

	float sine = sqrt(1.0 - (exposition * exposition));
	float bias = maxBias * sine;

	return normal * bias;
}

vec3 computeShadowPosition(in vec3 pos, in vec3 normal, in float exposition)
{
	pos = mat3(shadowModelView) * pos + shadowModelView[3].xyz;
	pos = diag3(shadowProjection) * pos + shadowProjection[3].xyz;

	normal = mat3(gbufferModelViewInverse) * normal;
	normal = mat3(shadowModelView) * normal;

	vec3 distortedPos = distort(pos);
	distortedPos = distortedPos * 0.5 + 0.5;

	distortedPos.xyz += getNormalOffset(pos, normal, exposition);
	distortedPos.z -= getDepthBias(pos, exposition);

	return distortedPos;
}
