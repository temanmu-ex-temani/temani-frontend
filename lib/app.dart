import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:temani_frontend/features/counseling/presentation/pages/chat_page.dart';
import 'package:temani_frontend/features/counseling/presentation/pages/counseling_page.dart';
import 'services/router_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/features/main/presentation/pages/home_page.dart';
import 'package:temani_frontend/features/activity/presentation/pages/activity_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp.router(
      theme: ThemeData(fontFamily: 'Poppins'),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ActivityPage(),
    CounselingPage(),
    Center(
      child: Text('Profil', style: TextStyle(fontSize: 24, color: Colors.grey)),
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
        physics: const BouncingScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: PhosphorIcons.house(),
                  label: 'Beranda',
                  selected: _selectedIndex == 0,
                  onTap: () => _onTabTapped(0),
                  selectedColor: Color(0xFF5B8CFF),
                ),
                _NavBarItem(
                  icon: PhosphorIcons.listBullets(),
                  label: 'Aktivitas',
                  selected: _selectedIndex == 1,
                  onTap: () => _onTabTapped(1),
                  selectedColor: Color(0xFF9CA3AF),
                ),
                _NavBarItem(
                  icon: PhosphorIcons.chatCenteredText(),
                  label: 'Konseling',
                  selected: _selectedIndex == 2,
                  onTap: () => _onTabTapped(2),
                  selectedColor: Color(0xFF9CA3AF),
                ),
                _NavBarItem(
                  icon: PhosphorIcons.user(),
                  label: 'Profil',
                  selected: _selectedIndex == 3,
                  onTap: () => _onTabTapped(3),
                  selectedColor: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Color(0xFF5B8CFF);
    final Color inactiveColor = Color(0xFF9CA3AF);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? activeColor : inactiveColor, size: 28),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: selected ? activeColor : inactiveColor,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
