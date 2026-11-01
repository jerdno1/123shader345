#ifdef WATER_DEBUG_COLORS_ENABLED
_yssmf1.rgb = vec3(0.0, 1.0, 1.0);
_yssmf1.a = 0.35;
#else
_yssmf1.rgb = _iroce3(_yssmf1.rgb, sunAngle, skylight, _d5ovut, 0.0, shadow, worldPos.y);
#endif
