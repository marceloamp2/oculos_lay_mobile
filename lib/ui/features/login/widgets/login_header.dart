import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/themes/app_colors.dart';
import 'lens_ring.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  static const double height = 310;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned(
            top: -70,
            right: -90,
            child: LensRing(diameter: 300, opacity: 0.35),
          ),
          const Positioned(
            top: 20,
            right: 10,
            child: LensRing(diameter: 210, opacity: 0.2),
          ),
          const Positioned(
            bottom: -120,
            left: -110,
            child: LensRing(diameter: 280, opacity: 0.25),
          ),
          Positioned(
            top: 24,
            left: 24,
            child: Text(
              l10n.loginHeaderEyebrow,
              style: const TextStyle(
                color: AppColors.onDarkSurfaceMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.brandName,
                style: const TextStyle(
                  color: AppColors.lightSurface,
                  fontSize: 42,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 10,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.brandTagline,
                style: const TextStyle(
                  color: AppColors.lightSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 7,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 42,
            left: 24,
            right: 24,
            child: Text(
              l10n.loginHeaderSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.onDarkSurfaceMuted,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
