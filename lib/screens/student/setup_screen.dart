// lib/screens/student/setup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../../models/student_models.dart';
import '../../viewmodels/app_viewmodel.dart';
import '../../widgets/mitra_widgets.dart';
import '../../utils/router.dart';
import '../../services/permissions_service.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  int     _step       = 0; // 0: State Selection, 1: Profile Details
  bool    _loading    = false;
  bool    _detecting  = false;
  String? _error;

  String? _stateCode;
  String? _stateName;

  final   _nameCtrl   = TextEditingController();
  final   _schoolCtrl = TextEditingController();
  String  _avatar     = '👦';
  int     _classGrade = 9;

  Future<void> _autoDetectState() async {
    setState(() { _detecting = true; _error = null; });
    try {
      final pos = await PermissionsService.getLocationForStateDetection();
      if (pos == null) {
        setState(() { _detecting = false; _error = 'Could not detect location. Please select manually.'; });
        return;
      }
      final code = GeoStateDetector.detectStateFromLatLng(pos.latitude, pos.longitude);
      if (code == null) {
        setState(() { _detecting = false; _error = 'Location detected, but we couldn\'t map it to a state.'; });
        return;
      }
      final state = kIndianStates.firstWhere((s) => s.code == code);
      setState(() {
        _stateCode = state.code;
        _stateName = state.name;
        _detecting = false;
      });
      ref.read(appProvider.notifier).selectState(state.code);
    } catch (e) {
      setState(() { _detecting = false; _error = 'An error occurred during detection.'; });
    }
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your name');
      return;
    }
    if (_stateCode == null) {
      setState(() => _error = 'Please select your state first');
      return;
    }
    if (_schoolCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your school name');
      return;
    }
    setState(() { _loading = true; _error = null; });
    final err = await ref.read(appProvider.notifier).setupProfile(
      name:        _nameCtrl.text.trim(),
      avatar:      _avatar,
      classGrade:  _classGrade,
      stateCode:   _stateCode!,
      schoolName:  _schoolCtrl.text.trim(),
    );
    if (err != null) {
      setState(() { _loading = false; _error = err; });
      return;
    }
    if (mounted) context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MC.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // Step indicator
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(children: [
                _StepDot(active: _step == 0, done: _step > 0, label: '1'),
                Expanded(child: Divider(
                    color: _step > 0 ? MC.saffron : MC.border)),
                _StepDot(active: _step == 1, done: false, label: '2'),
              ]),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _step == 0
                    ? _StateStep(
                  selectedCode: _stateCode,
                  selectedName: _stateName,
                  detecting:   _detecting,
                  error:       _error,
                  onDetect:    _autoDetectState,
                  onSelect:    (code, name) {
                    setState(() { _stateCode = code; _stateName = name; _error = null; });
                    ref.read(appProvider.notifier).selectState(code);
                  },
                  onNext: () {
                    if (_stateCode == null) {
                      setState(() => _error = 'Please select your state');
                    } else {
                      setState(() { _step = 1; _error = null; });
                    }
                  },
                )
                    : _ProfileStep(
                  nameController: _nameCtrl,
                  schoolController: _schoolCtrl,
                  avatar:      _avatar,
                  classGrade:  _classGrade,
                  loading:     _loading,
                  error:       _error,
                  onAvatarChanged: (a) => setState(() => _avatar = a),
                  onClassChanged:  (c) => setState(() => _classGrade = c),
                  onBack:  () => setState(() => _step = 0),
                  onSubmit: _submit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.active, required this.done, required this.label});
  final bool active, done;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color:        done ? MC.saffron : (active ? MC.saffron.withValues(alpha: 0.2) : Colors.transparent),
        shape:        BoxShape.circle,
        border:       Border.all(color: done || active ? MC.saffron : MC.border, width: 2),
      ),
      child: Center(
        child: done
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(label, style: MT.body(12, weight: FontWeight.w700,
            color: active ? MC.saffron : MC.textMuted)),
      ),
    );
  }
}

class _StateStep extends StatelessWidget {
  const _StateStep({
    required this.selectedCode, required this.selectedName,
    required this.detecting, required this.onDetect,
    required this.onSelect, required this.onNext,
    this.error,
  });

