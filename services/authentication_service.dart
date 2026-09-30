import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // ตัวแปรเก็บชื่ออีเมลผู้ใช้งานปัจจุบัน
  static String userName = '';

  // ฟังก์ชันเข้าสู่ระบบ
  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      userName = email;
      return userCredential.user != null;
    } catch (e) {
      // พริ้นต์รายละเอียด Error ทั้งหมดออกมาดูใน Debug Console เพื่อเช็กสาเหตุที่แท้จริง
      print("📌 LOGIN ERROR: ${e.toString()}"); 
      return false;
    }
  }

  // ฟังก์ชันสมัครสมาชิก
  Future<bool> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      print("📌 REGISTER ERROR: ${e.toString()}"); 
      return false;
    }
  }

  // ฟังก์ชันออกจากระบบ
  Future<void> logout() async {
    await _auth.signOut();
    userName = '';
  }

  // ตรวจสอบว่าล็อกอินอยู่หรือไม่
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }
}
