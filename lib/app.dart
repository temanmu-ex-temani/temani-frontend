import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:temani_frontend/features/counseling/presentation/pages/counseling_page.dart';
import 'services/router_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/features/main/presentation/pages/home_page.dart';
import 'package:temani_frontend/features/main/presentation/pages/peer_home_page.dart';
import 'package:temani_frontend/features/main/presentation/pages/caregiver_home_page.dart';
import 'package:temani_frontend/features/activity/presentation/pages/activity_page.dart';
import 'package:temani_frontend/features/relationship/presentation/pages/relationship_page.dart';
import 'package:temani_frontend/features/profile/presentation/pages/profile_page.dart';
import 'package:temani_frontend/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:temani_frontend/features/relationship/presentation/cubit/relationship_cubit.dart';
import 'package:temani_frontend/features/main/presentation/cubit/upcoming_sessions_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temani_frontend/services/depedencies/di.dart';
import 'package:temani_frontend/services/shared_preference_service.dart';
import 'package:temani_frontend/core/constants/_constants.dart';

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
  bool _isPeer = false;
  bool _isCaregiver = false;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  void _checkUserRole() {
    final roles = SharedPreferencesService.getStringList(PreferencesKeys.roles);
    setState(() {
      // Prioritize CLIENT role - if user has CLIENT role, show CLIENT UI
      // even if they also have PEER or CAREGIVER role
      if (roles != null && 
          (roles.contains('CLIENT') || roles.contains('ROLE_CLIENT'))) {
        _isPeer = false;
        _isCaregiver = false;
      } else if (roles != null &&
          (roles.contains('PEER') || roles.contains('ROLE_PEER'))) {
        _isPeer = true;
        _isCaregiver = false;
      } else if (roles != null &&
          (roles.contains('CAREGIVER') || roles.contains('ROLE_CAREGIVER'))) {
        _isPeer = false;
        _isCaregiver = true;
      } else {
        // Default to CLIENT if no roles found
        _isPeer = false;
        _isCaregiver = false;
      }
    });
  }

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
    
    // Refresh homepage when it becomes visible (index 0 for CLIENT, index 0 for PEER)
    if (index == 0) {
      // Refresh upcoming sessions on homepage
      try {
        final upcomingSessionsCubit = get<UpcomingSessionsCubit>();
        upcomingSessionsCubit.loadUpcomingSessions();
      } catch (e) {
        // Ignore if cubit not available
      }
    }
  }

  Widget _buildPage(int index) {
    if (_isPeer) {
      // PEER role: Beranda, Relasi, and Profile
      switch (index) {
        case 0:
          return const PeerHomePage(key: ValueKey('peer_home'));
        case 1:
          return BlocProvider(
            create: (context) => get<RelationshipCubit>(),
            child: const RelationshipPage(key: ValueKey('relationship')),
          );
        case 2:
          return MultiBlocProvider(
            key: const ValueKey('profile'),
            providers: [
              BlocProvider(create: (context) => get<ProfileCubit>()),
              BlocProvider(create: (context) => get<RelationshipCubit>()),
            ],
            child: const ProfilePage(),
          );
        default:
          return const SizedBox.shrink();
      }
    } else if (_isCaregiver) {
      // CAREGIVER role: Beranda, Relasi, and Profile
      switch (index) {
        case 0:
          return const CaregiverHomePage(key: ValueKey('caregiver_home'));
        case 1:
          return BlocProvider(
            create: (context) => get<RelationshipCubit>(),
            child: const RelationshipPage(key: ValueKey('relationship')),
          );
        case 2:
          return MultiBlocProvider(
            key: const ValueKey('profile'),
            providers: [
              BlocProvider(create: (context) => get<ProfileCubit>()),
              BlocProvider(create: (context) => get<RelationshipCubit>()),
            ],
            child: const ProfilePage(),
          );
        default:
          return const SizedBox.shrink();
      }
    } else {
      // CLIENT role: All pages including Relationships
      switch (index) {
        case 0:
          return const HomePage(key: ValueKey('home'));
        case 1:
          return const ActivityPage(key: ValueKey('activity'));
        case 2:
          return const CounselingPage(key: ValueKey('counseling'));
        case 3:
          return BlocProvider(
            create: (context) => get<RelationshipCubit>(),
            child: const RelationshipPage(key: ValueKey('relationship')),
          );
        case 4:
          return MultiBlocProvider(
            key: const ValueKey('profile'),
            providers: [
              BlocProvider(create: (context) => get<ProfileCubit>()),
              BlocProvider(create: (context) => get<RelationshipCubit>()),
            ],
            child: const ProfilePage(),
          );
        default:
          return const SizedBox.shrink();
      }
    }
  }

  int get _pageCount {
    if (_isPeer || _isCaregiver) {
      return 3; // Beranda, Relasi, Profile
    }
    return 5; // Beranda, Aktivitas, Konseling, Relasi, Profile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: _pageCount,
        itemBuilder: (context, index) => _buildPage(index),
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
              children: (_isPeer || _isCaregiver)
                  ? [
                      // PEER or CAREGIVER role: Beranda, Relasi, and Profile
                      _NavBarItem(
                        icon: PhosphorIcons.house(),
                        label: 'Beranda',
                        selected: _selectedIndex == 0,
                        onTap: () => _onTabTapped(0),
                        selectedColor: Color(0xFF5B8CFF),
                      ),
                      _NavBarItem(
                        icon: PhosphorIcons.users(),
                        label: 'Relasi',
                        selected: _selectedIndex == 1,
                        onTap: () => _onTabTapped(1),
                        selectedColor: Color(0xFF9CA3AF),
                      ),
                      _NavBarItem(
                        icon: PhosphorIcons.user(),
                        label: 'Profil',
                        selected: _selectedIndex == 2,
                        onTap: () => _onTabTapped(2),
                        selectedColor: Color(0xFF9CA3AF),
                      ),
                    ]
                  : [
                      // CLIENT role: All navigation items including Relationships
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
                        icon: PhosphorIcons.users(),
                        label: 'Relasi',
                        selected: _selectedIndex == 3,
                        onTap: () => _onTabTapped(3),
                        selectedColor: Color(0xFF9CA3AF),
                      ),
                      _NavBarItem(
                        icon: PhosphorIcons.user(),
                        label: 'Profil',
                        selected: _selectedIndex == 4,
                        onTap: () => _onTabTapped(4),
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
