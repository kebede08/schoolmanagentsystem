import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../models/fee.dart';
import '../models/notice.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/custom_chart.dart';

class DashboardScreen extends StatelessWidget {
  final SchoolState state;

  const DashboardScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header & Quick Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${state.currentRole}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Here is what is happening across EduPulse Academy today.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 10,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.fact_check_outlined, size: 16),
                    label: const Text('Take Attendance'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => state.setNavIndex(4), // Attendance
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person_add_alt_1, size: 16),
                    label: const Text('Enroll Student'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => state.setNavIndex(1), // Students
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Stat Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1100
                  ? 4
                  : constraints.maxWidth > 650
                      ? 2
                      : 1;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.8,
                children: [
                  StatCard(
                    title: 'TOTAL ENROLLED',
                    value: '${state.totalStudentsCount}',
                    subtitle: 'Active across all grades',
                    icon: Icons.school,
                    iconColor: AppColors.primary,
                    trendText: '+12% this term',
                    isTrendPositive: true,
                  ),
                  StatCard(
                    title: 'FACULTY & STAFF',
                    value: '${state.totalTeachersCount}',
                    subtitle: '100% certified educators',
                    icon: Icons.people_outline,
                    iconColor: AppColors.secondary,
                    trendText: '5 Departments',
                    isTrendPositive: true,
                  ),
                  StatCard(
                    title: "TODAY'S ATTENDANCE",
                    value: '${state.attendanceRateToday.toStringAsFixed(1)}%',
                    subtitle: '32 students marked today',
                    icon: Icons.how_to_reg,
                    iconColor: AppColors.success,
                    trendText: '+1.4% vs last week',
                    isTrendPositive: true,
                  ),
                  StatCard(
                    title: 'FEES COLLECTED',
                    value: '\$${(state.totalFeesCollected / 1000).toStringAsFixed(1)}k',
                    subtitle: '${state.feeCollectionPercentage.toStringAsFixed(0)}% of billed total',
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.warning,
                    trendText: '\$${state.totalFeesPending.toStringAsFixed(0)} pending',
                    isTrendPositive: false,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Charts Row
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: WeeklyAttendanceBarChart(
                        weeklyRates: const [94.5, 96.2, 98.0, 95.8, 97.4],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: FeeCollectionDonutChart(
                        collected: state.totalFeesCollected,
                        pending: state.invoices.where((i) => i.status == FeeStatus.pending).fold(0.0, (s, i) => s + (i.amount - i.paidAmount)),
                        overdue: state.invoices.where((i) => i.status == FeeStatus.overdue).fold(0.0, (s, i) => s + (i.amount - i.paidAmount)),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: WeeklyAttendanceBarChart(
                  weeklyRates: const [94.5, 96.2, 98.0, 95.8, 97.4],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: FeeCollectionDonutChart(
                  collected: state.totalFeesCollected,
                  pending: state.invoices.where((i) => i.status == FeeStatus.pending).fold(0.0, (s, i) => s + (i.amount - i.paidAmount)),
                  overdue: state.invoices.where((i) => i.status == FeeStatus.overdue).fold(0.0, (s, i) => s + (i.amount - i.paidAmount)),
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Recent Activities & Bulletins Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recent Announcements
              Expanded(
                flex: 3,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Announcements & Bulletins',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkText : AppColors.lightText,
                              ),
                            ),
                            TextButton(
                              onPressed: () => state.setNavIndex(8),
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.notices.take(3).length,
                          separatorBuilder: (ctx, i) => const Divider(height: 24),
                          itemBuilder: (ctx, index) {
                            final notice = state.notices[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: notice.priority == NoticePriority.urgent
                                            ? AppColors.danger.withOpacity(0.12)
                                            : notice.priority == NoticePriority.high
                                                ? AppColors.warning.withOpacity(0.12)
                                                : AppColors.primary.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        notice.priority.name.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: notice.priority == NoticePriority.urgent
                                              ? AppColors.danger
                                              : notice.priority == NoticePriority.high
                                                  ? AppColors.warning
                                                  : AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        notice.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? AppColors.darkText : AppColors.lightText,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '${notice.publishedDate.month}/${notice.publishedDate.day}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  notice.content,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (isDesktop) ...[
                const SizedBox(width: 20),
                // Quick Class Room Status
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Class Enrollment & Capacity',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...state.classes.map((cls) {
                            final pct = cls.currentEnrolled / cls.capacity;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        cls.displayName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? AppColors.darkText : AppColors.lightText,
                                        ),
                                      ),
                                      Text(
                                        '${cls.currentEnrolled} / ${cls.capacity}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: pct,
                                      minHeight: 7,
                                      backgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        pct > 0.9 ? AppColors.warning : AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
