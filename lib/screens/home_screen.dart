import 'package:flutter/material.dart';
import 'dart:io';
import 'profile_screen.dart';
import 'medicine_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;
  const HomeScreen({super.key, required this.profileData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _medicines = [];

  // ✅ await and context live here — inside an async method of a State class
  Future<void> _openMedicineScreen() async {
    final langCode = widget.profileData['languageCode'] as String? ?? 'en';
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicineDetailsScreen(languageCode: langCode),
      ),
    );
    if (result != null) {
      setState(() => _medicines.add(Map<String, dynamic>.from(result)));
    }
  }

  final Map<String, Map<String, String>> translations = {
    'en': {
      'home': 'Home', 'profile': 'Profile', 'progress': 'Progress', 'shop': 'Shop',
      'welcome': 'Welcome back',
      'upcoming': 'My Medications', 'no_meds': 'No medications added yet.',
      'next_dose': 'Next dose',
      'progress_title': 'Your Progress',
      'progress_sub': 'Track your medication adherence here.',
      'shop_title': 'Med Shop',
      'shop_sub': 'Browse and order medications.',
      'add_med': 'Add Medicine',
    },
    'ta': {
      'home': 'முகப்பு', 'profile': 'சுயவிவரம்', 'progress': 'முன்னேற்றம்', 'shop': 'கடை',
      'welcome': 'மீண்டும் வரவேற்கிறோம்',
      'upcoming': 'என் மருந்துகள்', 'no_meds': 'மருந்துகள் எதுவும் சேர்க்கப்படவில்லை.',
      'next_dose': 'அடுத்த டோஸ்',
      'progress_title': 'உங்கள் முன்னேற்றம்',
      'progress_sub': 'இங்கே உங்கள் மருந்து இணக்கத்தை கண்காணிக்கவும்.',
      'shop_title': 'மருந்து கடை',
      'shop_sub': 'மருந்துகளை உலாவி ஆர்டர் செய்யுங்கள்.',
      'add_med': 'மருந்து சேர்',
    },
    'hi': {
      'home': 'होम', 'profile': 'प्रोफ़ाइल', 'progress': 'प्रगति', 'shop': 'शॉप',
      'welcome': 'वापस स्वागत है',
      'upcoming': 'मेरी दवाइयाँ', 'no_meds': 'कोई दवा नहीं जोड़ी गई।',
      'next_dose': 'अगली खुराक',
      'progress_title': 'आपकी प्रगति',
      'progress_sub': 'यहाँ अपनी दवाई अनुपालन ट्रैक करें।',
      'shop_title': 'मेड शॉप',
      'shop_sub': 'दवाइयाँ ब्राउज़ करें और ऑर्डर करें।',
      'add_med': 'दवा जोड़ें',
    },
    'te': {
      'home': 'హోమ్', 'profile': 'ప్రొఫైల్', 'progress': 'పురోగతి', 'shop': 'షాప్',
      'welcome': 'మళ్ళీ స్వాగతం',
      'upcoming': 'నా మందులు', 'no_meds': 'మందులు ఏవీ జోడించబడలేదు.',
      'next_dose': 'తదుపరి మోతాదు',
      'progress_title': 'మీ పురోగతి',
      'progress_sub': 'ఇక్కడ మీ మందుల అనుపాలనను ట్రాక్ చేయండి.',
      'shop_title': 'మెడ్ షాప్',
      'shop_sub': 'మందులను బ్రౌజ్ చేసి ఆర్డర్ చేయండి.',
      'add_med': 'మందు జోడించు',
    },
    'bn': {
      'home': 'হোম', 'profile': 'প্রোফাইল', 'progress': 'অগ্রগতি', 'shop': 'শপ',
      'welcome': 'আবার স্বাগতম',
      'upcoming': 'আমার ওষুধ', 'no_meds': 'কোনো ওষুধ যোগ করা হয়নি।',
      'next_dose': 'পরবর্তী ডোজ',
      'progress_title': 'আপনার অগ্রগতি',
      'progress_sub': 'এখানে ওষুধ মেনে চলার অগ্রগতি ট্র্যাক করুন।',
      'shop_title': 'মেড শপ',
      'shop_sub': 'ওষুধ ব্রাউজ করুন এবং অর্ডার করুন।',
      'add_med': 'ওষুধ যোগ করুন',
    },
    'mr': {
      'home': 'होम', 'profile': 'प्रोफाइल', 'progress': 'प्रगती', 'shop': 'शॉप',
      'welcome': 'पुन्हा स्वागत',
      'upcoming': 'माझी औषधे', 'no_meds': 'कोणतीही औषधे जोडली नाहीत.',
      'next_dose': 'पुढील डोस',
      'progress_title': 'तुमची प्रगती',
      'progress_sub': 'येथे तुमच्या औषध अनुपालनाचा मागोवा घ्या.',
      'shop_title': 'मेड शॉप',
      'shop_sub': 'औषधे ब्राउझ करा आणि ऑर्डर करा.',
      'add_med': 'औषध जोडा',
    },
  };

  @override
  Widget build(BuildContext context) {
    final langCode = widget.profileData['languageCode'] as String? ?? 'en';
    final lang = translations[langCode] ?? translations['en']!;
    final name = (widget.profileData['name'] as String?)?.trim() ?? '';

    final pages = [
      _HomeTab(
        lang: lang,
        profileData: widget.profileData,
        medicines: _medicines,
        onAddMedicine: _openMedicineScreen,
      ),
      ProfileScreen(profileData: widget.profileData),
      _SimpleTab(icon: Icons.bar_chart_rounded, title: lang['progress_title']!, subtitle: lang['progress_sub']!),
      _SimpleTab(icon: Icons.local_pharmacy_rounded, title: lang['shop_title']!, subtitle: lang['shop_sub']!),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Pillzy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          if (name.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => _selectedIndex = 1),
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    const Icon(Icons.person_rounded, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      name.split(' ').first,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_rounded), label: lang['home']!),
          NavigationDestination(icon: const Icon(Icons.person_rounded), label: lang['profile']!),
          NavigationDestination(icon: const Icon(Icons.bar_chart_rounded), label: lang['progress']!),
          NavigationDestination(icon: const Icon(Icons.local_pharmacy_rounded), label: lang['shop']!),
        ],
      ),
    );
  }
}

