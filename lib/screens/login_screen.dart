import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;
  const LoginScreen({super.key, required this.profileData});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isVerifying = false;
  bool _verified = false;

  final Map<String, Map<String, String>> translations = {
    'en': {
      'title': 'Face Verification',
      'subtitle': 'Position your face within the oval to verify your identity',
      'verify': 'Verify & Login',
      'verifying': 'Verifying...',
      'success': 'Identity Verified!',
      'tap_hint': 'Tap the button when ready',
    },
    'ta': {
      'title': 'முக சரிபார்ப்பு',
      'subtitle': 'உங்கள் அடையாளத்தை சரிபார்க்க முகத்தை கோளத்திற்குள் வைக்கவும்',
      'verify': 'சரிபார்த்து உள்நுழை',
      'verifying': 'சரிபார்க்கிறது...',
      'success': 'அடையாளம் சரிபார்க்கப்பட்டது!',
      'tap_hint': 'தயாரானதும் பொத்தானை அழுத்தவும்',
    },
    'hi': {
      'title': 'चेहरा सत्यापन',
      'subtitle': 'पहचान सत्यापित करने के लिए अपना चेहरा अंडाकार में रखें',
      'verify': 'सत्यापित करें और लॉगिन करें',
      'verifying': 'सत्यापित हो रहा है...',
      'success': 'पहचान सत्यापित हो गई!',
      'tap_hint': 'तैयार होने पर बटन दबाएं',
    },
    'te': {
      'title': 'ముఖ ధృవీకరణ',
      'subtitle': 'గుర్తింపు ధృవీకరించడానికి ముఖాన్ని అండాకారంలో ఉంచండి',
      'verify': 'ధృవీకరించి లాగిన్ అవ్వండి',
      'verifying': 'ధృవీకరిస్తోంది...',
      'success': 'గుర్తింపు ధృవీకరించబడింది!',
      'tap_hint': 'సిద్ధంగా ఉన్నప్పుడు బటన్ నొక్కండి',
    },
    'bn': {
      'title': 'মুখ যাচাইকরণ',
      'subtitle': 'পরিচয় যাচাই করতে ডিম্বাকৃতিতে মুখ রাখুন',
      'verify': 'যাচাই করুন এবং লগইন করুন',
      'verifying': 'যাচাই করা হচ্ছে...',
      'success': 'পরিচয় যাচাই হয়েছে!',
      'tap_hint': 'প্রস্তুত হলে বোতাম চাপুন',
    },
    'mr': {
      'title': 'चेहरा पडताळणी',
      'subtitle': 'ओळख पडताळण्यासाठी चेहरा अंडाकृतीत ठेवा',
      'verify': 'पडताळा आणि लॉगिन करा',
      'verifying': 'पडताळत आहे...',
      'success': 'ओळख पडताळली!',
      'tap_hint': 'तयार असल्यावर बटण दाबा',
    },
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    // prefer front camera
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _cameraController = CameraController(front, ResolutionPreset.high, enableAudio: false);
    await _cameraController!.initialize();
    if (mounted) setState(() => _isInitialized = true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _verifyAndLogin() async {
    setState(() => _isVerifying = true);
    // Simulate verification delay — always succeeds
    await Future.delayed(const Duration(seconds: 2));
    setState(() { _isVerifying = false; _verified = true; });
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(profileData: widget.profileData)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = widget.profileData['languageCode'] as String? ?? 'en';
    final lang = translations[langCode] ?? translations['en']!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview
          if (_isInitialized && _cameraController != null)
            CameraPreview(_cameraController!),

          // Dark overlay
          Container(color: Colors.black.withOpacity(0.45)),

          // UI overlay
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Text(lang['title']!,
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(lang['subtitle']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ),
                const Spacer(),

                // Oval face guide
                CustomPaint(
                  painter: _OvalOverlayPainter(verified: _verified),
                  child: SizedBox(
                    width: 230,
                    height: 280,
                    child: _verified
                        ? const Center(child: Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 80))
                        : null,
                  ),
                ),

                const Spacer(),

                // Hint text
                Text(lang['tap_hint']!, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                const SizedBox(height: 20),

                // Verify button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _verified ? Colors.greenAccent : Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _isVerifying || _verified ? null : _verifyAndLogin,
                      icon: _isVerifying
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.face_unlock_rounded),
                      label: Text(
                        _isVerifying ? lang['verifying']! : _verified ? lang['success']! : lang['verify']!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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