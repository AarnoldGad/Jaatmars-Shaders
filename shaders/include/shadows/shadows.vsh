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
	float maxBias = 0.00005;
	float bias = maxBias * exposition;
	distortBias(bias, pos);
	return max(bias, maxBias);
}

vec3 getNormalOffset(in vec3 pos, in vec3 normal, in float exposition)
{
	normal.z = -normal.z;
	float maxBias = 0.52 / shadowMapResolution;

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

	distort(pos);
	pos = pos * 0.5 + 0.5;

	//pos.z -= getDepthBias(pos, exposition);
	pos.z -= 0.00005;
	pos.xyz += getNormalOffset(pos, normal, exposition);

	return pos;
}
