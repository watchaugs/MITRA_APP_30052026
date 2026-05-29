// lib/screens/student/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../models/student_models.dart';
import '../../viewmodels/app_viewmodel.dart';
import '../../widgets/mitra_widgets.dart';

// ── Mock providers (replace with real API providers) ──────────
final subjectsProvider = Provider<List<Subject>>((ref) => _mockSubjects);
final leaderboardProvider = Provider<List<LeaderboardEntry>>((ref) => _mockLb);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile  = ref.watch(studentProfileProvider);
    final subjects = ref.watch(subjectsProvider);
    final lb       = ref.watch(leaderboardProvider);
    final flags    = ref.watch(featureFlagsProvider);
    final isOffline = ref.watch(appProvider).isOffline;

    return Scaffold(
      backgroundColor: MC.bgDeep,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          color:     MC.saffron,
          backgroundColor: MC.bgCard,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              if (isOffline) const OfflineBanner(),

              // ── Header ────────────────────────────────────
              _HomeHeader(profile: profile)
                  .animate().fadeIn(delay: 50.ms),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // ── Continue Learning ──────────────────
                    _ContinueLearning()
                        .animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

                    const SizedBox(height: 20),

                    // ── Subjects grid ──────────────────────
                    MSectionHeader(
                      title: 'Subjects',
                      trailing: Text('${subjects.length} of ${subjects.length}',
                        style: MT.body(12, color: MC.textMuted)),
                    ),
                    const SizedBox(height: 10),
                    _SubjectGrid(subjects: subjects)
                        .animate().fadeIn(delay: 150.ms),

                    const SizedBox(height: 20),

                    // ── Quick Actions ──────────────────────
                    MSectionHeader(title: 'Quick Actions'),
                    const SizedBox(height: 10),
                    _QuickActions(flags: flags)
                        .animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 20),

                    // ── Leaderboard preview ────────────────
                    if (flags.isLeaderboardEnabled) ...[
                      MSectionHeader(
                        title: 'Class Rank',
                        trailing: GestureDetector(
                          onTap: () {},
                          child: Text('View all',
                            style: MT.body(12, color: MC.saffron)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _LeaderboardCard(entries: lb.take(3).toList())
                          .animate().fadeIn(delay: 250.ms),
                    ],

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Home Header ───────────────────────────────────────────────
class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.profile});
  final StudentProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end:   Alignment.bottomCenter,
          colors: [MC.bgCard, MC.bgDeep],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(profile?.greeting ?? 'Good morning,',
                  style: MT.body(13, color: MC.textSecondary)),
                Text(profile?.name ?? 'Student 👋',
                  style: MT.display(20, weight: FontWeight.w800)),
              ]),
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  gradient:     MG.indigo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(profile?.avatar ?? '👦',
                    style: const TextStyle(fontSize: 22)),
                ),
              ),
            ],
          ),
          if (profile != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color:        MC.bgSurface,
                borderRadius: BorderRadius.circular(MR.pill),
                border:       Border.all(color: MC.border),
              ),
              child: Text(
                '🏫 Class ${profile!.classGrade} · ${profile!.schoolName}',
                style: MT.body(12, color: MC.textSecondary),
              ),
            ),
            const SizedBox(height: 12),
            StreakRow(
              streak: profile!.streakDays,
              xp:     profile!.xp,
              rank:   profile!.rankLabel,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Continue Learning Card ────────────────────────────────────
class _ContinueLearning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MCard(
      gradient: MG.cardDark,
      borderColor: MC.saffron.withValues(alpha: 0.3),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Continue Learning',
              style: MT.body(11, weight: FontWeight.w600, color: MC.textSecondary)
                  .copyWith(letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Text('Science · Chapter 3',
              style: MT.body(12, color: MC.textMuted)),
            const SizedBox(height: 4),
            Text('🔬 Microscopy & Cell Structure AR',
              style: MT.body(14, weight: FontWeight.w600)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient:     MG.saffron,
              borderRadius: BorderRadius.circular(MR.xs),
            ),
            child: Text('65%', style: MT.body(13, weight: FontWeight.w700, color: Colors.white)),
          ),
        ]),
        const SizedBox(height: 12),
        MProgressBar(value: 0.65, color: MC.saffron, height: 6),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('13/20 topics', style: MT.body(11, color: MC.textMuted)),
            XpChip(120),
          ],
        ),
      ]),
    );
  }
}

// ── Subject Grid ──────────────────────────────────────────────
class _SubjectGrid extends StatelessWidget {
  const _SubjectGrid({required this.subjects});
  final List<Subject> subjects;