// ── HOME TAB ──────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final Map<String, String> lang;
  final Map<String, dynamic> profileData;
  final List<Map<String, dynamic>> medicines;
  final VoidCallback onAddMedicine;

  const _HomeTab({
    required this.lang,
    required this.profileData,
    required this.medicines,
    required this.onAddMedicine,
  });

  @override
  Widget build(BuildContext context) {
    final name = (profileData['name'] as String?)?.trim() ?? '';
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (name.isNotEmpty) ...[
            Text('${lang['welcome']!}, $name 👋',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lang['upcoming']!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal)),
              TextButton.icon(
                onPressed: onAddMedicine,
                icon: const Icon(Icons.add_circle_rounded, size: 18),
                label: Text(lang['add_med']!),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: medicines.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.medication_rounded, size: 56, color: Colors.teal.withOpacity(0.3)),
                        const SizedBox(height: 12),
                        Text(lang['no_meds']!, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: medicines.length,
                    itemBuilder: (_, i) => _MedCard(
                      medicine: medicines[i],
                      nextDoseLabel: lang['next_dose']!,
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            _StatCard(icon: Icons.check_circle_outline_rounded, label: '7', sublabel: 'Days streak', color: Colors.green),
            const SizedBox(width: 12),
            _StatCard(icon: Icons.medication_rounded, label: '${medicines.length}', sublabel: 'Active meds', color: Colors.teal),
            const SizedBox(width: 12),
            _StatCard(icon: Icons.notifications_active_rounded, label: '1', sublabel: 'Alert today', color: Colors.orange),
          ]),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MedCard extends StatelessWidget {
  final Map<String, dynamic> medicine;
  final String nextDoseLabel;
  const _MedCard({required this.medicine, required this.nextDoseLabel});

  @override
  Widget build(BuildContext context) {
    final photoPath = medicine['photo'] as String? ?? '';
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade50,
          backgroundImage: photoPath.isNotEmpty ? FileImage(File(photoPath)) : null,
          child: photoPath.isEmpty
              ? const Icon(Icons.medication, color: Colors.teal)
              : null,
        ),
        title: Text(medicine['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${medicine['dosage'] ?? ''}  •  $nextDoseLabel: ${medicine['time'] ?? ''}'),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.teal),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final String label, sublabel; final Color color;
  const _StatCard({required this.icon, required this.label, required this.sublabel, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
          Text(sublabel, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

// ── PLACEHOLDER TAB ───────────────────────────────────────────────────────────
class _SimpleTab extends StatelessWidget {
  final IconData icon; final String title, subtitle;
  const _SimpleTab({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 72, color: Colors.teal.withOpacity(0.4)),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: Colors.grey)),
      ]),
    );
  }
}