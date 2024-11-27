import 'package:flutter/material.dart';

class FounderEditProfilePage extends StatefulWidget {
  final String email;
  const FounderEditProfilePage(this.email, {super.key});

  @override
  State<FounderEditProfilePage> createState() => _FounderEditProfilePageState();
}

class _FounderEditProfilePageState extends State<FounderEditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.email),
      ),
    );
  }
}
