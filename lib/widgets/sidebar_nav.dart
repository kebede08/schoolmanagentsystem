import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../theme/app_theme.dart';

class SidebarNav extends StatelessWidget {
  final SchoolState state;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  const SidebarNav({
    super.key,
    required this.state,
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final navItems = [
      {'icon': Icons.dashboard_outlined, 'activeIcon': Icons.dashboard, 'title': 'Dashboard'},
      {'icon': Icons.people_alt_outlined, 'activeIcon': Icons.people_alt, 'title': 'Students'},
      {'icon': Icons.badge_outlined, 'activeIcon': Icons.badge, 'title': 'Teachers & Staff'},
      {'icon': Icons.meeting_room_outlined, 'activeIcon': Icons.meeting_room, 'title': 'Classes & Rooms'},
      {'icon': Icons.fact_check_outlined, 'activeIcon': Icons.fact_check, 'title': 'Attendance'},
      {'icon': Icons.grade_outlined, 'activeIcon': Icons.grade, 'title': 'Gradebook'},
      {'icon': Icons.receipt_long_outlined, 'activeIcon': Icons.receipt_long, 'title': 'Fees & Invoices'},
      {'icon': Icons.calendar_month_outlined, 'activeIcon': Icons.calendar_month, 'title': 'Timetable'},
      {'icon': Icons.campaign_outlined, 'activeIcon': Icons.campaign, 'title': 'Notices'},
      {'icon': Icons.settings_outlined, 'activeIcon': Icons.settings, 'title': 'Settings'},
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isCollapsed ? 75 : 260,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : const Color(0xFF0F172A),
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFF1E293B),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header / Logo
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EduPulse',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          'School Portal',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(color: Color(0xFF1E293B), height: 1),

          // Academic Session Pill
          if (!isCollapsed)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Color(0xFF38BDF8)),
                    SizedBox(width: 8),
                    Text(
                      'Session: 2026-2027',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE2E8F0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Navigation Links
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: navItems.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = state.selectedNavIndex == index;

                return InkWell(
                  onTap: () => state.setNavIndex(index),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCollapsed ? 12 : 14,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: [
                        Icon(
                          isSelected ? (item['activeIcon'] as IconData) : (item['icon'] as IconData),
                          size: 20,
                          color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                        ),
                        if (!isCollapsed) ...[
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              item['title'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Collapse Sidebar Button
          const Divider(color: Color(0xFF1E293B), height: 1),
          ListTile(
            onTap: onToggleCollapse,
            leading: Icon(
              isCollapsed ? Icons.chevron_right : Icons.chevron_left,
              color: const Color(0xFF94A3B8),
            ),
            title: isCollapsed
                ? null
                : const Text(
                    'Collapse Sidebar',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

