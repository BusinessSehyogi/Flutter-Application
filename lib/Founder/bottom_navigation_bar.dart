import 'package:business_sehyogi/Founder/add_post.dart';
import 'package:business_sehyogi/Founder/explore_page.dart';
import 'package:business_sehyogi/Founder/home_page.dart';
import 'package:business_sehyogi/Founder/notification_page.dart';
import 'package:business_sehyogi/Founder/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class FounderBottomNavigationBar extends StatefulWidget {
  const FounderBottomNavigationBar({super.key});

  @override
  State<FounderBottomNavigationBar> createState() =>
      _FounderBottomNavigationBarState();
}

class _FounderBottomNavigationBarState
    extends State<FounderBottomNavigationBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  // Define the screens for each tab
  List<Widget> _buildScreens() {
    return [
      const FounderHomePage(),
      const FounderExplorePage(),
      const FounderAddPost(),
      const FounderNotificationPage(),
      const FounderProfilePage(),
    ];
  }

  // Define the navigation bar items
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home_outlined,
          size: MediaQuery.of(context).size.height * 0.035,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
        title: "Home",

      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.explore_outlined,
          size: MediaQuery.of(context).size.height * 0.035,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
        title: "Explore",
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.add,
          color: Colors.white,
          size: MediaQuery.of(context).size.height * 0.035,
        ),
        // activeColorSecondary: Colors.white,
        activeColorPrimary: const Color(0xFF272E5E),
        inactiveColorPrimary: Colors.grey,
        title: "Add",
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.notifications_outlined,
          size: MediaQuery.of(context).size.height * 0.035,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
        title: "Notifications",
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.person_outline,
          size: MediaQuery.of(context).size.height * 0.035,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
        title: "Profile",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: const Color(0xFF211C40),
      // Navigation bar background color
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: MediaQuery.of(context).size.height * 0.09,
      navBarStyle: NavBarStyle.style16, // Style of the navigation bar
    );
  }
}
