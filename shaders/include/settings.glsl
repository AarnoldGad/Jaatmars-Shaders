/* shaders/include/settings.glsl
 * 29 Dec 2020
 * by TheAarnold
 **/

	#define CREDIT 0 // [0]

	#define SHADOWS
	#define SHADOW_SHARPNESS 0 // [0 1 2]
	const int shadowMapResolution = 2048; // [512 1024 2048 3072 4096 8192]
	const float shadowDistance = 256.0; //[128.0 192.0 256.0 384.0 512.0 768.0 1024.0]

	const float sunPathRotation = -35.0; //[-60.0 -55.0 -50.0 -45.0 -40.0 -35.0 -30.0 -25.0 -20.0 -15.0 -10.0 -5.0 0.0 5.0 10.0 15.0 20.0 25.0 30.0 35.0 40.0 45.0 50.0 55.0 60.0]
	#define SUN_GLARE
	#define SUN_FLARE

	const float pi = 3.1415926;

// #define DEPTH_DEBUG
