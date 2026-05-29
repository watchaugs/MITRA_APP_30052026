// lib/screens/student/ranks_screen.dart
// cSpell:ignore riverpod viewmodels
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../viewmodels/app_viewmodel.dart';
import '../../widgets/mitra_widgets.dart';

// ── Mock leaderboard data ─────────────────────────────────────
const _mockRanks = [
  (rank: 1,  name: 'Priya S.',    avatar: '👧', xp: 4820, state: 'GJ'),
  (rank: 2,  name: 'Arjun M.',    avatar: '👦', xp: 4610, state: 'MH'),
  (rank: 3,  name: 'Sneha R.',    avatar: '🧑', xp: 4390, state: 'GJ'),
  (rank: 4,  name: 'Rohan K.',    avatar: '👦', xp: 4100, state: 'RJ'),
  (rank: 5,  name: 'Ananya T.',   avatar: '👩', xp: 3980, state: 'GJ'),
  (rank: 6,  name: 'Dev P.',      avatar: '🦸', xp: 3750, state: 'MH'),
  (rank: 7,  name: 'Kavya N.',    avatar: '👧', xp: 3520, state: 'KA'),
  (rank: 8,  name: 'Rahul V.',    avatar: '👦', xp: 3310, state: 'GJ'),
  (rank: 9,  name: 'Ishaan D.',   avatar: '🧑', xp: 3090, state: 'UP'),
  (rank: 10, name: 'Meera J.',    avatar: '👩', xp: 2870, state: 'GJ'),
];

class RanksScreen extends ConsumerWidget {
  const RanksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(studentProfileProvider);

    // Find current user's mock rank (stub: always 5th)
    const myRank = 5;

    return Scaffold(
      backgroundColor: MC.bgDeep,
      appBar: AppBar(
        backgroundColor: MC.bgDeep,
        title: Text('Leaderboard', style: MT.display(16, weight: FontWeight.w700)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Top 3 podium ──────────────────────────────────
          _Podium(top3: _mockRanks.take(3).toList()),

          const SizedBox(height: 8),

          // ── My rank chip ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color:        MC.saffron.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(MR.sm),
                border:       Border.all(color: MC.saffron.withValues(alpha: 0.4)),
              ),
              child: Row(children: [
                const Text('📍', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text('Your rank: #$myRank',
                  style: MT.body(14, weight: FontWeight.w600, color: MC.saffron)),
                const Spacer(),
                Text('${_mockRanks[myRank - 1].xp} XP',
                  style: MT.body(13, color: MC.textSecondary)),
              ]),
            ),
          ),

          const SizedBox(height: 12),

          // ── Full list ─────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _mockRanks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final entry = _mockRanks[i];
                final isMe  = entry.rank == myRank;
                return _RankRow(entry: entry, isMe: isMe);
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ── Podium widget ─────────────────────────────────────────────
class _Podium extends StatelessWidget {
  const _Podium({required this.top3});
  final List<({int rank, String name, String avatar, int xp, String state})> top3;

  @override
  Widget build(BuildContext context) {
    // Order: 2nd, 1st, 3rd
    final order = [top3[1], top3[0], top3[2]];
    final heights = [80.0, 110.0, 60.0];
    final medals  = ['🥈', '🥇', '🥉'];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [MC.bgCard, MC.bgDeep],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          final entry = order[i];
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(entry.avatar, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 4),
                Text(entry.name.split(' ').first,
                  style: MT.body(11, weight: FontWeight.w600),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${entry.xp} XP',
                  style: MT.body(10, color: MC.textMuted)),
                const SizedBox(height: 6),
                Container(
                  height: heights[i],
                  decoration: BoxDecoration(
                    gradient: i == 1 ? MG.saffron : MG.indigo,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Center(
                    child: Text(medals[i], style: const TextStyle(fontSize: 24)),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Single rank row ───────────────────────────────────────────
class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.entry,
    required this.isMe,
  });
  final ({int rank, String name, String avatar, int xp, String state}) entry;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color:        isMe ? MC.saffron.withValues(alpha: 0.08) : MC.bgCard,
        borderRadius: BorderRadius.circular(MR.sm),
        border:       Border.all(
          color: isMe ? MC.saffron.withValues(alpha: 0.4) : MC.border,
        ),
      ),
      child: Row(children: [
        SizedBox(
          width: 28,
          child: Text('#${entry.rank}',
            style: MT.body(13, weight: FontWeight.w700,
              color: entry.rank <= 3 ? MC.saffron : MC.textMuted)),
        ),
        const SizedBox(width: 10),
        Text(entry.avatar, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.name,
              style: MT.body(14, weight: isMe ? FontWeight.w700 : FontWeight.w500,
                color: isMe ? MC.saffron : MC.textPrimary)),
            Text(entry.state,
              style: MT.body(11, color: MC.textMuted)),
          ],
        )),
        Text('${entry.xp} XP',
          style: MT.body(13, weight: FontWeight.w600, color: MC.textSecondary)),
      ]),
    );
  }
}
