import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart"; // แก้ไขให้ถูกต้องโดยใช้ underscore และไม่มีช่องว่าง

class AddOutfitRecordScreen extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? currentData;

  const AddOutfitRecordScreen({Key? key, this.docId, this.currentData}) : super(key: key);

  @override
  State<AddOutfitRecordScreen> createState() => _AddOutfitRecordScreenState();
}

class _AddOutfitRecordScreenState extends State<AddOutfitRecordScreen> {
  final _monthController = TextEditingController();
  final _styleController = TextEditingController();
  final _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ถ้าเป็นการกดแก้ไข นำข้อมูลเดิมมาใส่ในช่องกรอก
    if (widget.currentData != null) {
      _monthController.text = widget.currentData!['month'] ?? '';
      _styleController.text = widget.currentData!['style'] ?? '';
      _detailsController.text = widget.currentData!['details'] ?? '';
    }
  }

  Future<void> _saveData() async {
    if (_monthController.text.isEmpty || _styleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

    final data = {
      'month': _monthController.text,
      'style': _styleController.text,
      'details': _detailsController.text,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (widget.docId == null) {
      // เพิ่มข้อมูลใหม่ (Add) ลง Firestore
      await FirebaseFirestore.instance.collection('outfit_records').add(data);
    } else {
      // แก้ไขข้อมูลเดิม (Edit) ใน Firestore
      await FirebaseFirestore.instance.collection('outfit_records').doc(widget.docId).update(data);
    }
    
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.docId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Outfit Entry' : 'Add Outfit Entry'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _monthController,
              decoration: const InputDecoration(
                labelText: 'Month / โอกาส (เช่น September 2026)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _styleController,
              decoration: const InputDecoration(
                labelText: 'สไตล์การแต่งตัว (เช่น Streetwear, Minimalist)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(
                labelText: 'รายละเอียดไอเทม / โน้ตเพิ่มเติม',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _saveData,
              child: const Text('Save / Submit', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}