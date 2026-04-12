// ============================================================
// UPDATED language_screen.dart
// After selecting language → RegistrationScreen → HomeScreen
// (No separate LoginScreen needed in this flow since
//  LoginScreen would be used on subsequent app opens)
// ============================================================

import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'login_screen.dart'; // for returning users

class LanguageScreen extends StatelessWidget {
  /// Pass [savedProfile] when the user has already registered.
  /// If null, the user will be taken through Registration → Home.
  /// If set, the user will be taken through Login (camera verify) → Home.
  final Map<String, dynamic>? savedProfile;

  const LanguageScreen({super.key, this.savedProfile});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> languages = [
      {'name': 'English', 'code': 'en'},
      {'name': 'हिन्दी (Hindi)', 'code': 'hi'},
      {'name': 'தமிழ் (Tamil)', 'code': 'ta'},
      {'name': 'తెలుగు (Telugu)', 'code': 'te'},
      {'name': 'বাংলা (Bengali)', 'code': 'bn'},
      {'name': 'मराठी (Marathi)', 'code': 'mr'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Please select your preferred language",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.5,
                ),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final langCode = languages[index]['code']!;

                      if (savedProfile != null) {
                        // Returning user → Login (camera verify)
                        final profile = Map<String, dynamic>.from(savedProfile!);
                        profile['languageCode'] = langCode;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(profileData: profile),
                          ),
                        );
                      } else {
                        // New user → Registration
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegistrationScreen(languageCode: langCode),
                          ),
                        );
                      }
                    },
                    child: Text(languages[index]['name']!, style: const TextStyle(fontSize: 18)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// REQUIRED pubspec.yaml dependencies (add these):
// ============================================================
//
// dependencies:
//   flutter:
//     sdk: flutter
//   camera: ^0.11.0        # for LoginScreen camera
//   image_picker: ^1.1.2   # for registration photo upload
//
// And add to android/app/src/main/AndroidManifest.xml:
//   <uses-permission android:name="android.permission.CAMERA"/>
//
// And to ios/Runner/Info.plist:
//   <key>NSCameraUsageDescription</key>
//   <string>Used for face verification login</string>
//   <key>NSPhotoLibraryUsageDescription</key>
//   <string>Used for passport photo upload</string>
// ============================================================