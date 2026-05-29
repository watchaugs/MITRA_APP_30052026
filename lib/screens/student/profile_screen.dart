// lib/screens/student/profile_screen.dart
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../../models/student_models.dart';
import '../../viewmodels/app_viewmodel.dart';
import '../../widgets/mitra_widgets.dart';
import '../../utils/router.dart';

// ── Mock badges ───────────────────────────────────────────────
final _mockBadges = [
  Badge(id: 'b1', title: 'First AR',      emoji: '🥽', description: 'Completed first AR session',     isUnlocked: true,  unlockedAt: '2024-04-01'),
  Badge(id: 'b2', title: 'Quiz Master',   emoji: '🧠', description: 'Scored 100% on 3 quizzes',       isUnlocked: true,  unlockedAt: '2024-04-03'),
  Badge(id: 'b3', title: 'Week Warrior',  emoji: '🔥', description: '7-day streak',                   isUnlocked: true,  unlockedAt: '2024-04-07'),
  Badge(id: 'b4', title: 'Science Nerd',  emoji: '🔬', description: 'Complete all Science AR topics', isUnlocked: false),
  Badge(id: 'b5', title: 'Top 3',         emoji: '🏆', description: 'Reach top 3 in class rank',      isUnlocked: false),
  Badge(id: 'b6', title: 'Polyglot',      emoji: '🌐', description: 'Use app in 3 different languages',isUnlocked: false),
];

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(studentProfileProvider);
    final badges  = _mockBadges;

    return Scaffold(
      backgroundColor: MC.bgDeep,
      appBar: AppBar(
        backgroundColor: MC.bgDeep,
        title: Text('My Profile', style: MT.display(16, weight: FontWeight.w700)),
        elevation: 0,
        actions: [
          IconButton(
            icon:  const Icon(Icons.settings_outlined, color: MC.textSecondary),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Profile Hero ──────────────────────────────────
          _ProfileHero(profile: profile)
              .animate().fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 20),

          // ── Stats row ─────────────────────────────────────
          _StatsRow(profile: profile)
              .animate(delay: 100.ms).fadeIn(),

          const SizedBox(height: 20),

          // ── Badges ────────────────────────────────────────
          MSectionHeader(
            title: 'My Badges (${badges.where((b) => b.isUnlocked).length}/${badges.length})',
          ),
          const SizedBox(height: 10),
          _BadgeGrid(badges: badges)
              .animate(delay: 150.ms).fadeIn(),

          const SizedBox(height: 20),

          // ── Settings shortcuts ─────────────────────────────
          const MSectionHeader(title: 'Preferences'),
          const SizedBox(height: 10),
          _SettingsShortcut(
            icon: Icons.language_rounded, label: 'Language',
            value: _langName(ref.watch(appProvider).language),
            onTap: () => context.push(Routes.settings),
          ),
          _SettingsShortcut(
            icon:  Icons.dark_mode_rounded, label: 'Dark Theme',
            value: ref.watch(appProvider).isDark ? 'On' : 'Off',
            onTap: () => ref.read(appProvider.notifier).toggleTheme(),
          ),
          _SettingsShortcut(
            icon: Icons.privacy_tip_outlined, label: 'Privacy Policy',
            onTap: () {},
          ),
          _SettingsShortcut(
            icon: Icons.info_outline_rounded, label: 'About MITRA',
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // ── Logout ────────────────────────────────────────
          MitraOutlineButton(
            label: 'Logout',
            onTap: () => _confirmLogout(context, ref),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  String _langName(String code) => switch (code) {
    'hi' => 'हिंदी',
    'ta' => 'தமிழ்',
    'te' => 'తెలుగు',
    _    => 'English',
  };

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: MC.bgCard,
        title: Text('Logout?', style: MT.display(18)),
        content: Text('Are you sure you want to sign out?', style: MT.body(14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(appProvider.notifier).logout();
            },
            child: const Text('Logout', style: TextStyle(color: MC.crimson)),
          ),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile});
  final StudentProfile? profile;

  @override
  Widget build(BuildContext context) {
    return MCard(
      gradient: MG.cardDark,
      child: Column(children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            gradient:     MG.indigo,
            shape:        BoxShape.circle,
            border:       Border.all(color: MC.saffron.withValues(alpha: 0.5), width: 2),
          ),
          child: Center(child: Text(profile?.avatar ?? '👦',
            style: const TextStyle(fontSize: 36))),
        ),
        const SizedBox(height: 10),
        Text(profile?.name ?? '—', style: MT.display(18, weight: FontWeight.w700)),
        Text(
          'Class ${profile?.classGrade ?? '—'} · ${profile?.schoolName ?? '—'}',
          style: MT.body(13, color: MC.textSecondary)),
        const SizedBox(height: 8),
        Text('📍 ${profile?.stateName ?? 'India'}',
          style: MT.body(12, color: MC.textMuted)),
      ]),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.profile});
  final StudentProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: _StatCard('🔥', '${profile?.streakDays ?? 0}', 'Day Streak')),
      const SizedBox(width: 12),
      Expanded(child: _StatCard('✨', '${profile?.xp ?? 0}', 'Total XP')),
      const SizedBox(width: 12),
      Expanded(child: _StatCard('🏆', profile?.rankLabel ?? '#—', 'Class Rank')),
    ]);
  }

  Widget _StatCard(String emoji, String val, String label) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color:        MC.bgCard,
      borderRadius: BorderRadius.circular(MR.md),
      border:       Border.all(color: MC.border),
    ),
    child: Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 4),
      Text(val, style: MT.display(16, weight: FontWeight.w800, color: MC.saffron)),
      Text(label, style: MT.body(10, color: MC.textMuted)),
    ]),
  );
}

