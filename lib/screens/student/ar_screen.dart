// lib/screens/student/ar_screen.dart
// cSpell:ignore riverpod viewmodels NCERT
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme.dart';
import '../../services/permissions_service.dart';
import '../../viewmodels/app_viewmodel.dart';
import '../../widgets/mitra_widgets.dart';

class ArScreen extends ConsumerStatefulWidget {
  const ArScreen({super.key, this.topicName = 'Microscopy & Cell Structure'});
  final String topicName;

  @override
  ConsumerState<ArScreen> createState() => _ArScreenState();
}

class _ArScreenState extends ConsumerState<ArScreen>
    with TickerProviderStateMixin {
  bool _hasPermission = false;
  bool _checking      = true;
  bool _scanning      = false;
  bool _modelLoaded   = false;
  bool _rotateOn      = true;
  bool _labelsOn      = true;
  bool _soundOn       = true;

  late AnimationController _scanAnim;
  late AnimationController _pulseAnim;

  @override
  void initState() {
    super.initState();
    _scanAnim  = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _pulseAnim = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final has = await PermissionsService.hasCameraPermission();
    if (mounted) setState(() { _hasPermission = has; _checking = false; });
    if (has) _startScan();
  }

  Future<void> _requestPermission() async {
    final status = await PermissionsService.requestCamera();
    final granted = status.isGranted;
    if (mounted) setState(() => _hasPermission = granted);
    if (granted) _startScan();
  }

  Future<void> _startScan() async {
    if (mounted) setState(() { _scanning = true; _modelLoaded = false; });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() { _modelLoaded = true; _scanning = false; });
  }

  @override
  void dispose() {
    _scanAnim.dispose();
    _pulseAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flags = ref.watch(featureFlagsProvider);
    if (!flags.isArEnabled) return const _FeatureDisabledView();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _checking
            ? const _LoadingView()
            : !_hasPermission
            ? _PermissionView(onRequest: _requestPermission)
            : _ArView(
          topicName:   widget.topicName,
          scanAnim:    _scanAnim,
          pulseAnim:   _pulseAnim,
          scanning:    _scanning,
          modelLoaded: _modelLoaded,
          rotateOn:    _rotateOn,
          labelsOn:    _labelsOn,
          soundOn:     _soundOn,
          onRotate:    () => setState(() => _rotateOn = !_rotateOn),
          onLabels:    () => setState(() => _labelsOn = !_labelsOn),
          onSound:     () => setState(() => _soundOn  = !_soundOn),
          onSnap:      () => _showSnapConfirm(context),
          onQuiz:      () => Navigator.pushNamed(context, '/quiz'),
          onBack:      () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showSnapConfirm(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📸 Screenshot saved to gallery!',
            style: MT.body(13)),
        backgroundColor: MC.bgCard,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ── Camera permission gate ────────────────────────────────────
class _PermissionView extends StatelessWidget {
  const _PermissionView({required this.onRequest});
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      color:   MC.bgDeep,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color:        MC.saffron.withValues(alpha: 0.1),
              shape:        BoxShape.circle,
              border:       Border.all(color: MC.saffron.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.camera_alt_rounded,
                color: MC.saffron, size: 36),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

          const SizedBox(height: 20),
          Text('Camera Access Needed',
              style: MT.display(20, weight: FontWeight.w800),
              textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
            'MITRA needs your camera to overlay 3D models onto your '
                'textbook pages. We only use the camera when you open AR.',
            style: MT.body(14, color: MC.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:        MC.emerald.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(MR.xs),
            ),
            child: Text(
              '🔒 Camera is used ONLY while you are viewing AR content. '
                  'We never record or upload your camera feed.',
              style: MT.body(12, color: MC.emerald),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 28),
          MitraButton(
            label:    '🎥 Allow Camera Access',
            gradient: MG.emerald,
            onTap:    onRequest,
          ),
        ],
      ),
    );
  }
}

