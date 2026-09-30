// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // 📌 1. นำเข้าไฟล์ firebase_options.dart
import 'providers/settings_provider.dart';
import 'screens/login_page.dart'; // 📌 2. นำเข้าหน้า Login เพื่อกำหนดเป็นหน้าแรก

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ 3. เชื่อมต่อ Firebase โดยดึงค่าอัตโนมัติผ่าน DefaultFirebaseOptions.currentPlatform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // โหลดค่าการตั้งค่าที่บันทึกไว้ในเครื่อง
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ดึงค่าการตั้งค่ามาใช้งานแบบ Real-time
    final settings = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'Travel Outfit Planner',
      debugShowCheckedModeBanner: false,
      
      // กำหนด Theme ธีมมืด/สว่าง
      theme: ThemeData(
        brightness: settings.isDarkMode ? Brightness.dark : Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: settings.isDarkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: settings.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      ),
      
      // ควบคุมขนาดตัวหนังสือทั้งแอปตามสเกลที่ผู้ใช้เลือก
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(settings.fontSizeScale),
          ),
          child: child!,
        );
      },
      // 📌 4. กำหนดหน้าแรกสุดของแอปให้เป็นหน้า Login
      home: const LoginPage(),
    );
  }
}