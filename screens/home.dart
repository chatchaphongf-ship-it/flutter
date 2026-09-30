import 'package:flutter/material.dart';
import '../widgets/outfit_card.dart';
import 'wardrobe_screen.dart';
import 'profile_input_screen.dart';
import 'settings_screen.dart';
import '../services/authentication_service.dart'; // 📌 1. นำเข้า Service สำหรับจัดการ Auth
import 'login_page.dart';                      // 📌 2. นำเข้าหน้า Login เพื่อพาเด้งกลับไปตอน Logout

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Outfit Planner'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          // 📌 3. เพิ่มปุ่ม Logout ตรงนี้
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'ออกจากระบบ',
            onPressed: () {
              AuthenticationService().logout().then((_) {
                if (context.mounted) {
                  // เคลียร์ประวัติหน้าจอทั้งหมดแล้วพาไปหน้า LoginPage
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              });
            },
          ),
          // 📌 เพิ่มปุ่มไอคอนฟันเฟืองสำหรับเปิดหน้าตั้งค่า (Settings)
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'ตั้งค่าแอปพลิเคชัน',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          // ปุ่มแก้ไขข้อมูลส่วนตัวเดิม
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'แก้ไขข้อมูลส่วนตัว',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileInputScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            OutfitCard(
              title: 'จัดการตู้เสื้อผ้า',
              subtitle: 'เพิ่ม/ลบ เสื้อผ้าในระบบ',
              icon: Icons.checkroom,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WardrobeScreen()),
              ),
            ),
            const SizedBox(height: 12),
            OutfitCard(
              title: 'ดูชุดแนะนำ',
              subtitle: 'แมทช์ชุดตามสรีระและสีผิวของคุณ',
              icon: Icons.style,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileInputScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}