/* include/shadows/shadowWarping.glsl
* 5 Jan 2020
* by TheAarnold
**/

vec3 distort(inout vec3 pos)
{
	float distortionFactor = length(pos.xy) * SHADOWMAP_BIAS + 1.0 - SHADOWMAP_BIAS;
	pos.xy /= distortionFactor;
	pos.z *= 0.2;
	return pos;
}

float distortBias(inout float bias, in vec3 pos)
{
	float distortionFactor = length(pos.xy) * SHADOWMAP_BIAS + 1.0 - SHADOWMAP_BIAS;
	bias *= 10.0 * distortionFactor;
	return bias;
}
