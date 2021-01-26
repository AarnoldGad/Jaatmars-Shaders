/* shaders/include/settings.glsl
 * 29 Dec 2020
 * by TheAarnold
 **/

	const float pi = 3.1415926;

	#define CREDIT 0 // [0]

//Shadows
	#define SHADOWS
	#define SHADOW_BRIGHTNESS 0.55 // [0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
	const int shadowMapResolution = 2048; // [1024 2048 3072 4096 8192]
	const float shadowDistance = 128.0; // [32.0 80.0 96.0 128.0 192.0 256.0 512.0]
	#define SHADOW_HARDWARE_FILTERING

// Sky
	const float sunPathRotation = -35.0; // [-60.0 -55.0 -50.0 -45.0 -40.0 -35.0 -30.0 -25.0 -20.0 -15.0 -10.0 -5.0 0.0 5.0 10.0 15.0 20.0 25.0 30.0 35.0 40.0 45.0 50.0 55.0 60.0]

// Debug
// #define DEPTH_DEBUG

// Convenience
#ifdef SHADOW_HARDWARE_FILTERING
	const bool shadowHardwareFiltering = true;
#else
	const bool shadowHardwareFiltering = false;
	const bool shadowtex0Nearest = true;
#endif

// Constants
const float shadowMapBias = 1.0 - 12.8 / shadowDistance;

// ID Mappings
#define GRASS 10001
#define SAPLING 10002
#define LEAVES 10003
#define FLOWER 10004
#define CROP 10005
#define FLOWER_BOTTOM 10006
#define FLOWER_TOP 10007