class _BadgeGrid extends StatelessWidget {
  const _BadgeGrid({required this.badges});
  final List<Badge> badges;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics:    const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 8,
        mainAxisSpacing: 8, childAspectRatio: 0.9,
      ),
      itemCount:   badges.length,
      itemBuilder: (_, i) => _BadgeTile(badge: badges[i])
          .animate(delay: (i * 40).ms).fadeIn().scale(begin: const Offset(0.8, 0.8)),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge});
  final Badge badge;

  @override
  Widget build(BuildContext context) {
    final locked = !badge.isUnlocked;
    return Tooltip(
      message: badge.description,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:        locked ? Colors.transparent : MC.saffron.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(MR.md),
          border:       Border.all(color: locked ? MC.border : MC.saffron.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: locked ? 0.3 : 1.0,
              child: Text(badge.emoji, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 6),
            Text(badge.title,
              style: MT.body(10, weight: FontWeight.w700,
                color: locked ? MC.textMuted : MC.textPrimary),
              textAlign: TextAlign.center, maxLines: 1),
          ],
        ),
      ),
    );
  }
}

class _SettingsShortcut extends StatelessWidget {
  const _SettingsShortcut({
    required this.icon, required this.label, this.value, required this.onTap});
  final IconData icon;
  final String   label;
  final String?  value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color:        MC.bgCard,
        borderRadius: BorderRadius.circular(MR.sm),
        border:       Border.all(color: MC.border),
      ),
      child: Row(children: [
        Icon(icon, color: MC.textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: MT.body(14, weight: FontWeight.w500))),
        if (value != null)
          Text(value!, style: MT.body(13, color: MC.saffron, weight: FontWeight.w600)),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right_rounded, color: MC.textMuted, size: 18),
      ]),
    ),
  );
}

