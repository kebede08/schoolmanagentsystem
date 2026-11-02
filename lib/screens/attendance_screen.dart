import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../models/attendance.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';

class AttendanceScreen extends StatefulWidget {
  final SchoolState state;

  const AttendanceScreen({super.key, required this.state});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedGrade = '10';
  String _selectedSection = 'A';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final records = widget.state.attendance.where((a) {
      return a.grade == _selectedGrade && a.section == _selectedSection;
    }).toList();

    final presentCount = records.where((r) => r.status == AttendanceStatus.present).length;
    final lateCount = records.where((r) => r.status == AttendanceStatus.late).length;
    final absentCount = records.where((r) => r.status == AttendanceStatus.absent).length;
    final excusedCount = records.where((r) => r.status == AttendanceStatus.excused).length;
    final totalCount = records.length;
    final attendanceRate = totalCount > 0 ? ((presentCount + lateCount) / totalCount) * 100 : 0.0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Attendance Register',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Record, verify, and report daily student presence in real-time.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.done_all, size: 18),
                label: const Text('Mark All Present'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  widget.state.markAllPresent(_selectedGrade, _selectedSection);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('All students in Grade $_selectedGrade-$_selectedSection marked Present'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Controls & Filters Bar
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  // Date Picker Button
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2026, 1, 1),
                        lastDate: DateTime(2027, 12, 31),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Grade Selector
                  DropdownButtonHideUnderline(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedGrade,
                        items: ['10', '11', '12'].map((g) {
                          return DropdownMenuItem(value: g, child: Text('Grade $g'));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedGrade = val);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Section Selector
                  DropdownButtonHideUnderline(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedSection,
                        items: ['A', 'B'].map((s) {
                          return DropdownMenuItem(value: s, child: Text('Section $s'));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedSection = val);
                        },
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Quick Stats Badges
                  _summaryPill('Present: $presentCount', AppColors.success),
                  const SizedBox(width: 8),
                  _summaryPill('Late: $lateCount', AppColors.warning),
                  const SizedBox(width: 8),
                  _summaryPill('Absent: $absentCount', AppColors.danger),
                  const SizedBox(width: 8),
                  _summaryPill('Excused: $excusedCount', AppColors.secondary),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Rate: ${attendanceRate.toStringAsFixed(1)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Attendance Table
          Expanded(
            child: Card(
              child: records.isEmpty
                  ? const Center(child: Text('No attendance records found for selected class.'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 28,
                          horizontalMargin: 20,
                          headingRowHeight: 48,
                          dataRowMinHeight: 64,
                          dataRowMaxHeight: 64,
                          columns: const [
                            DataColumn(label: Text('Roll No.')),
                            DataColumn(label: Text('Student Name')),
                            DataColumn(label: Text('Status Toggle')),
                            DataColumn(label: Text('Current Status')),
                            DataColumn(label: Text('Remarks / Note')),
                          ],
                          rows: records.map((record) {
                            return DataRow(
                              cells: [
                                DataCell(Text(record.rollNumber, style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.primary.withOpacity(0.12),
                                        child: Text(
                                          record.studentName[0],
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(record.studentName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      _statusButton(record, AttendanceStatus.present, 'P', AppColors.success),
                                      const SizedBox(width: 6),
                                      _statusButton(record, AttendanceStatus.late, 'L', AppColors.warning),
                                      const SizedBox(width: 6),
                                      _statusButton(record, AttendanceStatus.absent, 'A', AppColors.danger),
                                      const SizedBox(width: 6),
                                      _statusButton(record, AttendanceStatus.excused, 'E', AppColors.secondary),
                                    ],
                                  ),
                                ),
                                DataCell(StatusBadge.attendance(record.status)),
                                DataCell(
                                  Text(
                                    record.remarks.isEmpty ? '—' : record.remarks,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12),
      ),
    );
  }

  Widget _statusButton(AttendanceRecord record, AttendanceStatus status, String label, Color color) {
    final isSelected = record.status == status;
    return InkWell(
      onTap: () {
        widget.state.markAttendance(record.id, status);
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
