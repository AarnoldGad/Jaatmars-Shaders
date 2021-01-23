/* include/shadows/shadows.fsh
* 3 Jan 2020
* by TheAarnold
**/

float getShadowBrightness(in vec3 pos, in float exposition)
{
	bool isFaceToLight = exposition > 0.0;
	bool isNotTooFar = pos.x > 0.0 && pos.y > 0.0 && pos.x < 1.0 && pos.y < 1.0;

	if (isFaceToLight)
	{
		if (isNotTooFar)
		{
			#ifdef SHADOW_HARDWARE_FILTERING
				float shadowAmount = 1.0 - clamp(shadow2D(shadowtex0, pos).x, 0.0, 1.0);
			#else
				float shadowAmount = pos.z > texture2D(shadowtex0, pos.xy).x ? 1.0 : 0.0;
			#endif

			if (exposition < 0.4)
				return min(SHADOW_BRIGHTNESS + (1.0 - shadowAmount) * (1.0 - SHADOW_BRIGHTNESS), SHADOW_BRIGHTNESS + (1.0 - SHADOW_BRIGHTNESS) * 2.5 * exposition);

			return SHADOW_BRIGHTNESS + (1.0 - shadowAmount) * (1.0 - SHADOW_BRIGHTNESS);
		}
		else
		{
			if (exposition < 0.4)
				return SHADOW_BRIGHTNESS + (1.0 - SHADOW_BRIGHTNESS) * 2.5 * exposition;
			else
				return 1.0;
		}
	}
	else
		return SHADOW_BRIGHTNESS;
}

vec4 computeShadow(in vec4 color, in vec3 pos, in float exposition)
{
	color.xyz *= getShadowBrightness(pos, exposition);

	return color;
}
