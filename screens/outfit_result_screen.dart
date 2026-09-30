import 'dart:math';
import 'package:flutter/material.dart';
import 'profile_input_screen.dart';
import 'settings_screen.dart';

class OutfitResultScreen extends StatefulWidget {
  final String gender; 
  final double height; 
  final double weight; 
  final String skinTone; 

  const OutfitResultScreen({
    super.key,
    required this.gender,
    required this.height,
    required this.weight,
    required this.skinTone,
  });

  @override
  State<OutfitResultScreen> createState() => _OutfitResultScreenState();
}

class _OutfitResultScreenState extends State<OutfitResultScreen> {
  Map<String, dynamic>? _selectedOutfit;

  Map<String, dynamic> _calculateBMI(double heightCm, double weightKg) {
    double heightM = heightCm / 100.0;
    double bmi = weightKg / (heightM * heightM);
    String category = '';

    if (bmi < 18.5) {
      category = 'น้ำหนักน้อย / ผอม (Underweight)';
    } else if (bmi >= 18.5 && bmi < 23.0) {
      category = 'น้ำหนักปกติ / สมส่วน (Normal weight)';
    } else if (bmi >= 23.0 && bmi < 25.0) {
      category = 'ท้วม / น้ำหนักเกิน (Overweight)';
    } else {
      category = 'อ้วน (Obese)';
    }

    return {
      'bmi': bmi.toStringAsFixed(1),
      'category': category,
    };
  }

  String _getHeightCategory(double height) {
    if (height < 160) {
      return 'ช่วงส่วนสูง 150-160 ซม. (รูปร่างกะทัดรัด): เน้นการเลือกเสื้อผ้าที่ช่วยพรางตาให้ช่วงตัวดูโปร่งขึ้น หลีกเลี่ยงเสื้อผ้าตัวยาวโคร่งเกินไป';
    } else if (height >= 160 && height < 170) {
      return 'ช่วงส่วนสูง 160-170 ซม. (รูปร่างมาตรฐาน): เป็นช่วงความสูงที่แต่งตัวค่อนข้างง่าย สามารถใส่ได้หลากหลายสไตล์';
    } else if (height >= 170 && height < 180) {
      return 'ช่วงส่วนสูง 170-180 ซม. (รูปร่างสูงโปร่ง/สมส่วน): โครงร่างสูงเพรียว ใส่เสื้อผ้าได้ง่ายและดูโดดเด่น';
    } else {
      return 'ช่วงส่วนสูง 180 ซม. ขึ้นไป (รูปร่างสูงยาว): โครงร่างสูงโปร่ง สามารถเล่นเลเยอร์เสื้อผ้าได้อย่างเต็มที่';
    }
  }

