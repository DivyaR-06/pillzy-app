import 'package:flutter/material.dart';
import 'registration_screen.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(
                            languageCode: languages[index]['code']!,
                          ),
                        ),
                      );
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