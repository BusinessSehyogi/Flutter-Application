import 'dart:convert';

import 'package:business_sehyogi/Common/login.dart';
import 'package:business_sehyogi/Founder/bottom_navigation_bar.dart';
import 'package:business_sehyogi/Investor/home_page.dart';
import 'package:business_sehyogi/SharePreferences/saveSharePreferences.dart';
import 'package:business_sehyogi/ipAddress.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String data = "";
  final key = 'Email';
  final key1 = 'Category';
  late bool containsKey;
  late bool containsKey1;
  late String keyToCheck;
  var page;

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 7));
    await _checkIfLoggedIn();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Future<void> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    containsKey = prefs.containsKey(key);
    containsKey1 = prefs.containsKey(key1);

    if (containsKey) {
      keyToCheck = (await getData("Email"))!;

      var url = "http://$IP/getUser/$keyToCheck";

      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        var responseData = jsonDecode(response.body);

        if (responseData["visible"]) {
          if (responseData["category"] == "Founder") {
            page = const FounderBottomNavigationBar();
          } else {
            page = const InvestorHomePage();
          }
        } else {
          prefs.remove("key");
          prefs.remove("Category");
        }
      } else {
        prefs.remove("key");
        prefs.remove("Category");
        page = const LoginPage();
      }
      return;
    } else {
      page = const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2a446b),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/GIF/logo-gif.gif"),
          ],
        ),
      ),
    );
  }
}
