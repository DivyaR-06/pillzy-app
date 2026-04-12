import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final String languageCode;
  const RegistrationScreen({super.key, required this.languageCode});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  File? _uploadedPhoto;
  String? _photoError;

  // Controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _emergencyEmailController = TextEditingController();
  final _emergencyAddressController = TextEditingController();

  String? _selectedGender;
  String? _selectedBloodGroup;
  String? _selectedRelationship;
  String? _emergencyGender;

  final Map<String, Map<String, String>> translations = {
    'en': {
      'title': 'Registration', 'patient_details': 'Patient Details', 'name': 'Full Name',
      'age': 'Age', 'gender': 'Gender', 'dob': 'Date of Birth (DD/MM/YYYY)',
      'blood_group': 'Blood Group', 'email': 'Email ID', 'phone': 'Phone Number',
      'address': 'Full Address', 'photo_guide': 'Upload Passport Photo',
      'photo_hint': 'JPG/PNG • 120 KB – 5 MB • Passport size',
      'photo_change': 'Change Photo', 'photo_error_size': 'File must be between 120 KB and 5 MB.',
      'photo_error_type': 'Only JPG/PNG files are allowed.',
      'emergency_details': 'Emergency Contact', 'relationship': 'Relationship to Patient',
      'submit': 'Save Profile', 'male': 'Male', 'female': 'Female', 'other': 'Other',
      'parent': 'Parent', 'child': 'Child', 'spouse': 'Spouse', 'sibling': 'Sibling',
    },
    'ta': {
      'title': 'பதிவு', 'patient_details': 'நோயாளி விவரங்கள்', 'name': 'முழு பெயர்',
      'age': 'வயது', 'gender': 'பாலினம்', 'dob': 'பிறந்த தேதி',
      'blood_group': 'இரத்த வகை', 'email': 'மின்னஞ்சல்', 'phone': 'தொலைபேசி எண்',
      'address': 'முகவரி', 'photo_guide': 'கடவுச்சீட்டு புகைப்படம் பதிவேற்று',
      'photo_hint': 'JPG/PNG • 120 KB – 5 MB • கடவுச்சீட்டு அளவு',
      'photo_change': 'புகைப்படம் மாற்று', 'photo_error_size': 'கோப்பு 120 KB மற்றும் 5 MB இடையே இருக்க வேண்டும்.',
      'photo_error_type': 'JPG/PNG கோப்புகள் மட்டுமே அனுமதிக்கப்படுகின்றன.',
      'emergency_details': 'அவசர தொடர்பு', 'relationship': 'உறவுமுறை',
      'submit': 'சேமிக்க', 'male': 'ஆண்', 'female': 'பெண்', 'other': 'மற்றவை',
      'parent': 'பெற்றோர்', 'child': 'குழந்தை', 'spouse': 'வாழ்க்கைத்துணை', 'sibling': 'உடன்பிறந்தவர்',
    },
    'hi': {
      'title': 'पंजीकरण', 'patient_details': 'रोगी का विवरण', 'name': 'पूरा नाम',
      'age': 'आयु', 'gender': 'लिंग', 'dob': 'जन्म तिथि',
      'blood_group': 'रक्त समूह', 'email': 'ईमेल', 'phone': 'फ़ोन नंबर',
      'address': 'पता', 'photo_guide': 'पासपोर्ट फ़ोटो अपलोड करें',
      'photo_hint': 'JPG/PNG • 120 KB – 5 MB • पासपोर्ट साइज़',
      'photo_change': 'फ़ोटो बदलें', 'photo_error_size': 'फ़ाइल 120 KB और 5 MB के बीच होनी चाहिए।',
      'photo_error_type': 'केवल JPG/PNG फ़ाइलें अनुमत हैं।',
      'emergency_details': 'आपातकालीन संपर्क', 'relationship': 'रोगी से संबंध',
      'submit': 'प्रोफ़ाइल सहेजें', 'male': 'पुरुष', 'female': 'महिला', 'other': 'अन्य',
      'parent': 'माता-पिता', 'child': 'बच्चा', 'spouse': 'जीवनसाथी', 'sibling': 'भाई-बहन',
    },
    'te': {
      'title': 'నమోదు', 'patient_details': 'రోగి వివరాలు', 'name': 'పూర్తి పేరు',
      'age': 'వయస్సు', 'gender': 'లింగం', 'dob': 'పుట్టిన తేదీ',
      'blood_group': 'రక్త వర్గం', 'email': 'ఇమెయిల్', 'phone': 'ఫోన్ నంబర్',
      'address': 'చిరునామా', 'photo_guide': 'పాస్‌పోర్ట్ ఫోటో అప్‌లోడ్ చేయండి',
      'photo_hint': 'JPG/PNG • 120 KB – 5 MB • పాస్‌పోర్ట్ సైజ్',
      'photo_change': 'ఫోటో మార్చండి', 'photo_error_size': 'ఫైల్ 120 KB మరియు 5 MB మధ్య ఉండాలి.',
      'photo_error_type': 'JPG/PNG ఫైళ్లు మాత్రమే అనుమతించబడతాయి.',
      'emergency_details': 'అత్యవసర సంప్రదింపు', 'relationship': 'సంబంధం',
      'submit': 'సేవ్ చేయండి', 'male': 'పురుషుడు', 'female': 'స్త్రీ', 'other': 'ఇతర',
      'parent': 'తల్లిదండ్రులు', 'child': 'పిల్లలు', 'spouse': 'జీవిత భాగస్వామి', 'sibling': 'తోబుట్టువు',
    },
    'bn': {
      'title': 'নিবন্ধন', 'patient_details': 'রোগীর বিবরণ', 'name': 'পুরো নাম',
      'age': 'বয়স', 'gender': 'লিঙ্গ', 'dob': 'জন্ম তারিখ',
      'blood_group': 'রক্তের গ্রুপ', 'email': 'ইমেইল', 'phone': 'ফোন নম্বর',
      'address': 'ঠিকানা', 'photo_guide': 'পাসপোর্ট ছবি আপলোড করুন',
      'photo_hint': 'JPG/PNG • 120 KB – 5 MB • পাসপোর্ট সাইজ',
      'photo_change': 'ছবি পরিবর্তন করুন', 'photo_error_size': 'ফাইলটি 120 KB এবং 5 MB এর মধ্যে হতে হবে।',
      'photo_error_type': 'শুধুমাত্র JPG/PNG ফাইল অনুমোদিত।',
      'emergency_details': 'জরুরী যোগাযোগ', 'relationship': 'সম্পর্ক',
      'submit': 'সেভ করুন', 'male': 'পুরুষ', 'female': 'মহিলা', 'other': 'অন্যান্য',
      'parent': 'অভিভাবক', 'child': 'সন্তান', 'spouse': 'স্বামী/স্ত্রী', 'sibling': 'ভাই/বোন',
    },
    'mr': {
      'title': 'नोंदणी', 'patient_details': 'रुग्णाचा तपशील', 'name': 'पूर्ण नाव',
      'age': 'वय', 'gender': 'लिंग', 'dob': 'जन्मतारीख',
      'blood_group': 'रक्तगट', 'email': 'ईमेल', 'phone': 'फोन नंबर',
      'address': 'पत्ता', 'photo_guide': 'पासपोर्ट फोटो अपलोड करा',
      'photo_hint': 'JPG/PNG • 120 KB – 5 MB • पासपोर्ट साइज',
      'photo_change': 'फोटो बदला', 'photo_error_size': 'फाइल 120 KB आणि 5 MB दरम्यान असणे आवश्यक आहे.',
      'photo_error_type': 'फक्त JPG/PNG फाइल्स परवानगी आहेत.',
      'emergency_details': 'आपत्कालीन संपर्क', 'relationship': 'नाते',
      'submit': 'सेव्ह करा', 'male': 'पुरुष', 'female': 'महिला', 'other': 'इतर',
      'parent': 'पालक', 'child': 'मूल', 'spouse': 'जोडीदार', 'sibling': 'भाऊ/बहीण',
    },
  };

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final bytes = await file.length();
    final ext = picked.path.split('.').last.toLowerCase();
    final lang = translations[widget.languageCode] ?? translations['en']!;

    if (ext != 'jpg' && ext != 'jpeg' && ext != 'png') {
      setState(() { _photoError = lang['photo_error_type']; _uploadedPhoto = null; });
      return;
    }
    if (bytes < 120 * 1024 || bytes > 5 * 1024 * 1024) {
      setState(() { _photoError = lang['photo_error_size']; _uploadedPhoto = null; });
      return;
    }

    setState(() { _uploadedPhoto = file; _photoError = null; });
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = translations[widget.languageCode] ?? translations['en']!;
    final genderOptions = [lang['male']!, lang['female']!, lang['other']!];
    final relationOptions = [lang['parent']!, lang['child']!, lang['spouse']!, lang['sibling']!, lang['other']!];

    return Scaffold(
      appBar: AppBar(title: Text(lang['title']!)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── PATIENT DETAILS ──
            Text(lang['patient_details']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTextField(lang['name']!, _nameController),
                    Row(children: [
                      Expanded(child: _buildTextField(lang['age']!, _ageController, type: TextInputType.number)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDropdown(lang['gender']!, genderOptions, _selectedGender, (v) => setState(() => _selectedGender = v))),
                    ]),
                    Row(children: [
                      Expanded(child: _buildTextField(lang['dob']!, _dobController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDropdown(lang['blood_group']!, ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'], _selectedBloodGroup, (v) => setState(() => _selectedBloodGroup = v))),
                    ]),
                    _buildTextField(lang['email']!, _emailController, type: TextInputType.emailAddress),
                    _buildTextField(lang['phone']!, _phoneController, type: TextInputType.phone),
                    _buildTextField(lang['address']!, _addressController),

                    // ── PHOTO UPLOAD ──
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickPhoto,
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.07),
                          border: Border.all(
                            color: _photoError != null ? Colors.red : Colors.teal,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _uploadedPhoto != null
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(_uploadedPhoto!, fit: BoxFit.cover),
                                  ),
                                  Positioned(
                                    bottom: 8, right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.85),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(lang['photo_change']!, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.upload_file_rounded, size: 40, color: Colors.teal),
                                    const SizedBox(height: 8),
                                    Text(lang['photo_guide']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                                    const SizedBox(height: 4),
                                    Text(lang['photo_hint']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    if (_photoError != null) ...[
                      const SizedBox(height: 6),
                      Text(_photoError!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── EMERGENCY CONTACT ──
            Text(lang['emergency_details']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTextField(lang['name']!, _emergencyNameController),
                    _buildDropdown(lang['relationship']!, relationOptions, _selectedRelationship, (v) => setState(() => _selectedRelationship = v)),
                    Row(children: [
                      Expanded(child: _buildDropdown(lang['gender']!, genderOptions, _emergencyGender, (v) => setState(() => _emergencyGender = v))),
                    ]),
                    _buildTextField(lang['phone']!, _emergencyPhoneController, type: TextInputType.phone),
                    _buildTextField(lang['email']!, _emergencyEmailController, type: TextInputType.emailAddress),
                    _buildTextField(lang['address']!, _emergencyAddressController),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // Collect all data into a map and navigate to HomeScreen
                final profileData = {
                  'languageCode': widget.languageCode,
                  'name': _nameController.text,
                  'age': _ageController.text,
                  'gender': _selectedGender ?? '',
                  'dob': _dobController.text,
                  'blood_group': _selectedBloodGroup ?? '',
                  'email': _emailController.text,
                  'phone': _phoneController.text,
                  'address': _addressController.text,
                  'photo': _uploadedPhoto?.path ?? '',
                  'emergency_name': _emergencyNameController.text,
                  'emergency_relationship': _selectedRelationship ?? '',
                  'emergency_gender': _emergencyGender ?? '',
                  'emergency_phone': _emergencyPhoneController.text,
                  'emergency_email': _emergencyEmailController.text,
                  'emergency_address': _emergencyAddressController.text,
                };

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen(profileData: profileData)),
                  (route) => false,
                );
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