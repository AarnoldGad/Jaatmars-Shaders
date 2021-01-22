/* shaders/include/settings.glsl
 * 29 Dec 2020
 * by TheAarnold
 **/

	const float pi = 3.1415926;

	#define CREDIT 0 // [0]

	#define SHADOWS
	#define SHADOW_SHARPNESS 0 // [0 1 2]
	#define SHADOW_BRIGHTNESS 0.55 // [0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
	#define SHADOWMAP_BIAS  0.8 // [0.5 0.6 0.7 0.8 0.9]
	const int shadowMapResolution = 2048; // [1024 2048 3072 4096 8192]
	const float shadowDistance = 128.0; // [80.0 96.0 128.0 192.0 256.0 384.0 512.0 768.0 1024.0]
	const bool shadowHardwareFiltering = true;

	const float sunPathRotation = -35.0; // [-60.0 -55.0 -50.0 -45.0 -40.0 -35.0 -30.0 -25.0 -20.0 -15.0 -10.0 -5.0 0.0 5.0 10.0 15.0 20.0 25.0 30.0 35.0 40.0 45.0 50.0 55.0 60.0]

// #define DEPTH_DEBUG
