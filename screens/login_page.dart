import 'package:flutter/material.dart';
import '../services/authentication_service.dart';
import 'home.dart'; // หรือหน้าแรกหลักของโปรเจกต์คุณ

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าสู่ระบบ'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 48),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 48),
              
              // ช่องกรอกอีเมล
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'อีเมล',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              
              // ช่องกรอกรหัสผ่าน
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'รหัสผ่าน',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              
              // ปุ่ม Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isLoading ? null : () async {
                    setState(() => _isLoading = true);
                    bool success = await AuthenticationService().login(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
                    setState(() => _isLoading = false);

                    if (success) {
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const HomeScreen()), // เปลี่ยนเป็นหน้าหลักโปรเจกต์คุณ
                        );
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('เข้าสู่ระบบล้มเหลว กรุณาตรวจสอบข้อมูล')),
                        );
                      }
                    }
                  },
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16),

              // ปุ่มสมัครสมาชิก (Register)
              TextButton(
                onPressed: () async {
                  bool success = await AuthenticationService().register(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(success ? 'ลงทะเบียนสำเร็จ! กรุณาเข้าสู่ระบบ' : 'ลงทะเบียนไม่สำเร็จ')),
                    );
                  }
                },
                child: const Text('ลงทะเบียนบัญชีใหม่', style: TextStyle(color: Colors.deepPurple)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}