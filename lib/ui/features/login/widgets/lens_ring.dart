import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';

class LensRing extends StatelessWidget {
  const LensRing({super.key, required this.diameter, required this.opacity});

  final double diameter;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.onDarkSurfaceMuted.withValues(alpha: opacity),
        ),
      ),
    );
  }
}
