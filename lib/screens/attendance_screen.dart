import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../models/attendance.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';
import '../widgets/biometric_attendance_dialog.dart';

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

  void _openBiometricKiosk(BuildContext context, AttendanceRecord? record, [BiometricMode mode = BiometricMode.fingerprint]) {
    showDialog(
      context: context,
      builder: (ctx) => BiometricAttendanceDialog(
        state: widget.state,
        grade: _selectedGrade,
        section: _selectedSection,
        preselectedRecord: record,
        initialMode: mode,
      ),
    );
  }

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

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Adaptive for Web and Android)
          if (isMobile) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Attendance & Biometrics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fingerprint, AI Face Recognition, and Pattern Lock.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.fingerprint, size: 18),
                  label: const Text(
                    'Biometric Kiosk',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _openBiometricKiosk(context, null),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.done_all, size: 18),
                  label: const Text('Mark All Present', style: TextStyle(fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.success,
                    side: const BorderSide(color: AppColors.success, width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Attendance & Biometric Register',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Multi-modal check-in via Optical Fingerprint, AI Face Recognition, and Security Pattern.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 12,
                  children: [
                    // Biometric Kiosk Launch Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.fingerprint, size: 20),
                      label: const Text(
                        'Biometric Kiosk (Finger • Face • Pattern)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _openBiometricKiosk(context, null),
                    ),

                    // Batch Mark All Present
                    OutlinedButton.icon(
                      icon: const Icon(Icons.done_all, size: 18),
                      label: const Text('Mark All Present'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.success,
                        side: const BorderSide(color: AppColors.success, width: 1.5),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              ],
            ),
          ],

          const SizedBox(height: 20),

          // Controls & Filters Bar (Responsive Wrap for Mobile & Web)
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Wrap(
                spacing: 12,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
                            mainAxisSize: MainAxisSize.min,
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

                      const SizedBox(width: 10),

                      // Grade Selector
                      DropdownButtonHideUnderline(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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

                      const SizedBox(width: 8),

                      // Section Selector
                      DropdownButtonHideUnderline(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedSection,
                            items: ['A', 'B'].map((s) {
                              return DropdownMenuItem(value: s, child: Text('Sec $s'));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedSection = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Quick Stats Badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _summaryPill('Present: $presentCount', AppColors.success),
                      _summaryPill('Late: $lateCount', AppColors.warning),
                      _summaryPill('Absent: $absentCount', AppColors.danger),
                      _summaryPill('Excused: $excusedCount', AppColors.secondary),
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
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Attendance Table with Biometric Verification Column
          Expanded(
            child: Card(
              child: records.isEmpty
                  ? const Center(child: Text('No attendance records found for selected class.'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 24,
                          horizontalMargin: 20,
                          headingRowHeight: 48,
                          dataRowMinHeight: 64,
                          dataRowMaxHeight: 64,
                          columns: const [
                            DataColumn(label: Text('Roll No.')),
                            DataColumn(label: Text('Student Name')),
                            DataColumn(label: Text('Biometric Scan')),
                            DataColumn(label: Text('Manual Override')),
                            DataColumn(label: Text('Status')),
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
                                // Biometric Instant Scan Triggers
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.fingerprint, size: 22, color: AppColors.primary),
                                        tooltip: 'Scan Fingerprint (${record.studentName})',
                                        onPressed: () => _openBiometricKiosk(context, record, BiometricMode.fingerprint),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.face_retouching_natural, size: 21, color: Colors.cyan),
                                        tooltip: 'Scan Face Recognition (${record.studentName})',
                                        onPressed: () => _openBiometricKiosk(context, record, BiometricMode.faceRecognition),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.grid_3x3, size: 20, color: AppColors.secondary),
                                        tooltip: 'Verify Pattern (${record.studentName})',
                                        onPressed: () => _openBiometricKiosk(context, record, BiometricMode.patternLock),
                                      ),
                                    ],
                                  ),
                                ),
                                // Manual Status Toggle
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
        width: 30,
        height: 30,
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