  final String? selectedCode, selectedName;
  final bool    detecting;
  final VoidCallback onDetect, onNext;
  final void Function(String, String) onSelect;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text('Select Your State', style: MT.display(24, weight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(
          'We\'ll show content specific to your state curriculum and language.',
          style: MT.body(15, color: MC.textSecondary),
        ),
        const SizedBox(height: 32),

        // Auto detect
        GestureDetector(
          onTap: detecting ? null : onDetect,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:        MC.bgCard,
              borderRadius: BorderRadius.circular(MR.md),
              border:       Border.all(color: MC.border),
            ),
            child: Row(children: [
              const Text('📍', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 16),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Auto-detect my location', style: MT.body(15, weight: FontWeight.w600)),
                  Text('Faster setup using GPS', style: MT.body(13, color: MC.textMuted)),
                ],
              )),
              if (detecting)
                const SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: MC.saffron))
              else
                const Icon(Icons.chevron_right, color: MC.textMuted),
            ]),
          ),
        ),

        const SizedBox(height: 24),
        Row(children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('OR SELECT MANUALLY', style: MT.body(10, weight: FontWeight.w700, color: MC.textMuted)),
          ),
          const Expanded(child: Divider()),
        ]),
        const SizedBox(height: 24),

        // Manual select list (simulated with a Grid)
        GridView.builder(
          shrinkWrap: true,
          physics:    const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
            childAspectRatio: 2.5,
          ),
          itemCount:   kIndianStates.length,
          itemBuilder: (_, i) {
            final s = kIndianStates[i];
            final sel = s.code == selectedCode;
            return GestureDetector(
              onTap: () => onSelect(s.code, s.name),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color:        sel ? MC.saffron.withValues(alpha: 0.1) : MC.bgCard,
                  borderRadius: BorderRadius.circular(MR.sm),
                  border:       Border.all(color: sel ? MC.saffron : MC.border, width: sel ? 1.5 : 1),
                ),
                child: Row(children: [
                  Text(s.flag, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(s.name, style: MT.body(12,
                      weight: sel ? FontWeight.w600 : FontWeight.w400,
                      color:  sel ? MC.saffron : MC.textPrimary),
                      maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]),
              ),
            );
          },
        ),

        if (error != null) ...[
          const SizedBox(height: 16),
          Text(error!, style: MT.body(13, color: MC.crimson)),
        ],

        const SizedBox(height: 32),
        MitraButton(label: 'Continue →', onTap: onNext),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _ProfileStep extends StatelessWidget {
  const _ProfileStep({
    required this.nameController, required this.schoolController,
    required this.avatar, required this.classGrade,
    required this.onAvatarChanged, required this.onClassChanged,
    required this.onBack, required this.onSubmit,
    required this.loading, this.error,
  });

  final TextEditingController nameController, schoolController;
  final String avatar;
  final int    classGrade;
  final bool   loading;
  final String? error;
  final void Function(String) onAvatarChanged;
  final void Function(int)    onClassChanged;
  final VoidCallback onBack, onSubmit;

  static const _avatars = ['👦', '👧', '🧑', '👨', '👩', '🦸', '🦹', '🦊', '🦁', '🐯', '🐼', '🦄'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: MC.textSecondary, size: 20),
          onPressed: onBack,
        ),
        const SizedBox(height: 10),
        Text('Almost There!', style: MT.display(24, weight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('Tell us a bit about yourself to personalize your learning.',
            style: MT.body(15, color: MC.textSecondary)),
        const SizedBox(height: 32),

        // Avatar picker
        Center(
          child: Column(children: [
            Text('Choose Your Avatar', style: MT.body(14, weight: FontWeight.w600)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12, runSpacing: 12, alignment: WrapAlignment.center,
              children: _avatars.map((a) {
                final sel = a == avatar;
                return GestureDetector(
                  onTap: () => onAvatarChanged(a),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color:        sel ? MC.saffron.withValues(alpha: 0.15) : MC.bgCard,
                      shape:        BoxShape.circle,
                      border:       Border.all(color: sel ? MC.saffron : MC.border, width: sel ? 2 : 1),
                    ),
                    child: Center(child: Text(a, style: const TextStyle(fontSize: 28))),
                  ),
                );
              }).toList(),
            ),
          ]),
        ),

        const SizedBox(height: 32),
        Text('Your Name', style: MT.body(14, weight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Enter your full name'),
        ),

        const SizedBox(height: 24),
        Text('Your Class', style: MT.body(14, weight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            final grade = i + 6;
            final sel = grade == classGrade;
            return GestureDetector(
              onTap: () => onClassChanged(grade),
              child: Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color:        sel ? MC.saffron : MC.bgCard,
                  borderRadius: BorderRadius.circular(8),
                  border:       Border.all(color: sel ? MC.saffron : MC.border),
                ),
                child: Center(child: Text('$grade', style: MT.body(14,
                    weight: FontWeight.w700, color: sel ? Colors.white : MC.textPrimary))),
              ),
            );
          }),
        ),

        const SizedBox(height: 24),
        Text('School Name', style: MT.body(14, weight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: schoolController,
          decoration: const InputDecoration(hintText: 'Enter school name'),
        ),

        if (error != null) ...[
          const SizedBox(height: 20),
          Text(error!, style: MT.body(13, color: MC.crimson)),
        ],

        const SizedBox(height: 40),
        MitraButton(
          label:     'Finish Setup →',
          onTap:     onSubmit,
          isLoading: loading,
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}