/* include/shadows/shadowWarping.glsl
* 5 Jan 2020
* by TheAarnold
**/

vec3 distort(in vec3 pos)
{
	float distortionFactor = length(pos.xy) * shadowMapBias + 1.0 - shadowMapBias;
	pos.xy /= distortionFactor;
	pos.z *= 0.2;
	return pos;
}
