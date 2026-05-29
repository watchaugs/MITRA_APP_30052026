// lib/screens/student/learn_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';

class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  String _filter   = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MC.bgDeep,
      appBar: AppBar(
        title: Text('Learn', style: MT.display(18, weight: FontWeight.w800)),
        backgroundColor: MC.bgDeep,
        elevation: 0,
      ),
      body: Column(children: [
        // Search + Filter
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Column(children: [
            TextField(
              onChanged: (v) {},
              style:     MT.body(14),
              decoration: const InputDecoration(
                hintText:   'Search topics, chapters…',
                prefixIcon: Icon(Icons.search_rounded,
                  color: MC.textMuted, size: 20),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              _buildFilter('All',        'all'),
              const SizedBox(width: 8),
              _buildFilter('AR Ready',   'ar'),
              const SizedBox(width: 8),
              _buildFilter('Incomplete', 'incomplete'),
            ]),
          ]),
        ),
        
        const Expanded(child: Center(child: Text('Content Loading...'))),
      ]),
    );
  }

  Widget _buildFilter(String label, String val) {
    final selected = _filter == val;
    return GestureDetector(
      onTap: () => setState(() => _filter = val),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color:        selected ? MC.saffron.withValues(alpha: 0.15) : MC.bgCard,
          border:       Border.all(
            color: selected ? MC.saffron : MC.border,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(MR.pill),
        ),
        child: Text(label, style: MT.body(12,
          weight: selected ? FontWeight.w600 : FontWeight.w400,
          color:  selected ? MC.saffron : MC.textSecondary)),
      ),
    );
  }
}

// RANKS SCREEN
// ═════════════════════════════════════════════════════════════
class RanksScreen extends ConsumerWidget {
  const RanksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: MC.bgDeep,
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Coming Soon!',
              style: MT.display(24, color: MC.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Compete with your classmates and earn rewards.',
              style: MT.body(16, color: MC.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
