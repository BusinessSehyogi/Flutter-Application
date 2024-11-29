// ignore_for_file: use_build_context_synchronously

import 'package:business_sehyogi/Common/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FounderSettingsPage extends StatefulWidget {
  const FounderSettingsPage({super.key});

  @override
  State<FounderSettingsPage> createState() => _FounderSettingsPageState();
}

class _FounderSettingsPageState extends State<FounderSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.exit_to_app),
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear();
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        },
      ),
    );
  }
}
