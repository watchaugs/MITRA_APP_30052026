// lib/screens/student/quiz_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../models/student_models.dart';
import '../../widgets/mitra_widgets.dart';

// ── Mock quiz ─────────────────────────────────────────────────
final _mockQuiz = Quiz(
  id: 'q1', title: 'Cell Biology Quiz', topicId: 't1',
  timeLimitSeconds: 30,
  questions: [
    QuizQuestion(id: 'qq1',
      questionText: 'What is the powerhouse of the cell that generates most of the cell\'s supply of ATP?',
      options: ['Nucleus', 'Mitochondria', 'Ribosome', 'Endoplasmic Reticulum'],
      correctIndex: 1,
      explanation: 'Mitochondria produce ATP through cellular respiration.',
    ),
    QuizQuestion(id: 'qq2',
      questionText: 'Which organelle is known as the "control centre" of the cell?',
      options: ['Mitochondria', 'Golgi Apparatus', 'Nucleus', 'Lysosome'],
      correctIndex: 2,
    ),
    QuizQuestion(id: 'qq3',
      questionText: 'What is the basic unit of life?',
      options: ['Atom', 'Cell', 'Molecule', 'Tissue'],
      correctIndex: 1,
    ),
    QuizQuestion(id: 'qq4',
      questionText: 'Which part of the cell provides structure and protection?',
      options: ['Cell membrane', 'Cell wall', 'Cytoplasm', 'Nucleus'],
      correctIndex: 1,
    ),
    QuizQuestion(id: 'qq5',
      questionText: 'Chloroplasts are found only in:',
      options: ['Animal cells', 'Bacterial cells', 'Plant cells', 'Fungal cells'],
      correctIndex: 2,
    ),
  ],
);

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, this.topicId = 't1'});
  final String topicId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final _quiz         = _mockQuiz;
  int    _qIndex      = 0;
  int?   _selected;
  bool   _answered    = false;
  int    _timeLeft    = 30;
  int    _correct     = 0;
  final  _answers     = <int>[];
  Timer? _timer;
  int    _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = _quiz.timeLimitSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _timeLeft--;
        _totalSeconds++;
      });
      if (_timeLeft <= 0) _autoNext();
    });
  }

  void _autoNext() {
    if (!_answered) {
      _answers.add(-1); // timeout = wrong
      _nextQuestion();
    }
  }

  void _select(int idx) {
    if (_answered) return;
    _timer?.cancel();
    setState(() {
      _selected  = idx;
      _answered  = true;
      if (idx == _quiz.questions[_qIndex].correctIndex) _correct++;
    });
  }

  void _nextQuestion() {
    if (_answered) _answers.add(_selected ?? -1);
    if (_qIndex < _quiz.questions.length - 1) {
      setState(() {
        _qIndex++;
        _selected = null;
        _answered = false;
      });
      _startTimer();
    } else {
      _timer?.cancel();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          result: QuizResult(
            quizId:   _quiz.id,
            correct:  _correct,
            total:    _quiz.questions.length,
            xpEarned: _correct * 60,
            secondsTaken: _totalSeconds,
            badgeUnlockedId:    _correct == _quiz.questions.length ? 'b1' : null,
            badgeUnlockedTitle: _correct == _quiz.questions.length ? 'Cell Biology Expert' : null,
          ),
        ),
      ));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _quiz.questions[_qIndex];

    return Scaffold(
      backgroundColor: MC.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress bar + timer ───────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'QUESTION ${_qIndex + 1}/${_quiz.questions.length}',
                      style: MT.body(11, weight: FontWeight.w700, color: MC.textSecondary)
                          .copyWith(letterSpacing: 0.8),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color:        (_timeLeft <= 10 ? MC.crimson : MC.emerald).withValues(alpha: 0.15),
                        border:       Border.all(color: (_timeLeft <= 10 ? MC.crimson : MC.emerald).withValues(alpha: 0.4)),
                        borderRadius: BorderRadius.circular(MR.pill),
                      ),
                      child: Text('⏱ 0:${_timeLeft.toString().padLeft(2, '0')}',
                        style: MT.body(12,
                          color: _timeLeft <= 10 ? MC.crimson : MC.emerald,
                          weight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                MProgressBar(
                  value: (_qIndex + 1) / _quiz.questions.length,
                  color: MC.saffron,
                  height: 4,
                ),
              ]),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  // Topic tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color:        MC.saffron.withValues(alpha: 0.12),
                      border:       Border.all(color: MC.saffron.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(MR.pill),
                    ),
                    child: Text('🔬 Cell Biology · Chapter 3',
                      style: MT.body(11, color: MC.saffron, weight: FontWeight.w600)),
                  ),

                  const SizedBox(height: 16),

                  // Question
                  Text(q.questionText,
                    style: MT.display(17, weight: FontWeight.w700))
                      .animate(key: ValueKey(_qIndex)).fadeIn().slideY(begin: 0.1),

                  const SizedBox(height: 24),

                  // Options
                  ...List.generate(q.options.length, (i) =>
                    _OptionTile(
                      letter: String.fromCharCode(65 + i),
                      text:   q.options[i],
                      state:  _answered
                          ? (i == q.correctIndex
                              ? _OptionState.correct
                              : i == _selected
                                  ? _OptionState.wrong
                                  : _OptionState.neutral)
                          : (_selected == i
                              ? _OptionState.selected
                              : _OptionState.neutral),
                      onTap: () => _select(i),
                    ).animate(delay: (i * 60).ms).fadeIn().slideX(begin: 0.1),
                  ),

                  // Explanation
                  if (_answered && q.explanation != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color:        MC.emerald.withValues(alpha: 0.08),
                        border:       Border.all(color: MC.emerald.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(MR.sm),
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('💡', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(q.explanation!,
                          style: MT.body(13, color: MC.textSecondary))),
                      ]),
                    ).animate().fadeIn(),
                  ],

                  const SizedBox(height: 24),
                ]),
              ),
            ),

            // ── Next / Submit button ──────────────────────
            if (_answered)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: MitraButton(
                  label: _qIndex < _quiz.questions.length - 1
                      ? 'Next Question →'
                      : 'Submit Quiz',
                  onTap: _nextQuestion,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Option tile ───────────────────────────────────────────────
enum _OptionState { neutral, selected, correct, wrong }

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.letter, required this.text,
    required this.state, required this.onTap,
  });
  final String      letter, text;
  final _OptionState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (bg, border, textColor) = switch (state) {
      _OptionState.correct  => (MC.emerald.withValues(alpha: 0.15), MC.emerald, MC.emerald),
      _OptionState.wrong    => (MC.crimson.withValues(alpha: 0.15), MC.crimson, MC.crimson),
      _OptionState.selected => (MC.saffron.withValues(alpha: 0.15), MC.saffron, MC.saffron),
      _OptionState.neutral  => (MC.bgCard, MC.border, MC.textPrimary),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:        bg,
          border:       Border.all(color: border),
          borderRadius: BorderRadius.circular(MR.sm),
        ),
        child: Row(children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              shape:  BoxShape.circle,
              border: Border.all(color: textColor),
            ),
            child: Center(child: Text(letter,
              style: MT.body(13, weight: FontWeight.w700, color: textColor))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text,
            style: MT.body(14, color: textColor))),
          if (state == _OptionState.correct)
            const Text('✓', style: TextStyle(color: MC.emerald, fontSize: 18, fontWeight: FontWeight.w700)),
          if (state == _OptionState.wrong)
            const Text('✗', style: TextStyle(color: MC.crimson, fontSize: 18, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// QUIZ RESULT SCREEN
// ═════════════════════════════════════════════════════════════
class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key, required this.result});
  final QuizResult result;

  @override
  Widget build(BuildContext context) {
    final isPerfect = result.correct == result.total;

    return Scaffold(
      backgroundColor: MC.bgDeep,
      body: Stack(
        children: [
          // Confetti dots
          ...List.generate(8, (i) => Positioned(
            left:   (i * 13.0) % 100 + 10,
            top:    -20,
            child: Text(
              ['🟠', '🟡', '🟢', '🔵', '🔴', '🟣', '⭐', '💫'][i],
              style: const TextStyle(fontSize: 16),
            ).animate(delay: (i * 200).ms, onPlay: (c) => c.repeat())
              .slideY(begin: -1, end: 20, duration: 3.seconds)
              .fadeOut(delay: 2.seconds),
          )),

          // Glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [MC.saffron.withValues(alpha: 0.15), Colors.transparent],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(isPerfect ? '🏆' : '⭐',
                    style: const TextStyle(fontSize: 72))
                      .animate().scale(duration: 500.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 16),
                  Text(result.scoreLabel,
                    style: MT.display(56, weight: FontWeight.w800, color: MC.saffron))
                      .animate(delay: 200.ms).fadeIn(),

                  const SizedBox(height: 8),
                  Text(
                    '${isPerfect ? "Perfect!" : "Excellent!"} You scored '
                    '${(result.scorePct * 100).toInt()}% on Cell Biology Quiz',
                    style: MT.body(14, color: MC.textSecondary),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    _StatItem('+${result.xpEarned}', 'XP Earned', MC.gold),
                    const SizedBox(width: 32),
                    _StatItem('${result.correct}', 'Correct', MC.emerald),
                    const SizedBox(width: 32),
                    _StatItem(result.timeLabel, 'Time Taken', MC.sky),
                  ]).animate(delay: 300.ms).fadeIn(),

                  const SizedBox(height: 24),

                  // Badge unlocked
                  if (result.badgeUnlockedTitle != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:        MC.gold.withValues(alpha: 0.1),
                        border:       Border.all(color: MC.gold.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(MR.md),
                      ),
                      child: Row(children: [
                        const Text('🏅', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Badge Unlocked!',
                            style: MT.body(11, color: MC.gold, weight: FontWeight.w700)
                                .copyWith(letterSpacing: 0.5)),
                          Text(result.badgeUnlockedTitle!,
                            style: MT.display(15, weight: FontWeight.w700)),
                        ]),
                      ]),
                    ).animate(delay: 400.ms).fadeIn().scale(),

                  const SizedBox(height: 24),
                  MitraButton(
                    label: 'Continue Learning →',
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 12),
                  MitraOutlineButton(
                    label: 'Review Answers',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem(this.val, this.lbl, this.color);
  final String val, lbl;
  final Color  color;

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(val, style: MT.display(24, weight: FontWeight.w800, color: color)),
    Text(lbl, style: MT.body(12, color: MC.textMuted)),
  ]);
}
