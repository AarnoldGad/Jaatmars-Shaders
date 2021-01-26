/* include/shadows/shadows.glsl
* 3 Jan 2020
* by TheAarnold
**/

#include "/include/shadows/distortion.glsl"

#ifdef FRAGMENT_SHADER
   float getShadowBrightness(in vec3 pos, in float exposition, in bool isFoliage)
   {
   	bool isFaceToLight = exposition > 0.0;
   	bool isNotTooFar = pos.x > 0.0 && pos.y > 0.0 && pos.x < 1.0 && pos.y < 1.0;

   	if (isFaceToLight || isFoliage)
   	{
   		if (isNotTooFar)
   		{
   			#ifdef SHADOW_HARDWARE_FILTERING
   				float shadowAmount = 1.0 - clamp(shadow2D(shadowtex0, pos).x, 0.0, 1.0);
   			#else
   				float shadowAmount = pos.z > texture2D(shadowtex0, pos.xy).x ? 1.0 : 0.0;
   			#endif

   			if (exposition < 0.4 && !isFoliage)
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

   vec4 computeShadow(in vec4 color, in vec3 pos, in float exposition, in float isFoliage)
   {
   	color.xyz *= getShadowBrightness(pos, exposition, isFoliage > 0.5);

   	return color;
   }
#endif

#ifdef VERTEX_SHADER
   float isFoliage(in vec3 entity)
   {
      if (entity.x == GRASS         ||
          entity.x == SAPLING       ||
          entity.x == LEAVES        ||
          entity.x == FLOWER        ||
          entity.x == CROP          ||
          entity.x == FLOWER_BOTTOM ||
          entity.x == FLOWER_TOP)
         return 1.0;

      return 0.0;
   }

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

   vec3 computeShadowPosition(in vec3 pos, in vec3 normal, in float exposition, in float isFoliage)
   {
   	pos = mat3(shadowModelView) * pos + shadowModelView[3].xyz;
   	pos = diag3(shadowProjection) * pos + shadowProjection[3].xyz;

   	normal = mat3(gbufferModelViewInverse) * normal;
   	normal = mat3(shadowModelView) * normal;

   	vec3 distortedPos = distort(pos);
   	distortedPos = distortedPos * 0.5 + 0.5;

      if (isFoliage > 0.5)
      {
         distortedPos.z -= 0.0002;
      }
      else
      {
         distortedPos.xyz += getNormalOffset(pos, normal, exposition);
         distortedPos.z -= getDepthBias(pos, exposition);
      }

   	return distortedPos;
   }
#endif
