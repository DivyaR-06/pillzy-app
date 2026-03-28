import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  final String languageCode;
  const RegistrationScreen({super.key, required this.languageCode});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Massive Translation Dictionary for all fields
  final Map<String, Map<String, String>> translations = {
    'en': {
      'title': 'Registration', 'patient_details': 'Patient Details', 'name': 'Full Name',
      'age': 'Age', 'gender': 'Gender', 'dob': 'Date of Birth (DD/MM/YYYY)',
      'blood_group': 'Blood Group', 'email': 'Email ID', 'phone': 'Phone Number',
      'address': 'Full Address', 'photo_guide': 'Take Photo (Face Guide)',
      'emergency_details': 'Emergency Contact', 'relationship': 'Relationship to Patient',
      'submit': 'Save Profile',
    },
    'ta': {
      'title': 'பதிவு', 'patient_details': 'நோயாளி விவரங்கள்', 'name': 'முழு பெயர்',
      'age': 'வயது', 'gender': 'பாலினம்', 'dob': 'பிறந்த தேதி',
      'blood_group': 'இரத்த வகை', 'email': 'மின்னஞ்சல்', 'phone': 'தொலைபேசி எண்',
      'address': 'முகவரி', 'photo_guide': 'புகைப்படம் எடுக்க (வழிகாட்டி)',
      'emergency_details': 'அவசர தொடர்பு', 'relationship': 'உறவுமுறை',
      'submit': 'சேமிக்க',
    },
    'hi': {
      'title': 'पंजीकरण', 'patient_details': 'रोगी का विवरण', 'name': 'पूरा नाम',
      'age': 'आयु', 'gender': 'लिंग', 'dob': 'जन्म तिथि',
      'blood_group': 'रक्त समूह', 'email': 'ईमेल', 'phone': 'फ़ोन नंबर',
      'address': 'पता', 'photo_guide': 'फोटो लें (चेहरा गाइड)',
      'emergency_details': 'आपातकालीन संपर्क', 'relationship': 'रोगी से संबंध',
      'submit': 'प्रोफ़ाइल सहेजें',
    },
    'te': {
      'title': 'నమోదు', 'patient_details': 'రోగి వివరాలు', 'name': 'పూర్తి పేరు',
      'age': 'వయస్సు', 'gender': 'లింగం', 'dob': 'పుట్టిన తేదీ',
      'blood_group': 'రక్త వర్గం', 'email': 'ఇమెయిల్', 'phone': 'ఫోన్ నంబర్',
      'address': 'చిరునామా', 'photo_guide': 'ఫోటో తీయండి',
      'emergency_details': 'అత్యవసర సంప్రదింపు', 'relationship': 'సంబంధం',
      'submit': 'సేవ్ చేయండి',
    },
    'bn': {
      'title': 'নিবন্ধন', 'patient_details': 'রোগীর বিবরণ', 'name': 'পুরো নাম',
      'age': 'বয়স', 'gender': 'লিঙ্গ', 'dob': 'জন্ম তারিখ',
      'blood_group': 'রক্তের গ্রুপ', 'email': 'ইমেইল', 'phone': 'ফোন নম্বর',
      'address': 'ঠিকানা', 'photo_guide': 'ছবি তুলুন',
      'emergency_details': 'জরুরী যোগাযোগ', 'relationship': 'সম্পর্ক',
      'submit': 'সেভ করুন',
    },
    'mr': {
      'title': 'नोंदणी', 'patient_details': 'रुग्णाचा तपशील', 'name': 'पूर्ण नाव',
      'age': 'वय', 'gender': 'लिंग', 'dob': 'जन्मतारीख',
      'blood_group': 'रक्तगट', 'email': 'ईमेल', 'phone': 'फोन नंबर',
      'address': 'पत्ता', 'photo_guide': 'फोटो काढा',
      'emergency_details': 'आपत्कालीन संपर्क', 'relationship': 'नाते',
      'submit': 'सेव्ह करा',
    },
  };

  // Helper widget to generate text fields quickly
  Widget _buildTextField(String label, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  // Helper widget for Dropdowns (Gender, Blood Group)
  Widget _buildDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        onChanged: (value) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = translations[widget.languageCode] ?? translations['en']!;

    return Scaffold(
      appBar: AppBar(title: Text(lang['title']!)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- SECTION 1: PATIENT DETAILS ---
            Text(lang['patient_details']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTextField(lang['name']!),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(lang['age']!, type: TextInputType.number)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDropdown(lang['gender']!, ['Male', 'Female', 'Other'])),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(lang['dob']!)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDropdown(lang['blood_group']!, ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'])),
                      ],
                    ),
                    _buildTextField(lang['email']!, type: TextInputType.emailAddress),
                    _buildTextField(lang['phone']!, type: TextInputType.phone),
                    _buildTextField(lang['address']!),
                    
                    // Photo Guide UI
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        border: Border.all(color: Colors.teal, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.face_retouching_natural, size: 40, color: Colors.teal),
                            const SizedBox(height: 8),
                            Text(lang['photo_guide']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // --- SECTION 2: EMERGENCY CONTACT ---
            Text(lang['emergency_details']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTextField(lang['name']!),
                    _buildDropdown(lang['relationship']!, ['Parent', 'Child', 'Spouse', 'Sibling', 'Other']),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(lang['age']!, type: TextInputType.number)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDropdown(lang['gender']!, ['Male', 'Female', 'Other'])),
                      ],
                    ),
                    _buildTextField(lang['phone']!, type: TextInputType.phone),
                    _buildTextField(lang['email']!, type: TextInputType.emailAddress),
                    _buildTextField(lang['address']!),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            
            // SUBMIT BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // Form validation and DB save logic goes here
              },
              child: Text(lang['submit']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}