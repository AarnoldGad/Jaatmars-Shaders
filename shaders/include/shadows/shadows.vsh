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
	float halfTexel = 0.5 / shadowMapResolution;
	float sine = sqrt(1.0 - (exposition * exposition));
	float bias = halfTexel * sine;
	distortBias(bias, pos);
	return max(bias, halfTexel);
}

vec3 computeShadowPosition(in vec3 pos, in vec3 normal, in float exposition)
{
	pos = mat3(shadowModelView) * pos + shadowModelView[3].xyz;
	pos = diag3(shadowProjection) * pos + shadowProjection[3].xyz;

	distort(pos);
	pos = pos * 0.5 + 0.5;

	pos.z -= getDepthBias(pos, exposition);

	return pos;
}
