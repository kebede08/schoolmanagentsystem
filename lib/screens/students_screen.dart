import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../models/student.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';

class StudentsScreen extends StatefulWidget {
  final SchoolState state;

  const StudentsScreen({super.key, required this.state});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String _selectedGradeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter students
    final filtered = widget.state.students.where((s) {
      final matchesGrade = _selectedGradeFilter == 'All' || s.grade == _selectedGradeFilter;
      final q = widget.state.searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          s.name.toLowerCase().contains(q) ||
          s.rollNumber.toLowerCase().contains(q) ||
          s.email.toLowerCase().contains(q) ||
          s.guardianName.toLowerCase().contains(q);
      return matchesGrade && matchesSearch;
    }).toList();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 750;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Adaptive)
          if (isMobile) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student Directory',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage admissions and student profiles.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Student'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _showAddStudentDialog(context),
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Directory',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage admissions, academic records, and student profiles.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Student'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _showAddStudentDialog(context),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // Grade Filter Tabs
          Row(
            children: ['All', '10', '11', '12'].map((g) {
              final isSelected = _selectedGradeFilter == g;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(g == 'All' ? 'All Grades' : 'Grade $g'),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      _selectedGradeFilter = g;
                    });
                  },
                  backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                  selectedColor: AppColors.primary.withOpacity(0.18),
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Students Data Table Card
          Expanded(
            child: Card(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 48, color: isDark ? Colors.white24 : Colors.black26),
                          const SizedBox(height: 12),
                          const Text('No students match the criteria'),
                        ],
                      ),
                    )
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
                            DataColumn(label: Text('Student Name')),
                            DataColumn(label: Text('Roll No.')),
                            DataColumn(label: Text('Grade & Sec')),
                            DataColumn(label: Text('Guardian Contact')),
                            DataColumn(label: Text('Attendance')),
                            DataColumn(label: Text('Fee Balance')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: filtered.map((student) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: AppColors.primary.withOpacity(0.15),
                                        child: Text(
                                          student.name.isNotEmpty ? student.name[0] : 'S',
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            student.email,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(Text(student.rollNumber, style: const TextStyle(fontWeight: FontWeight.w500))),
                                DataCell(Text('Grade ${student.grade}-${student.section}')),
                                DataCell(
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(student.guardianName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                      Text(
                                        student.guardianPhone,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 44,
                                        child: Text('${student.attendanceRate.toStringAsFixed(1)}%'),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: student.attendanceRate / 100,
                                            minHeight: 5,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              student.attendanceRate >= 90 ? AppColors.success : AppColors.warning,
                                            ),
                                            backgroundColor: isDark ? Colors.white10 : Colors.black12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  student.feeBalance == 0
                                      ? StatusBadge.generic('Cleared', isSuccess: true)
                                      : Text(
                                          '\$${student.feeBalance.toStringAsFixed(0)} Due',
                                          style: const TextStyle(
                                            color: AppColors.danger,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                ),
                                DataCell(
                                  StatusBadge.generic(
                                    student.status,
                                    isSuccess: student.status == 'Active',
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.visibility_outlined, size: 18),
                                        tooltip: 'View Profile',
                                        onPressed: () => _showStudentDetails(context, student),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                                        tooltip: 'Edit Student Details',
                                        onPressed: () => _showEditStudentDialog(context, student),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                                        tooltip: 'Remove Student',
                                        onPressed: () => widget.state.deleteStudent(student.id),
                                      ),
                                    ],
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

  void _showStudentDetails(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary,
              child: Text(student.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Roll No: ${student.rollNumber} • Grade ${student.grade}-${student.section}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        content: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Email', student.email),
              _detailRow('Student Phone', student.phone),
              _detailRow('Guardian Name', student.guardianName),
              _detailRow('Guardian Phone', student.guardianPhone),
              _detailRow('Gender', student.gender),
              _detailRow('Date of Birth', '${student.dateOfBirth.year}-${student.dateOfBirth.month}-${student.dateOfBirth.day}'),
              _detailRow('Attendance Rate', '${student.attendanceRate}%'),
              _detailRow('Outstanding Balance', '\$${student.feeBalance}'),
              _detailRow('Status', student.status),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showEditStudentDialog(BuildContext context, Student student) {
    final nameCtrl = TextEditingController(text: student.name);
    final rollCtrl = TextEditingController(text: student.rollNumber);
    final gradeCtrl = TextEditingController(text: student.grade);
    final sectionCtrl = TextEditingController(text: student.section);
    final emailCtrl = TextEditingController(text: student.email);
    final phoneCtrl = TextEditingController(text: student.phone);
    final guardianCtrl = TextEditingController(text: student.guardianName);
    final guardianPhoneCtrl = TextEditingController(text: student.guardianPhone);
    String status = student.status;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Edit Student: ${student.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name *')),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: rollCtrl, decoration: const InputDecoration(labelText: 'Roll Number *'))),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(controller: gradeCtrl, decoration: const InputDecoration(labelText: 'Grade'))),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(controller: sectionCtrl, decoration: const InputDecoration(labelText: 'Section'))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Student Email')),
                  const SizedBox(height: 12),
                  TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Student Phone')),
                  const SizedBox(height: 12),
                  TextField(controller: guardianCtrl, decoration: const InputDecoration(labelText: 'Guardian Name')),
                  const SizedBox(height: 12),
                  TextField(controller: guardianPhoneCtrl, decoration: const InputDecoration(labelText: 'Guardian Phone')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Enrollment Status'),
                    items: ['Active', 'On Leave', 'Graduated'].map((s) {
                      return DropdownMenuItem(value: s, child: Text(s));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => status = val);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && rollCtrl.text.isNotEmpty) {
                  final updated = student.copyWith(
                    name: nameCtrl.text.trim(),
                    rollNumber: rollCtrl.text.trim(),
                    grade: gradeCtrl.text.trim(),
                    section: sectionCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    guardianName: guardianCtrl.text.trim(),
                    guardianPhone: guardianPhoneCtrl.text.trim(),
                    status: status,
                  );
                  widget.state.updateStudent(updated);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Student profile for ${updated.name} updated successfully.'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final rollCtrl = TextEditingController();
    final gradeCtrl = TextEditingController(text: '10');
    final sectionCtrl = TextEditingController(text: 'A');
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final guardianCtrl = TextEditingController();
    final guardianPhoneCtrl = TextEditingController();
    String gender = 'Male';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Enroll New Student', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name *')),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: rollCtrl, decoration: const InputDecoration(labelText: 'Roll Number *'))),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(controller: gradeCtrl, decoration: const InputDecoration(labelText: 'Grade (e.g. 10)'))),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(controller: sectionCtrl, decoration: const InputDecoration(labelText: 'Section (A/B)'))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Student Email')),
                  const SizedBox(height: 12),
                  TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Student Phone')),
                  const SizedBox(height: 12),
                  TextField(controller: guardianCtrl, decoration: const InputDecoration(labelText: 'Guardian Name *')),
                  const SizedBox(height: 12),
                  TextField(controller: guardianPhoneCtrl, decoration: const InputDecoration(labelText: 'Guardian Phone *')),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && rollCtrl.text.isNotEmpty) {
                  final newStudent = Student(
                    id: 'STD${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                    name: nameCtrl.text.trim(),
                    rollNumber: rollCtrl.text.trim(),
                    grade: gradeCtrl.text.trim(),
                    section: sectionCtrl.text.trim(),
                    email: emailCtrl.text.trim().isEmpty ? '${nameCtrl.text.toLowerCase().replaceAll(' ', '.')}@edupulse.edu' : emailCtrl.text.trim(),
                    phone: phoneCtrl.text.trim().isEmpty ? '+1 (555) 000-0000' : phoneCtrl.text.trim(),
                    guardianName: guardianCtrl.text.trim().isEmpty ? 'Parent' : guardianCtrl.text.trim(),
                    guardianPhone: guardianPhoneCtrl.text.trim().isEmpty ? '+1 (555) 000-0001' : guardianPhoneCtrl.text.trim(),
                    gender: gender,
                    dateOfBirth: DateTime(2009, 1, 1),
                  );
                  widget.state.addStudent(newStudent);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save & Enroll'),
            ),
          ],
        ),
      ),
    );
  }
}

