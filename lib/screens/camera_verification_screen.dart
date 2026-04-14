import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home_screen.dart';

/// A dedicated camera face-verification step.
/// Receives [profileData] from either LoginScreen or RegistrationScreen.
/// On success → navigates to HomeScreen.
/// On back → pops to caller.
class CameraVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;
  const CameraVerificationScreen({super.key, required this.profileData});

  @override
  State<CameraVerificationScreen> createState() =>
      _CameraVerificationScreenState();
}

class _CameraVerificationScreenState extends State<CameraVerificationScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isVerifying = false;
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController =
          CameraController(front, ResolutionPreset.high, enableAudio: false);
      await _cameraController!.initialize();
      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera access denied or unavailable')),
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _verifyAndProceed() async {
    setState(() => _isVerifying = true);
    // Simulate verification delay — always succeeds for now
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isVerifying = false;
      _verified = true;
    });
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(profileData: widget.profileData),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ── Camera preview ────────────────────────────────────────────
            if (_isInitialized && _cameraController != null)
              CameraPreview(_cameraController!),

            // ── Dark overlay ──────────────────────────────────────────────
            Container(color: Colors.black.withOpacity(0.45)),

            // ── UI overlay ────────────────────────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Face Verification',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Position your face within the oval to verify your identity',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // ── Oval face guide ───────────────────────────────────
                  CustomPaint(
                    painter: _OvalOverlayPainter(verified: _verified),
                    child: SizedBox(
                      width: 230,
                      height: 280,
                      child: _verified
                          ? const Center(
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: Colors.greenAccent,
                                size: 80,
                              ),
                            )
                          : null,
                    ),
                  ),

                  const Spacer(),

                  // Hint text
                  const Text(
                    'Tap the button when ready',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  // ── Verify button ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _verified ? Colors.greenAccent : Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 3,
                          shadowColor: Colors.teal.withOpacity(0.5),
                        ),
                        onPressed:
                            _isVerifying || _verified ? null : _verifyAndProceed,
                        icon: _isVerifying
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.face_unlock_rounded, size: 22),
                        label: Text(
                          _isVerifying
                              ? 'Verifying...'
                              : _verified
                                  ? 'Identity Verified!'
                                  : 'Verify & Continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Oval face-guide painter ────────────────────────────────────────────────────
class _OvalOverlayPainter extends CustomPainter {
  final bool verified;
  _OvalOverlayPainter({this.verified = false});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );
    final paint = Paint()
      ..color = verified ? Colors.greenAccent : Colors.tealAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(_OvalOverlayPainter old) => old.verified != verified;
}
