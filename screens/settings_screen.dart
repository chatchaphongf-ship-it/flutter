import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:styleapp/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่า (Settings)'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. ขนาดตัวหนังสือ (Font Size)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text(
                'Font Size (ขนาดตัวหนังสือ)',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              trailing: ToggleButtons(
                isSelected: [settings.fontSizeScale == 1.0, settings.fontSizeScale == 1.3],
                onPressed: (index) {
                  settings.setFontSizeScale(index == 0 ? 1.0 : 1.3);
                },
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Small')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Large')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. ธีมมืด / สว่าง (Dark Mode)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SwitchListTile(
              secondary: Icon(
                settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).iconTheme.color,
              ),
              title: const Text(
                'Dark Mode (โหมดมืด)',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              value: settings.isDarkMode,
              onChanged: (val) {
                settings.toggleDarkMode(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}