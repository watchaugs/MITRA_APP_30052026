// lib/widgets/mitra_widgets.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme.dart';

// ── Gradient Button (btn-primary in HTML) ─────────────────────
class MitraButton extends StatelessWidget {
  const MitraButton({
    super.key,
    required this.label,
    required this.onTap,
    this.gradient = MG.saffron,
    this.icon,
    this.isLoading = false,
    this.small = false,
    this.fullWidth = true,
  });

  final String       label;
  final VoidCallback onTap;
  final Gradient     gradient;
  final Widget?      icon;
  final bool         isLoading;
  final bool         small;
  final bool         fullWidth;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(width: 20, height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, SizedBox(width: small ? 4 : 8)],
              Text(label, style: MT.body(small ? 13 : 15,
                  weight: FontWeight.w600, color: Colors.white)),
            ],
          );

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: small ? 16 : 24,
          vertical:   small ? 10 : 14,
        ),
        decoration: BoxDecoration(
          gradient:     gradient,
          borderRadius: BorderRadius.circular(MR.sm),
          boxShadow: [
            BoxShadow(
              color:       MC.saffron.withValues(alpha: 0.3),
              blurRadius:  12,
              offset:      const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

// ── Secondary Button (btn-secondary) ─────────────────────────
class MitraOutlineButton extends StatelessWidget {
  const MitraOutlineButton({
    super.key,
    required this.label,
    required this.onTap,
    this.fullWidth = true,
  });
  final String label;
  final VoidCallback onTap;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
      decoration: BoxDecoration(
        border:       Border.all(color: MC.border),
        borderRadius: BorderRadius.circular(MR.sm),
        color:        MC.bgSurface,
      ),
      alignment: Alignment.center,
      child: Text(label, style: MT.body(14, weight: FontWeight.w500,
          color: MC.textSecondary)),
    ),
  );
}

// ── Card Container ────────────────────────────────────────────
class MCard extends StatelessWidget {
  const MCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.borderColor,
    this.onTap,
  });
  final Widget  child;
  final EdgeInsetsGeometry? padding;
  final Gradient?  gradient;
  final Color?     borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        gradient == null ? MC.bgCard : null,
        gradient:     gradient,
        border:       Border.all(color: borderColor ?? MC.border),
        borderRadius: BorderRadius.circular(MR.md),
      ),
      child: child,
    ),
  );
}

// ── Progress Bar (from HTML .progress-bar) ────────────────────
class MProgressBar extends StatelessWidget {
  const MProgressBar({super.key, required this.value, this.color, this.height = 5});
  final double value;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(height),
    child: LinearProgressIndicator(
      value:           value.clamp(0.0, 1.0),
      minHeight:       height,
      backgroundColor: MC.bgSurface,
      valueColor: AlwaysStoppedAnimation(color ?? MC.saffron),
    ),
  );
}

// ── XP Chip ───────────────────────────────────────────────────
class XpChip extends StatelessWidget {
  const XpChip(this.xp, {super.key, this.color});
  final int   xp;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color:        (color ?? MC.gold).withValues(alpha: 0.15),
      border:       Border.all(color: (color ?? MC.gold).withValues(alpha: 0.4)),
      borderRadius: BorderRadius.circular(MR.pill),
    ),
    child: Text('+$xp XP',
      style: MT.body(11, weight: FontWeight.w600, color: color ?? MC.gold)),
  );
}

// ── AR Badge chip ─────────────────────────────────────────────
class ArChip extends StatelessWidget {
  const ArChip({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      gradient:     MG.emerald,
      borderRadius: BorderRadius.circular(MR.pill),
    ),
    child: Text('AR',
      style: MT.body(10, weight: FontWeight.w700, color: Colors.white)),
  );
}

// ── Status tag ────────────────────────────────────────────────
class TopicStatusTag extends StatelessWidget {
  const TopicStatusTag(this.status, {super.key});
  final String status; // 'done' | 'active' | 'locked'

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'done'   => ('Done',   MC.emerald),
      'active' => ('Active', MC.saffron),
      _        => ('🔒',     MC.textMuted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:        color.withValues(alpha: 0.15),
        border:       Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(MR.xs),
      ),
      child: Text(label,
        style: MT.body(11, weight: FontWeight.w600, color: color)),
    );
  }
}

// ── Shimmer placeholder ───────────────────────────────────────
class MShimmer extends StatelessWidget {
  const MShimmer({super.key, required this.width, required this.height, this.radius = 10});
  final double width, height, radius;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor:      MC.bgSurface,
    highlightColor: MC.bgCard,
    child: Container(
      width: width, height: height,
      decoration: BoxDecoration(
        color:        MC.bgSurface,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

// ── Connectivity Banner ───────────────────────────────────────
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    color: MC.gold.withValues(alpha: 0.15),
    child: Row(children: [
      const Icon(Icons.cloud_off_rounded, color: MC.gold, size: 14),
      const SizedBox(width: 8),
      Expanded(child: Text(
        'You\'re offline. Showing downloaded content.',
        style: MT.body(12, color: MC.gold),
      )),
    ]),
  );
}

// ── Section Header ────────────────────────────────────────────
class MSectionHeader extends StatelessWidget {
  const MSectionHeader({super.key, required this.title, this.trailing});
  final String  title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Text(title,
      style: MT.body(14, weight: FontWeight.w600, color: MC.textPrimary))),
    if (trailing != null) trailing!,
  ]);
}

// ── Streak row ────────────────────────────────────────────────
class StreakRow extends StatelessWidget {
  const StreakRow({super.key, required this.streak, required this.xp, required this.rank});
  final int    streak, xp;
  final String rank;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _StreakItem('🔥 $streak', 'day streak'),
      const SizedBox(width: 16),
      _StreakItem('⭐ $xp',   'XP'),
      const SizedBox(width: 16),
      _StreakItem(rank,        'in class'),
    ]);
  }
}

class _StreakItem extends StatelessWidget {
  const _StreakItem(this.val, this.lbl);
  final String val, lbl;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(val, style: MT.display(14, weight: FontWeight.w700)),
      Text(lbl, style: MT.body(11, color: MC.textSecondary)),
    ],
  );
}

// ── Bottom nav (dynamic) ──────────────────────────────────────
class MitraBottomNav extends StatelessWidget {
  const MitraBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });
  final int                currentIndex;
  final List<({String icon, String label})> items;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color:  MC.bgCard,
      border: Border(top: BorderSide(color: MC.border)),
    ),
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: 60,
        child: Row(
          children: items.asMap().entries.map((e) {
            final active = e.key == currentIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(e.key),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color:        active ? MC.saffron.withValues(alpha: 0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(MR.sm),
                      ),
                      child: Text(e.value.icon, style: const TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(height: 2),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 180),
                      style: MT.body(10,
                        weight: active ? FontWeight.w700 : FontWeight.w400,
                        color:  active ? MC.saffron : MC.textMuted),
                      child: Text(e.value.label),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}

// ── Generic error view ────────────────────────────────────────
class MErrorView extends StatelessWidget {
  const MErrorView({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:        MC.crimson.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(MR.md),
            border: Border.all(color: MC.crimson.withValues(alpha: 0.3)),
          ),
          child: const Icon(Icons.cloud_off_rounded, color: MC.crimson, size: 32),
        ),
        const SizedBox(height: 16),
        Text('Oops!', style: MT.display(18, weight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center,
          style: MT.body(13, color: MC.textSecondary)),
        if (onRetry != null) ...[
          const SizedBox(height: 20),
          MitraButton(label: 'Try Again', onTap: onRetry!, fullWidth: false),
        ],
      ]),
    ),
  );
}
