import 'package:flutter/material.dart';
import 'services/school_state.dart';
import 'theme/app_theme.dart';
import 'widgets/sidebar_nav.dart';
import 'widgets/top_nav_bar.dart';
import 'screens/dashboard_screen.dart';
import 'screens/students_screen.dart';
import 'screens/teachers_screen.dart';
import 'screens/classes_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/gradebook_screen.dart';
import 'screens/fees_screen.dart';
import 'screens/timetable_screen.dart';
import 'screens/notices_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const EduPulseSchoolApp());
}

class EduPulseSchoolApp extends StatefulWidget {
  const EduPulseSchoolApp({super.key});

  @override
  State<EduPulseSchoolApp> createState() => _EduPulseSchoolAppState();
}

class _EduPulseSchoolAppState extends State<EduPulseSchoolApp> {
  final SchoolState _schoolState = SchoolState();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _schoolState,
      builder: (context, _) {
        return MaterialApp(
          title: 'EduPulse - School Management System',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: _schoolState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: MainLayoutScreen(state: _schoolState),
        );
      },
    );
  }
}

class MainLayoutScreen extends StatefulWidget {
  final SchoolState state;

  const MainLayoutScreen({super.key, required this.state});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  bool _isSidebarCollapsed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _getBottomNavIndex(int navIndex) {
    if (navIndex == 0) return 0;
    if (navIndex == 1) return 1;
    if (navIndex == 4) return 2;
    if (navIndex == 5) return 3;
    return 4; // highlights "More" for other modules
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile
          ? Drawer(
              child: SidebarNav(
                state: widget.state,
                isCollapsed: false,
                onToggleCollapse: () {
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: _getBottomNavIndex(widget.state.selectedNavIndex),
              onDestinationSelected: (idx) {
                if (idx == 0) {
                  widget.state.setNavIndex(0);
                } else if (idx == 1) {
                  widget.state.setNavIndex(1);
                } else if (idx == 2) {
                  widget.state.setNavIndex(4);
                } else if (idx == 3) {
                  widget.state.setNavIndex(5);
                } else if (idx == 4) {
                  _scaffoldKey.currentState?.openDrawer();
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.school_outlined),
                  selectedIcon: Icon(Icons.school),
                  label: 'Students',
                ),
                NavigationDestination(
                  icon: Icon(Icons.fingerprint),
                  selectedIcon: Icon(Icons.fingerprint, color: AppColors.primary),
                  label: 'Biometrics',
                ),
                NavigationDestination(
                  icon: Icon(Icons.assignment_outlined),
                  selectedIcon: Icon(Icons.assignment),
                  label: 'Grades',
                ),
                NavigationDestination(
                  icon: Icon(Icons.menu),
                  selectedIcon: Icon(Icons.menu_open),
                  label: 'Menu',
                ),
              ],
            )
          : null,
      body: Row(
        children: [
          // Desktop & Tablet Persistent Sidebar
          if (!isMobile)
            SidebarNav(
              state: widget.state,
              isCollapsed: _isSidebarCollapsed,
              onToggleCollapse: () {
                setState(() {
                  _isSidebarCollapsed = !_isSidebarCollapsed;
                });
              },
            ),

          // Main Screen Content Area
          Expanded(
            child: Column(
              children: [
                TopNavBar(
                  state: widget.state,
                  onMenuToggle: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                Expanded(
                  child: _buildCurrentScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (widget.state.selectedNavIndex) {
      case 0:
        return DashboardScreen(state: widget.state);
      case 1:
        return StudentsScreen(state: widget.state);
      case 2:
        return TeachersScreen(state: widget.state);
      case 3:
        return ClassesScreen(state: widget.state);
      case 4:
        return AttendanceScreen(state: widget.state);
      case 5:
        return GradebookScreen(state: widget.state);
      case 6:
        return FeesScreen(state: widget.state);
      case 7:
        return TimetableScreen(state: widget.state);
      case 8:
        return NoticesScreen(state: widget.state);
      case 9:
        return SettingsScreen(state: widget.state);
      default:
        return DashboardScreen(state: widget.state);
    }
  }
}
