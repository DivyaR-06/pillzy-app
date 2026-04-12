import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MedicineDetailsScreen extends StatefulWidget {
  final String languageCode;
  const MedicineDetailsScreen({super.key, required this.languageCode});

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  File? _medicinePhoto;
  String? _photoError;
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  TimeOfDay? _selectedTime;
  String? _selectedFrequency;

  static const Map<String, Map<String, String>> translations = {
    'en': {
      'title': 'Medicine Details',
      'photo_label': 'Medicine Photo',
      'photo_hint': 'Tap to upload medicine image\nJPG/PNG • Max 5 MB',
      'photo_change': 'Change',
      'photo_error': 'Only JPG/PNG files under 5 MB are allowed.',
      'med_name': 'Medicine Name',
      'dosage': 'Dosage (e.g. 500mg, 1 tablet)',
      'time': 'Time to be Taken',
      'pick_time': 'Select Time',
      'frequency': 'Frequency',
      'freq_once': 'Once a day',
      'freq_twice': 'Twice a day',
      'freq_thrice': 'Three times a day',
      'freq_custom': 'As needed',
      'save': 'Save Medicine',
      'required': 'Please fill all fields.',
    },
    'ta': {
      'title': 'மருந்து விவரங்கள்',
      'photo_label': 'மருந்து புகைப்படம்',
      'photo_hint': 'மருந்து படத்தை பதிவேற்ற தட்டவும்\nJPG/PNG • அதிகபட்சம் 5 MB',
      'photo_change': 'மாற்று',
      'photo_error': 'JPG/PNG கோப்புகள் மட்டுமே, 5 MB க்கு குறைவாக.',
      'med_name': 'மருந்தின் பெயர்',
      'dosage': 'மோதரை (எ.கா. 500mg, 1 மாத்திரை)',
      'time': 'எடுக்க வேண்டிய நேரம்',
      'pick_time': 'நேரம் தேர்வு செய்க',
      'frequency': 'அதிர்வெண்',
      'freq_once': 'ஒரு நாளில் ஒருமுறை',
      'freq_twice': 'ஒரு நாளில் இருமுறை',
      'freq_thrice': 'ஒரு நாளில் மூன்று முறை',
      'freq_custom': 'தேவைப்படும்போது',
      'save': 'மருந்தை சேமிக்க',
      'required': 'அனைத்து புலங்களையும் நிரப்பவும்.',
    },
    'hi': {
      'title': 'दवा विवरण',
      'photo_label': 'दवा की फ़ोटो',
      'photo_hint': 'दवा की छवि अपलोड करने के लिए टैप करें\nJPG/PNG • अधिकतम 5 MB',
      'photo_change': 'बदलें',
      'photo_error': 'केवल JPG/PNG फ़ाइलें, 5 MB से कम।',
      'med_name': 'दवा का नाम',
      'dosage': 'खुराक (जैसे 500mg, 1 टैबलेट)',
      'time': 'लेने का समय',
      'pick_time': 'समय चुनें',
      'frequency': 'आवृत्ति',
      'freq_once': 'दिन में एक बार',
      'freq_twice': 'दिन में दो बार',
      'freq_thrice': 'दिन में तीन बार',
      'freq_custom': 'आवश्यकतानुसार',
      'save': 'दवा सहेजें',
      'required': 'कृपया सभी फ़ील्ड भरें।',
    },
    'te': {
      'title': 'మందు వివరాలు',
      'photo_label': 'మందు ఫోటో',
      'photo_hint': 'మందు చిత్రాన్ని అప్‌లోడ్ చేయడానికి నొక్కండి\nJPG/PNG • గరిష్టం 5 MB',
      'photo_change': 'మార్చు',
      'photo_error': 'JPG/PNG ఫైళ్లు మాత్రమే, 5 MB కంటే తక్కువ.',
      'med_name': 'మందు పేరు',
      'dosage': 'మోతాదు (ఉదా. 500mg, 1 టాబ్లెట్)',
      'time': 'తీసుకోవాల్సిన సమయం',
      'pick_time': 'సమయం ఎంచుకోండి',
      'frequency': 'తరచుదనం',
      'freq_once': 'రోజుకు ఒకసారి',
      'freq_twice': 'రోజుకు రెండుసార్లు',
      'freq_thrice': 'రోజుకు మూడుసార్లు',
      'freq_custom': 'అవసరమైనప్పుడు',
      'save': 'మందు సేవ్ చేయండి',
      'required': 'దయచేసి అన్ని ఫీల్డ్‌లు నింపండి.',
    },
    'bn': {
      'title': 'ওষুধের বিবরণ',
      'photo_label': 'ওষুধের ছবি',
      'photo_hint': 'ওষুধের ছবি আপলোড করতে ট্যাপ করুন\nJPG/PNG • সর্বোচ্চ 5 MB',
      'photo_change': 'পরিবর্তন',
      'photo_error': 'শুধুমাত্র JPG/PNG, 5 MB এর কম।',
      'med_name': 'ওষুধের নাম',
      'dosage': 'ডোজ (যেমন 500mg, ১ ট্যাবলেট)',
      'time': 'খাওয়ার সময়',
      'pick_time': 'সময় নির্বাচন করুন',
      'frequency': 'কতবার',
      'freq_once': 'দিনে একবার',
      'freq_twice': 'দিনে দুইবার',
      'freq_thrice': 'দিনে তিনবার',
      'freq_custom': 'প্রয়োজন মতো',
      'save': 'ওষুধ সেভ করুন',
      'required': 'অনুগ্রহ করে সব ক্ষেত্র পূরণ করুন।',
    },
    'mr': {
      'title': 'औषध तपशील',
      'photo_label': 'औषधाचा फोटो',
      'photo_hint': 'औषधाची प्रतिमा अपलोड करण्यासाठी टॅप करा\nJPG/PNG • कमाल 5 MB',
      'photo_change': 'बदला',
      'photo_error': 'फक्त JPG/PNG, 5 MB पेक्षा कमी.',
      'med_name': 'औषधाचे नाव',
      'dosage': 'डोस (उदा. 500mg, 1 टॅबलेट)',
      'time': 'घेण्याची वेळ',
      'pick_time': 'वेळ निवडा',
      'frequency': 'वारंवारता',
      'freq_once': 'दिवसातून एकदा',
      'freq_twice': 'दिवसातून दोनदा',
      'freq_thrice': 'दिवसातून तीनदा',
      'freq_custom': 'गरजेनुसार',
      'save': 'औषध सेव्ह करा',
      'required': 'कृपया सर्व फील्ड भरा.',
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
      setState(() { _photoError = lang['photo_error']; _medicinePhoto = null; });
      return;
    }
    if (bytes > 5 * 1024 * 1024) {
      setState(() { _photoError = lang['photo_error']; _medicinePhoto = null; });
      return;
    }
    setState(() { _medicinePhoto = file; _photoError = null; });
  }

  Future<void> _pickTime(Map<String, String> lang) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final lang = translations[widget.languageCode] ?? translations['en']!;
    final freqOptions = [
      lang['freq_once']!, lang['freq_twice']!,
      lang['freq_thrice']!, lang['freq_custom']!,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D7DD2),
        foregroundColor: Colors.white,
        title: Text(lang['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ── MEDICINE PHOTO ──────────────────────────────────────
            Center(
              child: GestureDetector(
                onTap: _pickPhoto,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _photoError != null
                          ? Colors.red
                          : const Color(0xFF2D7DD2),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2D7DD2).withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    image: _medicinePhoto != null
                        ? DecorationImage(image: FileImage(_medicinePhoto!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _medicinePhoto == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.medication_rounded, size: 48, color: Color(0xFF2D7DD2)),
                            const SizedBox(height: 8),
                            Text(
                              lang['photo_label']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2D7DD2),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D7DD2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(lang['photo_change']!, style: const TextStyle(color: Colors.white, fontSize: 11)),
                          ),
                        ),
                ),
              ),
            ),
            if (_photoError != null) ...[
              const SizedBox(height: 8),
              Center(child: Text(_photoError!, style: const TextStyle(color: Colors.red, fontSize: 12))),
            ],
            const SizedBox(height: 8),
            Center(
              child: Text(
                lang['photo_hint']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 32),

            // ── FORM CARD ───────────────────────────────────────────
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // Medicine Name
                    _buildLabel(lang['med_name']!),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: _inputDeco(
                        hint: 'e.g. Paracetamol',
                        icon: Icons.medication_liquid_rounded,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Dosage
                    _buildLabel(lang['dosage']!),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _dosageController,
                      decoration: _inputDeco(
                        hint: 'e.g. 500mg',
                        icon: Icons.scale_rounded,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Frequency
                    _buildLabel(lang['frequency']!),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedFrequency,
                      decoration: _inputDeco(
                        hint: freqOptions.first,
                        icon: Icons.repeat_rounded,
                      ),
                      items: freqOptions
                          .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedFrequency = v),
                    ),

                    const SizedBox(height: 20),

                    // Time picker
                    _buildLabel(lang['time']!),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickTime(lang),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F6FB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: Color(0xFF2D7DD2), size: 22),
                            const SizedBox(width: 12),
                            Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : lang['pick_time']!,
                              style: TextStyle(
                                fontSize: 15,
                                color: _selectedTime != null ? Colors.black87 : Colors.grey,
                                fontWeight: _selectedTime != null ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── SAVE BUTTON ─────────────────────────────────────────
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D7DD2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                shadowColor: const Color(0xFF2D7DD2).withOpacity(0.4),
              ),
              onPressed: () {
                final lang = translations[widget.languageCode] ?? translations['en']!;
                if (_nameController.text.trim().isEmpty ||
                    _dosageController.text.trim().isEmpty ||
                    _selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(lang['required']!), backgroundColor: Colors.red),
                  );
                  return;
                }
                // Return medicine data to caller
                Navigator.pop(context, {
                  'photo': _medicinePhoto?.path ?? '',
                  'name': _nameController.text.trim(),
                  'dosage': _dosageController.text.trim(),
                  'frequency': _selectedFrequency ?? '',
                  'time': _selectedTime!.format(context),
                });
              },
              child: Text(lang['save']!, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF4A5568),
        letterSpacing: 0.3,
      ),
    );
  }

  InputDecoration _inputDeco({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: const Color(0xFF2D7DD2), size: 20),
      filled: true,
      fillColor: const Color(0xFFF4F6FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2D7DD2), width: 2),
      ),
    );
  }
}