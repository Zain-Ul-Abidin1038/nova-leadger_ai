import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Frosted Glass Card Widget with enhanced premium effects
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final EdgeInsets? padding;
  final Color? borderColor;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 20.0,
    this.borderRadius = 24.0,
    this.padding,
    this.borderColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark 
        ? AppColors.glassWhite 
        : Colors.white.withOpacity(0.7);
    final defaultBorderColor = isDark 
        ? AppColors.glassBorder 
        : const Color(0xFFE0E0E0);
    final defaultGradient = isDark
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.02),
            ],
          )
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.9),
              Colors.white.withOpacity(0.7),
            ],
          );
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            gradient: gradient ?? defaultGradient,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? defaultBorderColor,
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Neon-bordered Circular Button with enhanced glow and interaction
class NeonButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color neonColor;
  final bool isSecondary;

  const NeonButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.neonColor = AppColors.neonTeal,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: neonColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    neonColor.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
                border: Border.all(
                  color: neonColor.withOpacity(0.8),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: neonColor,
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: isSecondary ? AppColors.textSecondary : AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Specialized Action Button for main tasks
class GhostActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color baseColor;

  const GhostActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.baseColor = AppColors.neonTeal,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 16,
      borderColor: baseColor.withOpacity(0.3),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: baseColor, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Glass Notification Widget (For Ghost Trace)
class GlassNotification extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color accentColor;

  const GlassNotification({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.psychology,
    this.accentColor = AppColors.softPurple,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      borderColor: accentColor.withOpacity(0.4),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accentColor.withOpacity(0.15),
          Colors.white.withOpacity(0.02),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.4,
                    fontFamily: 'SpaceGrotesk', // Assuming it's loaded
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
