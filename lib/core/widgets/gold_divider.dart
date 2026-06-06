import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GoldDivider extends StatelessWidget {
  final double width;
  final double thickness;

  const GoldDivider({super.key, this.width = 60, this.thickness = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: thickness,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.textGoldDim,
            AppColors.textGold,
            AppColors.textGoldDim,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class GoldBorderCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final bool showGoldBorder;

  const GoldBorderCard({
    super.key,
    required this.child,
    required this.backgroundColor,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.all(16),
    this.showGoldBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showGoldBorder
            ? Border.all(
                color: AppColors.cardBorderGold,
                width: 0.8,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
