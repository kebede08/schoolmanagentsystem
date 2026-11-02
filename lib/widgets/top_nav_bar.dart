import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../theme/app_theme.dart';

class TopNavBar extends StatelessWidget {
  final SchoolState state;
  final VoidCallback onMenuToggle;

  const TopNavBar({
    super.key,
    required this.state,
    required this.onMenuToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuToggle,
              tooltip: 'Toggle Navigation',
            ),
          // Search box (Desktop & Tablet)
          if (!isMobile)
            SizedBox(
              width: 320,
              height: 42,
              child: TextField(
                onChanged: (val) => state.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Search students, faculty, classes...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: isDark ? AppColors.darkBg : const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          const Spacer(),

          // Role Switcher Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBg : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state.currentRole,
                icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                borderRadius: BorderRadius.circular(10),
                dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                items: ['Admin', 'Teacher', 'Student', 'Parent'].map((role) {
                  IconData icon;
                  switch (role) {
                    case 'Admin':
                      icon = Icons.admin_panel_settings_outlined;
                      break;
                    case 'Teacher':
                      icon = Icons.school_outlined;
                      break;
                    case 'Student':
                      icon = Icons.person_outline;
                      break;
                    default:
                      icon = Icons.family_restroom_outlined;
                  }
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Role: $role',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newRole) {
                  if (newRole != null) state.setRole(newRole);
                },
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Theme Toggle
          IconButton(
            icon: Icon(
              state.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 22,
            ),
            tooltip: state.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () => state.toggleDarkMode(),
          ),
          const SizedBox(width: 8),

          // Notification Bell
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, size: 22),
                tooltip: 'Announcements & Alerts',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('3 new school notices posted today'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // User Profile
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Text(
                  state.currentRole[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.currentRole == 'Admin'
                          ? 'Dr. Sarah Sterling'
                          : state.currentRole == 'Teacher'
                              ? 'Dr. Marcus Vance'
                              : 'Alexander Wright',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    Text(
                      state.currentRole,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

