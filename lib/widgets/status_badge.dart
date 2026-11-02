import 'package:flutter/material.dart';
import '../models/attendance.dart';
import '../models/fee.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  factory StatusBadge.attendance(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return const StatusBadge(
          label: 'Present',
          backgroundColor: Color(0xFFDCFCE7),
          textColor: Color(0xFF166534),
          icon: Icons.check_circle_outline,
        );
      case AttendanceStatus.late:
        return const StatusBadge(
          label: 'Late',
          backgroundColor: Color(0xFFFEF3C7),
          textColor: Color(0xFF92400E),
          icon: Icons.access_time,
        );
      case AttendanceStatus.absent:
        return const StatusBadge(
          label: 'Absent',
          backgroundColor: Color(0xFFFEE2E2),
          textColor: Color(0xFF991B1B),
          icon: Icons.cancel_outlined,
        );
      case AttendanceStatus.excused:
        return const StatusBadge(
          label: 'Excused',
          backgroundColor: Color(0xFFE0E7FF),
          textColor: Color(0xFF3730A3),
          icon: Icons.info_outline,
        );
    }
  }

  factory StatusBadge.fee(FeeStatus status) {
    switch (status) {
      case FeeStatus.paid:
        return const StatusBadge(
          label: 'Paid',
          backgroundColor: Color(0xFFDCFCE7),
          textColor: Color(0xFF166534),
          icon: Icons.verified_outlined,
        );
      case FeeStatus.pending:
        return const StatusBadge(
          label: 'Pending',
          backgroundColor: Color(0xFFFEF3C7),
          textColor: Color(0xFF92400E),
          icon: Icons.hourglass_top,
        );
      case FeeStatus.overdue:
        return const StatusBadge(
          label: 'Overdue',
          backgroundColor: Color(0xFFFEE2E2),
          textColor: Color(0xFF991B1B),
          icon: Icons.warning_amber_rounded,
        );
    }
  }

  factory StatusBadge.generic(String text, {bool isSuccess = true}) {
    if (isSuccess) {
      return StatusBadge(
        label: text,
        backgroundColor: const Color(0xFFDCFCE7),
        textColor: const Color(0xFF166534),
      );
    } else {
      return StatusBadge(
        label: text,
        backgroundColor: const Color(0xFFF1F5F9),
        textColor: const Color(0xFF475569),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
