import 'package:business_sehyogi/Founder/add_post.dart';
import 'package:business_sehyogi/Founder/explore_page.dart';
import 'package:business_sehyogi/Founder/home_page.dart';
import 'package:business_sehyogi/Founder/notification_page.dart';
import 'package:business_sehyogi/Founder/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
      body: FounderExplorePage(),
    ),
    const Scaffold(
      backgroundColor: Colors.white,
      body: FounderNotificationPage(),
    ),
    const Scaffold(
      backgroundColor: Colors.white,
      body: FounderAddPost(),
    ),
    const Scaffold(
      backgroundColor: Colors.white,
      body: FounderProfilePage(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: const Color(0xFF211C40),
          animationDuration: const Duration(milliseconds: 500),
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            _buildIcon(Icons.home, 0),
            _buildIcon(Icons.explore, 1),
            _buildIcon(Icons.add, 2),
            _buildIcon(Icons.notifications, 3),
            _buildIcon(Icons.person, 4),
          ],
          index: selectedIndex, // Use 'index' instead of 'currentIndex'
        ),
      ),
    );
  }
  Widget _buildIcon(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}