/* include/shadows/shadows.glsl
* 5 Jan 2020
* by TheAarnold
**/

void distort(inout vec3 pos)
{
	float distortFactor = length(pos.xy) * SHADOWMAP_BIAS + 1.0 - SHADOWMAP_BIAS;
	pos.xy /= distortFactor;
	pos.z *= 0.2;
}