  @override
  Widget build(BuildContext context) {
    final filtered = subjects.where((s) => s.isAvailable).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:   2,
        crossAxisSpacing: 10,
        mainAxisSpacing:  10,
        childAspectRatio: 1.5,
      ),
      itemCount: filtered.length,
      itemBuilder: (_, i) => _SubjectCard(subject: filtered[i]),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({required this.subject});
  final Subject subject;

  @override
  Widget build(BuildContext context) {
    final color = _hexColor(subject.colorHex);
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:        color.withValues(alpha: 0.1),
          border:       Border.all(color: color.withValues(alpha: 0.25)),
          borderRadius: BorderRadius.circular(MR.md),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(subject.emoji, style: const TextStyle(fontSize: 22)),
            if (subject.arTopics > 0) const ArChip(),
          ]),
          const Spacer(),
          Text(subject.name, style: MT.body(13, weight: FontWeight.w600)),
          Text(
            '${(subject.progressPct * 100).toInt()}% · ${subject.arTopics} AR',
            style: MT.body(11, color: MC.textMuted),
          ),
          const SizedBox(height: 4),
          MProgressBar(value: subject.progressPct, color: color, height: 3),
        ]),
      ),
    );
  }

  Color _hexColor(String hex) {
    try { return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16)); }
    catch (_) { return MC.saffron; }
  }
}

// ── Quick Actions ─────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.flags});
  final dynamic flags;

  @override
  Widget build(BuildContext context) {
    final actions = <({String icon, String label, bool show})>[
      (icon: '🥽', label: 'Open AR',     show: true),
      (icon: '📝', label: 'Take Quiz',   show: true),
      (icon: '🏆', label: 'Leaderboard', show: true),
      (icon: '📴', label: 'Download',    show: true),
    ];
    return Row(
      children: actions
          .where((a) => a.show)
          .map((a) => Expanded(child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color:        MC.bgCard,
                border:       Border.all(color: MC.border),
                borderRadius: BorderRadius.circular(MR.sm),
              ),
              child: Column(children: [
                Text(a.icon, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 4),
                Text(a.label, style: MT.body(11, color: MC.textSecondary),
                  textAlign: TextAlign.center),
              ]),
            ),
          )))
          .toList(),
    );
  }
}

// ── Leaderboard Preview ───────────────────────────────────────
class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard({required this.entries});
  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    return MCard(
      child: Column(
        children: entries.map((e) => _LbRow(entry: e)).toList(),
      ),
    );
  }
}

class _LbRow extends StatelessWidget {
  const _LbRow({required this.entry});
  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: entry.isCurrentUser
          ? const EdgeInsets.all(8)
          : EdgeInsets.zero,
      decoration: entry.isCurrentUser
          ? BoxDecoration(
              color:        MC.saffron.withValues(alpha: 0.06),
              border:       Border.all(color: MC.saffron.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(MR.xs),
            )
          : null,
      child: Row(children: [
        Text(entry.rankEmoji,
          style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color:        MC.bgSurface,
            shape:        BoxShape.circle,
            border:       Border.all(color: MC.border),
          ),
          child: Center(child: Text(entry.avatar,
            style: const TextStyle(fontSize: 16))),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            entry.isCurrentUser ? '${entry.name} (You)' : entry.name,
            style: MT.body(13, weight: FontWeight.w500),
          ),
          Text('${entry.xp} XP',
            style: MT.body(11, color: MC.textMuted)),
        ])),
        Text('${entry.xp}',
          style: MT.body(14, weight: FontWeight.w700,
            color: entry.rank == 1 ? MC.gold : MC.textPrimary)),
      ]),
    );
  }
}

// ── Mock data ─────────────────────────────────────────────────
final _mockSubjects = [
  Subject(id: 's1', name: 'Science',   emoji: '🔬', colorHex: '#6366F1', totalTopics: 20, arTopics: 14, progressPct: 0.68),
  Subject(id: 's2', name: 'Maths',     emoji: '📐', colorHex: '#10B981', totalTopics: 18, arTopics: 8,  progressPct: 0.45),
  Subject(id: 's3', name: 'History',   emoji: '📜', colorHex: '#F59E0B', totalTopics: 12, arTopics: 6,  progressPct: 0.30),
  Subject(id: 's4', name: 'Geography', emoji: '🌍', colorHex: '#06B6D4', totalTopics: 10, arTopics: 5,  progressPct: 0.55),
];

final _mockLb = [
  const LeaderboardEntry(rank: 1, name: 'Rahul Gupta',  avatar: '😎', xp: 3200),
  const LeaderboardEntry(rank: 2, name: 'Anjali Singh',  avatar: '🧑', xp: 3050),
  const LeaderboardEntry(rank: 3, name: 'Priya Sharma',  avatar: '👧', xp: 2840, isCurrentUser: true),
];
