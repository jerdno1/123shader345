#ifdef WATER_DEBUG_COLORS_ENABLED
_yssmf1.rgb = vec3(1.0, 1.0, 0.0);
_yssmf1.a = 0.35;
#else
_yssmf1.rgb = _gkt4lb(_yssmf1.rgb, sunAngle, skylight);
#endif
