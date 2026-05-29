// lib/screens/student/consent_screen.dart
// ════════════════════════════════════════════════════════════
// COPPA / India DPDP Act 2023 compliant consent screen.
// Students under 18 require verifiable parental consent.
// ════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme.dart';
import '../../viewmodels/app_viewmodel.dart';
import '../../utils/router.dart';
import '../../widgets/mitra_widgets.dart';

class ConsentScreen extends ConsumerStatefulWidget {
  const ConsentScreen({super.key});

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  bool _checked      = false;
  bool _loading      = false;
  bool _showParental = false;
  String _parentPhone = '';
  String _parentOtp   = '';
  bool   _otpSent     = false;
  String? _error;

  Future<void> _agree() async {
    if (!_checked) {
      setState(() => _error = 'Please tick the box above to continue');
      return;
    }
    final flags = ref.read(featureFlagsProvider);
    if (flags.isParentalConsentRequired) {
      setState(() => _showParental = true);
    } else {
      setState(() { _loading = true; _error = null; });
      await ref.read(appProvider.notifier).submitConsent();
      if (mounted) context.go(Routes.fromAuthStatus(ref.read(appProvider).authStatus));
    }
  }

  Future<void> _sendParentalOtp() async {
    if (_parentPhone.length < 10) {
      setState(() => _error = 'Enter a valid 10-digit number');
      return;
    }
    // TODO: call ref.read(apiServiceProvider).requestOtp(_parentPhone, 'parent')
    setState(() { _otpSent = true; _error = null; });
  }

  Future<void> _verifyParentalOtp() async {
    if (_parentOtp.length < 6) {
      setState(() => _error = 'Enter the 6-digit OTP');
      return;
    }
    setState(() { _loading = true; _error = null; });
    final err = await ref.read(appProvider.notifier)
        .submitParentalConsent(_parentPhone, _parentOtp);
    if (err != null) {
      setState(() { _loading = false; _error = err; });
      return;
    }
    if (mounted) context.go(Routes.fromAuthStatus(ref.read(appProvider).authStatus));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MC.bgDeep,
      appBar: AppBar(
        backgroundColor: MC.bgDeep,
        title: Text('Privacy & Consent',
          style: MT.display(16, weight: FontWeight.w700)),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _showParental ? _ParentalFlow(
            phoneVal:   _parentPhone,
            otpSent:    _otpSent,
            error:      _error,
            loading:    _loading,
            onPhone:    (v) => setState(() => _parentPhone = v),
            onOtp:      (v) => setState(() => _parentOtp   = v),
            onSend:     _sendParentalOtp,
            onVerify:   _verifyParentalOtp,
          ) : _ConsentContent(
            checked:   _checked,
            error:     _error,
            loading:   _loading,
            onCheck:   (v) => setState(() { _checked = v ?? false; _error = null; }),
            onAgree:   _agree,
            onDecline: () => ref.read(appProvider.notifier).logout(),
          ),
        ),
      ),
    );
  }
}

