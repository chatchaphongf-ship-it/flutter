import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'outfit_result_screen.dart';
import 'settings_screen.dart'; // อย่าลืม import หน้า settings เข้ามา

class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen({super.key});

  @override
  State<ProfileInputScreen> createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedGender = 'ผู้ชาย';
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  
  final List<Map<String, dynamic>> _skinTones = [
    {'name': 'ผิวขาว / ผิวอมชมพู', 'color': const Color(0xFFFDE8E9)},
    {'name': 'ผิวขาวเหลือง', 'color': const Color(0xFFFCE8B2)},
    {'name': 'ผิวสองสี / ผิวแทน', 'color': const Color(0xFFD4A373)},
    {'name': 'ผิวเข้ม', 'color': const Color(0xFF8D5B4C)},
  ];

  late String _selectedSkinTone;
  final List<String> _genders = ['ผู้ชาย', 'ผู้หญิง'];

  @override
  void initState() {
    super.initState();
    _selectedSkinTone = _skinTones[0]['name'];
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      double height = double.parse(_heightController.text);
      double weight = double.parse(_weightController.text);

      try {
        await FirebaseFirestore.instance.collection('users').add({
          'gender': _selectedGender,
          'height': height,
          'weight': weight,
          'skinTone': _selectedSkinTone,
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OutfitResultScreen(
              gender: _selectedGender,
              height: height,
              weight: weight,
              skinTone: _selectedSkinTone,
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ตั้งค่าข้อมูลสรีระของคุณ',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        elevation: 0,
        centerTitle: true,
        // เพิ่มปุ่มรูปเฟืองสำหรับเปิดหน้าตั้งค่า
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'กรอกข้อมูลเพื่อรับคำแนะนำสไตล์การแต่งตัวที่เหมาะสมที่สุดสำหรับคุณ',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),

                // ฟิลด์: เพศ
                _buildSectionLabel('เพศของคุณ', isDarkMode),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: _buildBoxDecoration(isDarkMode),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedGender,
                      isExpanded: true,
                      dropdownColor: theme.cardColor,
                      icon: Icon(Icons.keyboard_arrow_down_rounded, color: isDarkMode ? Colors.white70 : Colors.black54),
                      items: _genders.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender, style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white : Colors.black87)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedGender = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ฟิลด์: ส่วนสูง
                _buildSectionLabel('ส่วนสูง (เซนติเมตร) [จำกัด 100 - 230 ซม.]', isDarkMode),
                const SizedBox(height: 8),
                Container(
                  decoration: _buildBoxDecoration(isDarkMode),
                  child: TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white : Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'เช่น 178',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: Icon(Icons.height_rounded, color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกส่วนสูง';
                      }
                      double? h = double.tryParse(value);
                      if (h == null || h < 100 || h > 230) {
                        return 'กรุณากรอกส่วนสูงระหว่าง 100 - 230 ซม.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // ฟิลด์: น้ำหนัก
                _buildSectionLabel('น้ำหนัก (กิโลกรัม) [จำกัด 30 - 250 กก.]', isDarkMode),
                const SizedBox(height: 8),
                Container(
                  decoration: _buildBoxDecoration(isDarkMode),
                  child: TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white : Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'เช่น 65',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: Icon(Icons.monitor_weight_outlined, color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกน้ำหนัก';
                      }
                      double? w = double.tryParse(value);
                      if (w == null || w < 30 || w > 250) {
                        return 'กรุณากรอกน้ำหนักระหว่าง 30 - 250 กก.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // ฟิลด์: โทนสีผิว
                _buildSectionLabel('โทนสีผิว', isDarkMode),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: _buildBoxDecoration(isDarkMode),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSkinTone,
                      isExpanded: true,
                      dropdownColor: theme.cardColor,
                      icon: Icon(Icons.keyboard_arrow_down_rounded, color: isDarkMode ? Colors.white70 : Colors.black54),
                      items: _skinTones.map((Map<String, dynamic> tone) {
                        return DropdownMenuItem<String>(
                          value: tone['name'] as String,
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: tone['color'] as Color,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey.shade300, width: 1),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                tone['name'] as String,
                                style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white : Colors.black87),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedSkinTone = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // ปุ่มกดหลัก
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.white : Colors.black87,
                      foregroundColor: isDarkMode ? Colors.black : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'ดูไอเดียสไตล์การแต่งตัว',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, bool isDarkMode) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.white70 : Colors.black87,
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(bool isDarkMode) {
    return BoxDecoration(
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.02),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}