// ═════════════════════════════════════════════════════════════
// SETTINGS SCREEN
// ═════════════════════════════════════════════════════════════
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _languages = [
    ('en', 'English'), ('hi', 'हिंदी'), ('ta', 'தமிழ்'),
    ('te', 'తెలుగు'), ('kn', 'ಕನ್ನಡ'), ('bn', 'বাংলা'),
    ('mr', 'मराठी'), ('gu', 'ગુજરાતી'), ('pa', 'ਪੰਜਾਬੀ'),
    ('or', 'ଓଡ଼ିଆ'), ('as', 'অসমীয়া'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState  = ref.watch(appProvider);

    return Scaffold(
      backgroundColor: MC.bgDeep,
      appBar: AppBar(
        backgroundColor: MC.bgDeep,
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back_ios_rounded,
            color: MC.textSecondary),
          onPressed: () => context.pop(),
        ),
        title: Text('Settings', style: MT.display(16, weight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Appearance ─────────────────────────────────────
          _SettingSection(title: 'Appearance', children: [
            _SwitchTile(
              icon:    Icons.dark_mode_rounded,
              label:   'Dark Theme',
              sub:     'Easier on the eyes at night',
              value:   appState.isDark,
              onChanged: (_) => ref.read(appProvider.notifier).toggleTheme(),
            ),
          ]),

          // ── Language ──────────────────────────────────────
          _SettingSection(title: 'Language', children: [
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _languages.map((l) {
                final selected = appState.language == l.$1;
                return GestureDetector(
                  onTap: () => ref.read(appProvider.notifier).setLanguage(l.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color:        selected ? MC.saffron.withValues(alpha: 0.15) : MC.bgSurface,
                      border:       Border.all(
                        color: selected ? MC.saffron : MC.border,
                        width: selected ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(MR.pill),
                    ),
                    child: Text(l.$2, style: MT.body(13,
                      weight: selected ? FontWeight.w600 : FontWeight.w400,
                      color:  selected ? MC.saffron : MC.textSecondary)),
                  ),
                );
              }).toList(),
            ),
          ]),

          // ── AR & Content ──────────────────────────────────
          _SettingSection(title: 'AR & Content', children: [
            _SwitchTile(
              icon:    Icons.download_rounded,
              label:   'Auto-download Offline',
              sub:     'Cache content automatically',
              value:   true, // settings.autoDownload,
              onChanged: (_) {},
            ),
            _SwitchTile(
              icon:    Icons.wifi_rounded,
              label:   'Wi-Fi Only Download',
              sub:     'Saves your mobile data',
              value:   true, // settings.wifiOnly,
              onChanged: (_) {},
            ),
            _SwitchTile(
              icon:    Icons.volume_up_rounded,
              label:   'AR Sound Effects',
              sub:     'Audio cues in AR sessions',
              value:   true, // settings.arSound,
              onChanged: (_) {},
            ),
          ]),

          // ── Notifications ─────────────────────────────────
          _SettingSection(title: 'Notifications', children: [
            _SwitchTile(
              icon:    Icons.notifications_outlined,
              label:   'All Notifications',
              sub:     'Quizzes, streaks, leaderboard',
              value:   true, // settings.notifEnabled,
              onChanged: (_) {},
            ),
          ]),

          // ── About ─────────────────────────────────────────
          _SettingSection(title: 'About & Legal', children: [
            const _InfoTile('App Version',      '1.0.0 (Build 1)'),
            _InfoTile('Curriculum Board', appState.config?.curriculumBoard ?? 'NCERT'),
            _InfoTile('State',            appState.config?.stateName ?? '—'),
            const _InfoTile('Compliance',       'DPDP 2023 · COPPA · IT Act 2000'),
            const _LinkTile(Icons.privacy_tip_outlined, 'Privacy Policy',
              'https://mitra.gov.in/privacy'),
            const _LinkTile(Icons.description_outlined, 'Terms of Service',
              'https://mitra.gov.in/terms'),
            const _LinkTile(Icons.child_care_rounded, 'Child Safety Policy',
              'https://mitra.gov.in/child-safety'),
            const _LinkTile(Icons.manage_accounts_outlined, 'Data & Consent',
              'https://mitra.gov.in/data-rights'),
          ]),

          const SizedBox(height: 40),
          Center(child: Text('Made with ❤️ in India · Ministry of Education',
            style: MT.body(11, color: MC.textMuted))),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _SettingSection extends StatelessWidget {
  const _SettingSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 12, top: 12),
        child: Text(title.toUpperCase(), style: MT.body(11,
          weight: FontWeight.w700, color: MC.textMuted)),
      ),
      MCard(
        padding: EdgeInsets.zero,
        child: Column(children: children),
      ),
    ],
  );
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon, required this.label, required this.sub,
    required this.value, required this.onChanged});
  final IconData icon;
  final String label, sub;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: MC.bgSurface, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: MC.textSecondary, size: 20),
    ),
    title: Text(label, style: MT.body(14, weight: FontWeight.w600)),
    subtitle: Text(sub, style: MT.body(12, color: MC.textMuted)),
    trailing: Switch(value: value, onChanged: onChanged),
  );
}

class _InfoTile extends StatelessWidget {
  const _InfoTile(this.label, this.val);
  final String label, val;
  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(label, style: MT.body(14)),
    trailing: Text(val, style: MT.body(13, color: MC.textMuted, weight: FontWeight.w600)),
  );
}

class _LinkTile extends StatelessWidget {
  const _LinkTile(this.icon, this.label, this.url);
  final IconData icon;
  final String label, url;
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: MC.textMuted, size: 18),
    title: Text(label, style: MT.body(14)),
    trailing: const Icon(Icons.open_in_new_rounded, size: 14, color: MC.textMuted),
    onTap: () {}, // launchUrl
  );
}