// ── Main AR View ──────────────────────────────────────────────
class _ArView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ArView({
    required this.topicName, required this.scanAnim,
    required this.pulseAnim, required this.scanning,
    required this.modelLoaded, required this.rotateOn,
    required this.labelsOn, required this.soundOn,
    required this.onRotate, required this.onLabels,
    required this.onSound, required this.onSnap,
    required this.onQuiz, required this.onBack,
  });

  final String   topicName;
  final Animation<double> scanAnim, pulseAnim;
  final bool     scanning, modelLoaded, rotateOn, labelsOn, soundOn;
  final VoidCallback onRotate, onLabels, onSound, onSnap, onQuiz, onBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Camera preview simulation
        Container(
          color:  const Color(0xFF050810),
          child:  Center(
            child: Text('📷', style: TextStyle(fontSize: 100, color: Colors.white.withValues(alpha: 0.08))),
          ),
        ),

        // Scanning frame / AR overlay
        Center(
          child: scanning
              ? _ScanFrame(anim: scanAnim)
              : _ModelOverlay(pulseAnim: pulseAnim, labelsOn: labelsOn),
        ),

        // Top bar
        Positioned(
          top: 0, left: 0, right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
              ),
            ),
            child: Row(children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color:        Colors.black.withValues(alpha: 0.4),
                    shape:        BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color:        MC.saffron.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(MR.pill),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      AnimatedBuilder(
                        animation: pulseAnim,
                        builder: (_, __) => Container(
                          width: 5, height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(
                              alpha: scanning
                                  ? 0.9
                                  : (0.6 + 0.4 * pulseAnim.value),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        scanning ? 'AR SCANNING' : 'AR ACTIVE',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10,
                            fontWeight: FontWeight.w700, letterSpacing: 0.8),
                      ),
                    ]),
                  ),
                  Text(topicName,
                      style: const TextStyle(color: Colors.white,
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              )),
            ]),
          ),
        ),

        // Right control column
        Positioned(
          right: 12, top: 0, bottom: 0,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _ArControl(icon: '🔄', label: 'Rotate', active: rotateOn, onTap: onRotate),
            const SizedBox(height: 10),
            _ArControl(icon: '🔍', label: 'Zoom',   active: true,     onTap: () {}),
            const SizedBox(height: 10),
            _ArControl(icon: '🏷️', label: 'Labels', active: labelsOn, onTap: onLabels),
            const SizedBox(height: 10),
            _ArControl(icon: '📸', label: 'Snap',   active: true,     onTap: onSnap),
            const SizedBox(height: 10),
            _ArControl(icon: '🔊', label: 'Sound',  active: soundOn,  onTap: onSound),
          ]),
        ),

        // Bottom quiz CTA
        if (modelLoaded)
          Positioned(
            bottom: 16, left: 16, right: 16,
            child: GestureDetector(
              onTap: onQuiz,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient:     MG.saffron,
                  borderRadius: BorderRadius.circular(MR.sm),
                  boxShadow: [BoxShadow(color: MC.saffron.withValues(alpha: 0.4),
                      blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('📝', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text('Take Quiz on This Topic',
                      style: MT.body(14, weight: FontWeight.w600, color: Colors.white)),
                  const Spacer(),
                  const XpChip(120),
                ]),
              ),
            ).animate().slideY(begin: 1, curve: Curves.easeOut),
          ),

        // Scanning hint
        if (scanning)
          Positioned(
            bottom: 80, left: 0, right: 0,
            child: Text(
              'Point camera at your NCERT textbook page',
              style: MT.body(13, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

class _ScanFrame extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ScanFrame({required this.anim});
  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240, height: 300,
      child: Stack(children: [
        // Dashed border corners
        ...[Alignment.topLeft, Alignment.topRight,
          Alignment.bottomLeft, Alignment.bottomRight].map((a) =>
            Align(
              alignment: a,
              child: Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  border: Border(
                    top:    a.y < 0 ? const BorderSide(color: MC.saffron, width: 3) : BorderSide.none,
                    bottom: a.y > 0 ? const BorderSide(color: MC.saffron, width: 3) : BorderSide.none,
                    left:   a.x < 0 ? const BorderSide(color: MC.saffron, width: 3) : BorderSide.none,
                    right:  a.x > 0 ? const BorderSide(color: MC.saffron, width: 3) : BorderSide.none,
                  ),
                ),
              ),
            ),
        ),
        // Scan line
        AnimatedBuilder(
          animation: anim,
          builder: (_, __) => Positioned(
            top:  300 * anim.value - 1,
            left: 0, right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, MC.saffron, Colors.transparent],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _ModelOverlay extends StatelessWidget {
  const _ModelOverlay({required this.pulseAnim, required this.labelsOn});
  final Animation<double> pulseAnim;
  final bool labelsOn;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnim,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        children: [
          // Glow ring
          Container(
            width:  200 + 10 * pulseAnim.value,
            height: 200 + 10 * pulseAnim.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: MC.saffron.withValues(alpha: 0.15 + 0.1 * pulseAnim.value),
                width: 2,
              ),
            ),
          ),
          // 3D model placeholder
          Container(
            width: 160, height: 160,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: const Center(
              child: Text('🔬', style: TextStyle(fontSize: 80)),
            ),
          ),
          // Labels
          if (labelsOn) ...[
            const Positioned(
              top: 10, left: -20,
              child: _Label('Nucleus', MC.indigoLt),
            ),
            const Positioned(
              bottom: 20, right: -30,
              child: _Label('Mitochondria', MC.emerald),
            ),
            const Positioned(
              top: 60, right: -40,
              child: _Label('Cell Wall', MC.saffron),
            ),
          ],
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text, this.color);
  final String text;
  final Color  color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color:        color.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(MR.xs),
    ),
    child: Text(text,
        style: MT.body(10, weight: FontWeight.w600, color: Colors.white)),
  );
}

class _ArControl extends StatelessWidget {
  const _ArControl({required this.icon, required this.label, required this.active, required this.onTap});
  final String icon, label;
  final bool   active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 52, height: 52,
      decoration: BoxDecoration(
        color:        Colors.black.withValues(alpha: active ? 0.55 : 0.3),
        shape:        BoxShape.circle,
        border:       Border.all(color: active ? MC.saffron.withValues(alpha: 0.5) : Colors.white12),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        Text(label,
            style: TextStyle(fontSize: 8, color: active ? MC.saffron : Colors.white38,
                fontWeight: FontWeight.w600)),
      ]),
    ),
  );
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(color: MC.saffron),
  );
}

class _FeatureDisabledView extends StatelessWidget {
  const _FeatureDisabledView();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: MC.bgDeep,
    body: Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('🥽', style: TextStyle(fontSize: 56)),
        const SizedBox(height: 16),
        Text('AR Not Available',
            style: MT.display(20, weight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('AR features are not enabled for your state yet.',
            style: MT.body(14, color: MC.textSecondary),
            textAlign: TextAlign.center),
      ]),
    ),
  );
}
