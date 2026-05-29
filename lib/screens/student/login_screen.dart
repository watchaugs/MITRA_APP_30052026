// lib/screens/student/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../../viewmodels/app_viewmodel.dart';
import '../../utils/router.dart';
import '../../widgets/mitra_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String  _role     = 'student';
  String  _phone    = '';
  String  _otp      = '';
  bool    _otpSent  = false;
  bool    _loading  = false;
  String? _error;
  int     _resendCountdown = 0;

  final _phoneCtrl = TextEditingController();
  final _otpCtrl   = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_phone.length < 10) {
      setState(() => _error = 'Enter a valid 10-digit mobile number');
      return;
    }
    setState(() { _loading = true; _error = null; });
    final err = await ref.read(appProvider.notifier).requestOtp(_phone, _role);
    setState(() { _loading = false; });
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    setState(() { _otpSent = true; _resendCountdown = 30; });
    _startCountdown();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendCountdown--);
      return _resendCountdown > 0;
    });
  }

  Future<void> _verifyOtp() async {
    if (_otp.length < 6) {
      setState(() => _error = 'Enter the 6-digit OTP');
      return;
    }
    setState(() { _loading = true; _error = null; });
    final err = await ref.read(appProvider.notifier).verifyOtp(
      phone: _phone, otp: _otp, role: _role,
    );
    setState(() { _loading = false; });
    if (err != null) { setState(() => _error = err); return; }
    final status = ref.read(appProvider).authStatus;
    if (mounted) context.go(Routes.fromAuthStatus(status));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MC.bgDeep,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top art panel (maps to .login-top-art)
              _TopArt(),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Namaste! 🙏',
                      style: MT.display(24, weight: FontWeight.w800))
                        .animate().fadeIn().slideY(begin: 0.2),
                    const SizedBox(height: 4),
                    Text('Sign in to continue learning',
                      style: MT.body(14, color: MC.textSecondary))
                        .animate(delay: 50.ms).fadeIn(),

                    const SizedBox(height: 24),

                    // Role selector
                    Text('I am a',
                      style: MT.body(12, weight: FontWeight.w600, color: MC.textSecondary)
                          .copyWith(letterSpacing: 0.5)),
                    const SizedBox(height: 8),
                    _RoleSelector(
                      selected: _role,
                      onChanged: (r) => setState(() => _role = r),
                    ),

                    const SizedBox(height: 20),

                    // Phone field
                    Text('MOBILE NUMBER',
                      style: MT.body(11, weight: FontWeight.w600, color: MC.textSecondary)
                          .copyWith(letterSpacing: 0.8)),
                    const SizedBox(height: 8),
                    TextField(
                      controller:   _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      maxLength:    10,
                      enabled:      !_otpSent,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style:        MT.body(16, weight: FontWeight.w700),
                      onChanged:    (v) => setState(() => _phone = v),
                      decoration: InputDecoration(
                        counterText: '',
                        prefixText:  '🇮🇳 +91  ',
                        prefixStyle: MT.body(14),
                        hintText:    '98765 43210',
                        hintStyle:   MT.body(14, color: MC.textMuted),
                      ),
                    ),

                    if (_otpSent) ...[
                      const SizedBox(height: 20),
                      Text('ENTER OTP',
                        style: MT.body(11, weight: FontWeight.w600, color: MC.textSecondary)
                            .copyWith(letterSpacing: 0.8)),
                      const SizedBox(height: 8),
                      _OtpBoxes(
                        onCompleted: (otp) {
                          setState(() => _otp = otp);
                          _verifyOtp();
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        const Text('💬 ', style: TextStyle(fontSize: 14)),
                        Text('OTP sent via WhatsApp to +91 ${_phone.replaceRange(2, 8, 'XXXXX')}',
                          style: MT.body(12, color: MC.textMuted)),
                      ]),
                    ],

                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:        MC.crimson.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(MR.xs),
                          border:       Border.all(color: MC.crimson.withValues(alpha: 0.3)),
                        ),
                        child: Text(_error!,
                          style: MT.body(13, color: MC.crimson)),
                      ),
                    ],

                    const SizedBox(height: 24),

                    MitraButton(
                      label:     _otpSent ? 'Verify & Login →' : 'Send OTP →',
                      isLoading: _loading,
                      onTap:     _otpSent ? _verifyOtp : _sendOtp,
                    ),

                    if (_otpSent) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: GestureDetector(
                          onTap: _resendCountdown == 0 ? _sendOtp : null,
                          child: Text(
                            _resendCountdown > 0
                                ? 'Resend in ${_resendCountdown}s'
                                : 'Resend OTP',
                            style: MT.body(13,
                              color: _resendCountdown > 0
                                  ? MC.textMuted : MC.saffron),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'NCERT-Aligned · 12 Indian Languages · 28 States',
                        style: MT.body(11, color: MC.textMuted),
                        textAlign: TextAlign.center,
                      ),
                    ),
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

class _TopArt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width:  double.infinity,
      decoration: const BoxDecoration(gradient: MG.hero),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: CustomPaint(painter: _DotPainter())),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  gradient:     MG.saffron,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: MC.saffron.withValues(alpha: 0.5),
                        blurRadius: 24, offset: const Offset(0, 6)),
                  ],
                ),
                child: const Center(child: Text('🎓', style: TextStyle(fontSize: 32))),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: MT.display(26, weight: FontWeight.w800),
                  children: const [
                    TextSpan(text: 'MIT'),
                    TextSpan(text: 'RA',
                      style: TextStyle(color: MC.saffron)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = MC.saffron.withValues(alpha: 0.06);
    for (double x = 0; x < s.width; x += 16) {
      for (double y = 0; y < s.height; y += 16) {
        c.drawCircle(Offset(x, y), 1, p);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({required this.selected, required this.onChanged});
  final String selected;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _RoleBtn(label: 'Student', emoji: '🎒', value: 'student',
          selected: selected == 'student', onTap: () => onChanged('student')),
      const SizedBox(width: 12),
      _RoleBtn(label: 'Teacher', emoji: '👩‍🏫', value: 'teacher',
          selected: selected == 'teacher', onTap: () => onChanged('teacher')),
    ]);
  }
}

class _RoleBtn extends StatelessWidget {
  const _RoleBtn({
    required this.label, required this.emoji, required this.value,
    required this.selected, required this.onTap,
  });
  final String label, emoji, value;
  final bool   selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color:        selected ? MC.saffron.withValues(alpha: 0.15) : MC.bgSurface,
        border:       Border.all(
          color: selected ? MC.saffron : MC.border,
          width: selected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(MR.sm),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(label, style: MT.body(14,
          weight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? MC.saffron : MC.textSecondary)),
      ]),
    ),
  );
}

class _OtpBoxes extends StatefulWidget {
  const _OtpBoxes({required this.onCompleted});
  final void Function(String) onCompleted;

  @override
  State<_OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<_OtpBoxes> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focuses     = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focuses) f.dispose();
    super.dispose();
  }

  void _onChanged(int i, String val) {
    if (val.length == 1 && i < 5) _focuses[i + 1].requestFocus();
    if (val.isEmpty && i > 0) _focuses[i - 1].requestFocus();
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) widget.onCompleted(otp);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) => SizedBox(
        width: 44, height: 52,
        child: TextField(
          controller:   _controllers[i],
          focusNode:    _focuses[i],
          textAlign:    TextAlign.center,
          maxLength:    1,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: MT.display(20, weight: FontWeight.w700),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (v) => _onChanged(i, v),
        ),
      )),
    );
  }
}
