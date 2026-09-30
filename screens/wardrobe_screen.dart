import 'package:flutter/material.dart';
import '../models/clothing_item.dart';
import '../services/local_storage.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  List<ClothingItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final items = await LocalStorageService.loadWardrobe();
    setState(() => _items = items);
  }

  Future<void> _addItem() async {
    final newItem = ClothingItem(
      id: DateTime.now().toString(),
      name: 'เสื้อยืด Oversize ขาว',
      category: 'เสื้อ',
      colorTone: 'โทนสว่าง',
    );
    _items.add(newItem);
    await LocalStorageService.saveWardrobe(_items);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ตู้เสื้อผ้าของฉัน'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            leading: const Icon(Icons.checkroom, color: Colors.teal),
            title: Text(item.name),
            subtitle: Text('หมวด: ${item.category} | โทนสี: ${item.colorTone}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                _items.removeAt(index);
                await LocalStorageService.saveWardrobe(_items);
                setState(() {});
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: _addItem,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}