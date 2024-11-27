import 'package:business_sehyogi/Founder/home_page.dart';
import 'package:business_sehyogi/Founder/profile_page.dart';
import 'package:flutter/material.dart';

class FounderBottomNavigationBar extends StatefulWidget {
  const FounderBottomNavigationBar({super.key});

  @override
  State<FounderBottomNavigationBar> createState() => _FounderBottomNavigationBarState();
}

class _FounderBottomNavigationBarState extends State<FounderBottomNavigationBar> {
  int selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const Scaffold(
      backgroundColor: Colors.white,
      body: FounderHomePage(),
    ),
    const Scaffold(
      backgroundColor: Colors.white,
      body: FounderProfilePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color(0xFF211C40),
          indicatorColor: Colors.white, // For the selected icon background effect
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              color: Colors.white, // Set label color to white
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined, color: Colors.white),
              label: "Home",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline, color: Colors.white),
              label: "Profile",
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
    );
  }
}