class _ConsentContent extends StatelessWidget {
  const _ConsentContent({
    required this.checked, required this.error, required this.loading,
    required this.onCheck, required this.onAgree, required this.onDecline,
  });
  final bool    checked, loading;
  final String? error;
  final void Function(bool?) onCheck;
  final VoidCallback onAgree, onDecline;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:        MC.bgCard,
          border:       Border.all(color: MC.border),
          borderRadius: BorderRadius.circular(MR.md),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('🔒', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 12),
          Text('Your Privacy Matters',
            style: MT.display(20, weight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(
            'MITRA is designed for students like you. Here\'s what we collect and why:',
            style: MT.body(13, color: MC.textSecondary),
          ),
          const SizedBox(height: 16),
          ...[
            ('📛', 'Name & Class',       'To personalise your learning path'),
            ('📍', 'State & School',     'To show curriculum specific to your board'),
            ('📊', 'Learning Progress',  'To remember where you left off'),
            ('🏆', 'Quiz Scores & XP',   'To show your rank on the leaderboard'),
          ].map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.$1, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.$2, style: MT.body(13, weight: FontWeight.w600)),
                Text(item.$3, style: MT.body(12, color: MC.textSecondary)),
              ])),
            ]),
          )),
          const Divider(color: MC.border, height: 24),
          Text('We NEVER sell your data. We NEVER share it with advertisers. '
            'Your data is stored securely on Indian government servers.',
            style: MT.body(12, color: MC.textSecondary)),
        ]),
      ),

      const SizedBox(height: 20),

      // Compliance notices
      _LegalRow('📜', 'Compliant with India\'s DPDP Act 2023'),
      _LegalRow('👶', 'COPPA compliant — designed for students under 18'),
      _LegalRow('🔐', 'Data stored in India — never transferred abroad'),
      _LegalRow('🗑️', 'You can request data deletion at any time'),

      const SizedBox(height: 20),

      // Checkbox
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Checkbox(
          value:       checked,
          onChanged:   onCheck,
          activeColor: MC.saffron,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: MT.body(13, color: MC.textSecondary),
              children: [
                const TextSpan(text: 'I have read and agree to the '),
                _linkSpan('Privacy Policy', 'https://mitra.gov.in/privacy'),
                const TextSpan(text: ', '),
                _linkSpan('Terms of Service', 'https://mitra.gov.in/terms'),
                const TextSpan(text: ', and '),
                _linkSpan('Child Safety Policy', 'https://mitra.gov.in/child-safety'),
                const TextSpan(text: '. I am 18+ or have parental consent.'),
              ],
            ),
          ),
        ),
      ]),

      if (error != null) ...[
        const SizedBox(height: 8),
        Text(error!, style: MT.body(12, color: MC.crimson)),
      ],

      const SizedBox(height: 24),
      MitraButton(label: 'I Agree & Continue', isLoading: loading, onTap: onAgree),
      const SizedBox(height: 12),
      MitraOutlineButton(label: 'Decline', onTap: onDecline),
    ],
  );

  TextSpan _linkSpan(String text, String url) => TextSpan(
    text: text,
    style: const TextStyle(color: MC.saffron,
        decoration: TextDecoration.underline),
    recognizer: TapGestureRecognizer()
      ..onTap = () => launchUrl(Uri.parse(url)),
  );
}

class _LegalRow extends StatelessWidget {
  const _LegalRow(this.emoji, this.text);
  final String emoji, text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 16)),
      const SizedBox(width: 10),
      Expanded(child: Text(text,
        style: MT.body(13, color: MC.textSecondary))),
    ]),
  );
}

class _ParentalFlow extends StatelessWidget {
  const _ParentalFlow({
    required this.phoneVal, required this.otpSent, required this.error,
    required this.loading, required this.onPhone, required this.onOtp,
    required this.onSend, required this.onVerify,
  });
  final String  phoneVal;
  final bool    otpSent, loading;
  final String? error;
  final void Function(String) onPhone, onOtp;
  final VoidCallback onSend, onVerify;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('👨‍👩‍👧', style: TextStyle(fontSize: 40)),
      const SizedBox(height: 12),
      Text('Parental Consent Required',
        style: MT.display(20, weight: FontWeight.w800)),
      const SizedBox(height: 8),
      Text(
        'As a student under 18, a parent or guardian must verify their phone number to complete your account setup.',
        style: MT.body(14, color: MC.textSecondary),
      ),
      const SizedBox(height: 24),
      Text("PARENT'S MOBILE NUMBER",
        style: MT.body(11, weight: FontWeight.w600, color: MC.textSecondary)
            .copyWith(letterSpacing: 0.8)),
      const SizedBox(height: 8),
      TextField(
        keyboardType: TextInputType.phone,
        maxLength: 10,
        style: MT.body(15),
        enabled: !otpSent,
        onChanged: onPhone,
        decoration: const InputDecoration(
          counterText: '', prefixText: '🇮🇳 +91  ',
          hintText: 'Parent\'s mobile number',
        ),
      ),
      if (otpSent) ...[
        const SizedBox(height: 16),
        Text('OTP SENT TO PARENT',
          style: MT.body(11, weight: FontWeight.w600, color: MC.textSecondary)
              .copyWith(letterSpacing: 0.8)),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          maxLength: 6,
          style: MT.body(15),
          onChanged: onOtp,
          decoration: const InputDecoration(counterText: '', hintText: '6-digit OTP'),
        ),
      ],
      if (error != null) ...[
        const SizedBox(height: 8),
        Text(error!, style: MT.body(12, color: MC.crimson)),
      ],
      const SizedBox(height: 24),
      MitraButton(
        label:     otpSent ? 'Verify Parental OTP →' : 'Send OTP to Parent →',
        isLoading: loading,
        onTap:     otpSent ? onVerify : onSend,
      ),
    ],
  );
}