  List<Map<String, dynamic>> get _currentOutfits {
    bool isMale = widget.gender.contains('ชาย') || widget.gender.toLowerCase() == 'male' || widget.gender.toLowerCase() == 'man';
    double heightM = widget.height / 100.0;
    double bmi = widget.weight / (heightM * heightM);
    bool isObese = bmi >= 25.0;

    if (isObese) {
      if (isMale) {
        return [
          {
            'style': 'Big & Tall Smart Layering',
            'description': 'เน้นเทคนิคการใส่เสื้อคลุม (Layering) และสีเข้มช่วยอำพรางสัดส่วนช่วงลำตัวให้ดูเพรียวและสมส่วนยิ่งขึ้น',
            'images': [
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?auto=format&fit=crop&w=800&q=80',
            ],
            'items': '• เสื้อยืดสีเข้มด้านใน (ดำ/กรมท่า) สวมทับด้วยเสื้อเชิ้ตแขนสั้นแบบไม่ติดกระดุม หรือเสื้อแจ็คเก็ต/เบลเซอร์พอดีตัว\n• กางเกงขายาวทรงกระบอกตรง (หลีกเลี่ยง Skinny)\n• รองเท้าสนีกเกอร์ทรงหนาปานกลางช่วยบาลานซ์สัดส่วน'
          },
          {
            'style': 'Monochrome Casual',
            'description': 'การแต่งตัวคุมโทนสีเข้มหรือสีโทนเดียวกันทั้งชุด ช่วยให้รูปร่างดูยาวเพรียวและพรางสายตาได้ดีเยี่ยม',
            'images': [
              'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1480429370139-e0132c086e2a?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
            ],
            'items': '• เสื้อเชิ้ตโอเวอร์ไซส์พอดีตัว (ไม่รัดรูปจนเกินไป)\n• กางเกงสแล็คหรือชิโน่สีเข้ม\n• รองเท้าโลฟเฟอร์หนังเรียบๆ'
          },
        ];
      } else {
        return [
          {
            'style': 'Plus-Size Elegant & Chic',
            'description': 'เน้นเดรสทรง A-line หรือชุดเอวสูงช่วยอำพรางช่วงหน้าท้องและเน้นช่วงคอให้ดูโปร่งโล่ง',
            'images': [
              'https://images.unsplash.com/photo-1566492031773-4f4e44671857?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
            ],
            'items': '• เดรสยาวคอวีหรือชุดกระโปรงทรงเอ (A-line) ช่วยให้ช่วงคอดูโปร่งและพรางสะโพก\n• เสื้อคลุมเบลเซอร์ทรงยาวคลุมสะโพก\n• รองเท้าส้นสูงแบบหนาหรือคัทชูหัวแหลมช่วยให้ขาดูเรียวยาว'
          },
          {
            'style': 'Vertical Line Chic',
            'description': 'เน้นการใช้เสื้อผ้าที่มีดีเทลแนวตั้งหรือชุดคลุมยาว เพื่อดึงสายตาให้รูปร่างดูสูงเพรียวขึ้น',
            'images': [
              'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
            ],
            'items': '• เสื้อเบลเซอร์ยาวหรือคาร์ดิแกนผ่าหน้าแบบไม่มีกระดุม\n• กางเกงเอวสูงขาตรง\n• กระเป๋าถือทรงตั้ง'
          },
        ];
      }
    } else {
      if (isMale) {
        return [
          {
            'style': 'Streetwear',
            'description': 'เน้นความเท่ คล่องตัว สไตล์สตรีทแฟชั่น ช่วยเสริมลุคให้ดูมีมิติและโดดเด่น',
            'images': [
              'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1516257984-b1b4d707412e?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=800&q=80',
            ],
            'items': '• เสื้อยืดโอเวอร์ไซส์พอดีตัว\n• กางเกงคาร์โก้ทรงกระบอก\n• หมวกแก๊ป และรองเท้าสนีกเกอร์'
          },
          {
            'style': 'Smart Casual',
            'description': 'กึ่งทางการผสมความชิลล์ เหมาะสำหรับใส่ทำงานหรือเที่ยวคาเฟ่ ดูภูมิฐานและสมส่วน',
            'images': [
              'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1480429370139-e0132c086e2a?auto=format&fit=crop&w=800&q=80',
            ],
            'items': '• เสื้อเชิ้ตคอปก หรือเบลเซอร์\n• กางเกงชิโน่เอิร์ธโทน\n• รองเท้าโลฟเฟอร์หรือคัทชูหนัง'
          },
          {
            'style': 'Minimalist',
            'description': 'เรียบง่าย คลีนๆ โทนสีพื้น สะอาดตา สไตล์เกาหลี',
            'images': [
              'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?auto=format&fit=crop&w=800&q=80',
            ],
            'items': '• เสื้อยืดสีพื้นเนื้อผ้าดี\n• กางเกงสแล็คทรงตรง\n• รองเท้าผ้าใบสีขาว'
          },
        ];
      } else {
        return [
          {
            'style': 'Korean Casual',
            'description': 'ลุคสาวเกาหลี น่ารัก สบายๆ แมทช์ง่าย เหมาะกับทุกวัน',
            'images': [
              'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
            ],
            'items': '• เสื้อคาร์ดิแกนไหมพรม\n• กระโปรงเทนนิสหรือกางเกงเอวสูง\n• รองเท้าผ้าใบ'
          },
          {
            'style': 'Chic & Minimal',
            'description': 'เรียบหรู ดูแพง คุมโทนสีเอิร์ธโทน คลีนและดูมีรสนิยม',
            'images': [
              'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1566492031773-4f4e44671857?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
            ],
            'items': '• เสื้อเบลเซอร์ทรงสวย\n• กางเกงผ้าขาตรง\n• กระเป๋าถือดีไซน์เรียบ'
          },
          {
            'style': 'Street Chic',
            'description': 'ลุคสตรีทเท่ๆ ปนความชิค คล่องตัว ทันสมัย',
            'images': [
              'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
              'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=800&q=80',
            ],
            'items': '• เสื้อครอปหรือเสื้อยืดลายกราฟิก\n• กางเกงยีนส์เอวสูงทรงบอย\n• รองเท้าสนีกเกอร์'
          },
        ];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final outfits = _currentOutfits;
    if (outfits.isNotEmpty) {
      _selectedOutfit = outfits[0];
    }
  }

  void _shuffleOutfit() {
    setState(() {
      final random = Random();
      final outfits = _currentOutfits;
      if (outfits.length <= 1) return;
      
      Map<String, dynamic> newOutfit;
      do {
        newOutfit = outfits[random.nextInt(outfits.length)];
      } while (_selectedOutfit != null && newOutfit['style'] == _selectedOutfit!['style']);
      
      _selectedOutfit = newOutfit;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String heightCategoryDesc = _getHeightCategory(widget.height);
    double heightM = widget.height / 100.0;
    double bmi = widget.weight / (heightM * heightM);
    bool isObese = bmi >= 25.0;
    final Map<String, dynamic> bmiResult = _calculateBMI(widget.height, widget.weight);
    
    final List<String> refImages = _selectedOutfit != null ? List<String>.from(_selectedOutfit!['images']) : [];
    
    // ดึง Theme ปัจจุบันมาใช้เพื่อให้รองรับ Dark Mode / Light Mode อัตโนมัติ
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ไอเดียสไตล์การแต่งตัวของคุณ',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'ตั้งค่าแอปพลิเคชัน',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.teal.shade700 : Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_outline, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.gender} • ${widget.skinTone}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 14, 
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ส่วนสูง: ${widget.height.toInt()} ซม. | น้ำหนัก: ${widget.weight.toInt()} กก. | BMI: ${bmiResult['bmi']}',
                          style: TextStyle(fontSize: 12.5, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: theme.iconTheme.color?.withOpacity(0.7), size: 20),
                    tooltip: 'แก้ไขข้อมูลสรีระ',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileInputScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_selectedOutfit != null) ...[
              // Style Title & Shuffle Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedOutfit!['style'],
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                    ),
                  ),
                  if (_currentOutfits.length > 1)
                    ElevatedButton.icon(
                      onPressed: _shuffleOutfit,
                      icon: const Icon(Icons.shuffle, size: 16),
                      label: const Text('สไตล์อื่นๆ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.teal.shade700 : Colors.black87,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              
              // AI Analysis Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Color(0xFFD4AF37), size: 18),
                        const SizedBox(width: 8),
                        Text(
                          isObese ? 'สไตล์แนะนำพิเศษสำหรับรูปร่างของคุณ' : 'AI วิเคราะห์สไตล์และสรีระ',
                          style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color, fontSize: 14.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isObese 
                          ? '• วิเคราะห์จากค่า BMI (${bmiResult['bmi']} - ${bmiResult['category']}): ระบบเลือกสไตล์ที่ช่วยอำพรางสัดส่วนและเสริมความมั่นใจให้คุณโดยเฉพาะ\n\n'
                            '• โทนสีผิว (${widget.skinTone}): การเลือกสไตล์นี้จะช่วยขับผิวและเสริมบุคลิกให้ดูโดดเด่นและลงตัว'
                          : '• วิเคราะห์ช่วงส่วนสูง: $heightCategoryDesc\n\n'
                            '• วิเคราะห์จากค่า BMI (${bmiResult['bmi']} - ${bmiResult['category']}): เหมาะกับการใส่เสื้อผ้าสไตล์นี้เพื่อให้ดูสมส่วน\n\n'
                            '• โทนสีผิว (${widget.skinTone}): ช่วยขับผิวและเสริมลุคให้ดูโดดเด่นยิ่งขึ้น',
                      style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8), fontSize: 13, height: 1.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
                    ),
                    Text(
                      _selectedOutfit!['description'],
                      style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Reference Images Title
              Text(
                'ตัวอย่างรูปภาพเรฟเฟอเรนซ์ (5 ลุคเด่น)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
              ),
              const SizedBox(height: 12),

              // 📸 รูปเรฟเฟอเรนซ์ทรงตั้ง (สไลด์เลื่อนดูแนวนอน 5 รูป)
              SizedBox(
                height: 420, 
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: refImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 260, 
                      margin: EdgeInsets.only(right: index < refImages.length - 1 ? 12 : 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            refImages[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.grey.shade400,
                                  strokeWidth: 2,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Icon(Icons.broken_image, size: 30, color: Colors.grey),
                            ),
                          ),
                          // ป้ายบอกลำดับ (1/5, 2/5, 3/5, 4/5, 5/5)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${index + 1}/${refImages.length}',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              
              // Essential Items Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.checkroom_rounded, color: theme.textTheme.bodyLarge?.color, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'ไอเทมหลักที่ต้องมีในลุคนี้',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _selectedOutfit!['items'],
                      style: TextStyle(fontSize: 13.5, height: 1.6, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}