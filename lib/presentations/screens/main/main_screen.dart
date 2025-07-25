import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:wedstra_mobile_app/presentations/screens/vendors/vendor_display.dart';
import '../../widgets/Navigation_tabs/home_tab.dart';
import '../../widgets/Navigation_tabs/profile_tab.dart';
import '../../widgets/Navigation_tabs/tasks.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const VendorDisplay(),
    const TasksTab(),
    const ProfileTab(),
  ];

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFFCB0033),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home_2), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.shop_add),
            label: "Vendors",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.clipboard_tick),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.more_square),
            label: "More",
          ),
        ],
      ),
    );
  }
}
