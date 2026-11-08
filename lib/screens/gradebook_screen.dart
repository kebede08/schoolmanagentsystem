import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../models/grade.dart';
import '../models/student.dart';
import '../theme/app_theme.dart';

class GradebookScreen extends StatefulWidget {
  final SchoolState state;

  const GradebookScreen({super.key, required this.state});

  @override
  State<GradebookScreen> createState() => _GradebookScreenState();
}

class _GradebookScreenState extends State<GradebookScreen> {
  String _selectedTerm = 'Midterm';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = widget.state.grades.where((g) => g.term == _selectedTerm).toList();
    final avgScore = filtered.isNotEmpty
        ? filtered.fold(0.0, (s, g) => s + g.score) / filtered.length
        : 0.0;
    final topScore = filtered.isNotEmpty
        ? filtered.map((g) => g.score).reduce((a, b) => a > b ? a : b)
        : 0.0;
    final passRate = filtered.isNotEmpty
        ? (filtered.where((g) => g.score >= 60).length / filtered.length) * 100
        : 100.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 750;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Examinations & Gradebook',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Academic performance, GPA, and report cards.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.description_outlined, size: 16),
                  label: const Text('Report Card', style: TextStyle(fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _showSelectReportCardDialog(context),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Score', style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _showAddGradeDialog(context),
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
                      'Examinations & Gradebook',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Evaluate academic performance, calculate GPA, and generate official report cards.',
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
                      icon: const Icon(Icons.description_outlined, size: 18),
                      label: const Text('Generate Report Card'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _showSelectReportCardDialog(context),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Score'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _showAddGradeDialog(context),
                    ),
                  ],
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // Term Selector & Performance Overview (Responsive Wrap)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 8,
                children: ['Term 1', 'Midterm', 'Final'].map((term) {
                  final isSelected = _selectedTerm == term;
                  return FilterChip(
                    label: Text(term),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _selectedTerm = term);
                    },
                    backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                    selectedColor: AppColors.primary.withOpacity(0.18),
                    labelStyle: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  );
                }).toList(),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _metricPill('Class Average', '${avgScore.toStringAsFixed(1)} pts', AppColors.primary),
                  _metricPill('Top Score', '${topScore.toStringAsFixed(1)} pts', AppColors.success),
                  _metricPill('Pass Rate', '${passRate.toStringAsFixed(0)}%', AppColors.secondary),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Grade Table
          Expanded(
            child: Card(
              child: filtered.isEmpty
                  ? const Center(child: Text('No grades recorded for this term.'))
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
                            DataColumn(label: Text('Subject')),
                            DataColumn(label: Text('Score')),
                            DataColumn(label: Text('Percentage')),
                            DataColumn(label: Text('Grade')),
                            DataColumn(label: Text('GPA')),
                            DataColumn(label: Text('Teacher Remarks')),
                            DataColumn(label: Text('Report')),
                          ],
                          rows: filtered.map((record) {
                            return DataRow(
                              cells: [
                                DataCell(Text(record.rollNumber, style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Text(record.studentName, style: const TextStyle(fontWeight: FontWeight.w600))),
                                DataCell(Text(record.subject)),
                                DataCell(
                                  Text(
                                    '${record.score.toStringAsFixed(1)} / ${record.maxScore.toStringAsFixed(0)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 44,
                                        child: Text('${record.percentage.toStringAsFixed(1)}%'),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: record.percentage / 100,
                                            minHeight: 5,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              record.percentage >= 80 ? AppColors.success : AppColors.primary,
                                            ),
                                            backgroundColor: isDark ? Colors.white10 : Colors.black12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: record.percentage >= 80
                                          ? AppColors.success.withOpacity(0.15)
                                          : AppColors.primary.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      record.letterGrade,
                                      style: TextStyle(
                                        color: record.percentage >= 80 ? AppColors.success : AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(record.gpa.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(
                                  Text(
                                    record.comments.isEmpty ? '—' : record.comments,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.print_outlined, size: 18, color: AppColors.primary),
                                        tooltip: 'View Official Report Card',
                                        onPressed: () {
                                          final student = widget.state.students.firstWhere(
                                            (s) => s.name == record.studentName,
                                            orElse: () => Student(
                                              id: record.studentId,
                                              name: record.studentName,
                                              rollNumber: record.rollNumber,
                                              grade: record.grade,
                                              section: 'A',
                                              email: '',
                                              phone: '',
                                              guardianName: 'Guardian',
                                              guardianPhone: '',
                                              gender: 'N/A',
                                              dateOfBirth: DateTime(2009, 1, 1),
                                            ),
                                          );
                                          _showOfficialReportCard(context, student);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                                        tooltip: 'Delete Score Entry',
                                        onPressed: () {
                                          widget.state.deleteGrade(record.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Score for ${record.studentName} (${record.subject}) deleted.')),
                                          );
                                        },
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

  Widget _metricPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  void _showSelectReportCardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.assignment_ind, color: AppColors.primary),
            SizedBox(width: 10),
            Text('Select Student for Report Card'),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.state.students.map((student) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Text(student.name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                ),
                title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('Roll: ${student.rollNumber} • Grade ${student.grade}-${student.section}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  _showOfficialReportCard(context, student);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showOfficialReportCard(BuildContext context, Student student) {
    final studentGrades = widget.state.grades
        .where((g) => g.studentName == student.name && g.term == _selectedTerm)
        .toList();

    // Fallback sample subjects if specific term grades aren't recorded yet
    final subjects = studentGrades.isNotEmpty
        ? studentGrades
        : [
            GradeRecord(id: '1', studentId: student.id, studentName: student.name, rollNumber: student.rollNumber, grade: student.grade, subject: 'Mathematics', term: _selectedTerm, score: 92.0, comments: 'Excellent calculus and logical reasoning'),
            GradeRecord(id: '2', studentId: student.id, studentName: student.name, rollNumber: student.rollNumber, grade: student.grade, subject: 'Physics', term: _selectedTerm, score: 88.5, comments: 'Solid laboratory work and theory grasp'),
            GradeRecord(id: '3', studentId: student.id, studentName: student.name, rollNumber: student.rollNumber, grade: student.grade, subject: 'English Literature', term: _selectedTerm, score: 91.0, comments: 'Superb writing and presentation style'),
            GradeRecord(id: '4', studentId: student.id, studentName: student.name, rollNumber: student.rollNumber, grade: student.grade, subject: 'Computer Science', term: _selectedTerm, score: 96.0, comments: 'High aptitude in algorithm development'),
          ];

    final totalScore = subjects.fold(0.0, (s, g) => s + g.score);
    final maxTotal = subjects.fold(0.0, (s, g) => s + g.maxScore);
    final overallPct = maxTotal > 0 ? (totalScore / maxTotal) * 100 : 0.0;
    final overallGpa = subjects.fold(0.0, (s, g) => s + g.gpa) / subjects.length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 680,
          padding: const EdgeInsets.all(28),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Report Card Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.school, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.state.schoolName.toUpperCase(),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                            Text(
                              widget.state.schoolAddress,
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'OFFICIAL REPORT CARD\n${_selectedTerm.toUpperCase()} • ${widget.state.academicSession}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32, thickness: 1.5),

                // Student Meta Details Row
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _studentInfoItem('Student Name', student.name),
                      _studentInfoItem('Roll Number', student.rollNumber),
                      _studentInfoItem('Grade & Section', 'Grade ${student.grade}-${student.section}'),
                      _studentInfoItem('Attendance', '${student.attendanceRate}%'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Text('Academic Evaluation Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),

                // Subject Results Table
                Table(
                  border: TableBorder.all(color: Colors.black12, borderRadius: BorderRadius.circular(8)),
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1.5),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(1.2),
                    4: FlexColumnWidth(1.2),
                    5: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08)),
                      children: const [
                        Padding(padding: EdgeInsets.all(8), child: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        Padding(padding: EdgeInsets.all(8), child: Text('Max', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        Padding(padding: EdgeInsets.all(8), child: Text('Score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        Padding(padding: EdgeInsets.all(8), child: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        Padding(padding: EdgeInsets.all(8), child: Text('GPA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        Padding(padding: EdgeInsets.all(8), child: Text('Remarks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      ],
                    ),
                    ...subjects.map((s) {
                      return TableRow(
                        children: [
                          Padding(padding: const EdgeInsets.all(8), child: Text(s.subject, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                          Padding(padding: const EdgeInsets.all(8), child: Text('${s.maxScore.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
                          Padding(padding: const EdgeInsets.all(8), child: Text('${s.score.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          Padding(padding: const EdgeInsets.all(8), child: Text(s.letterGrade, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12))),
                          Padding(padding: const EdgeInsets.all(8), child: Text(s.gpa.toStringAsFixed(1), style: const TextStyle(fontSize: 12))),
                          Padding(padding: const EdgeInsets.all(8), child: Text(s.comments.isEmpty ? 'Satisfactory' : s.comments, style: const TextStyle(fontSize: 11, color: Colors.grey))),
                        ],
                      );
                    }).toList(),
                  ],
                ),

                const SizedBox(height: 18),

                // Overall Cumulative Summary Bar
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _summaryStat('Total Marks', '${totalScore.toStringAsFixed(0)} / ${maxTotal.toStringAsFixed(0)}'),
                      _summaryStat('Overall %', '${overallPct.toStringAsFixed(1)}%'),
                      _summaryStat('Term GPA', overallGpa.toStringAsFixed(2)),
                      _summaryStat('Result', 'PROMOTED / PASS', color: AppColors.success),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Official Signatures
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _signatureBox('Class Teacher Signature', 'Prof. Eleanor Hughes'),
                    _signatureBox('Principal / Head of School', widget.state.principalName),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.print, size: 16),
            label: const Text('Print Official Report'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Report card for ${student.name} dispatched to printer/PDF export.'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _studentInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _summaryStat(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color ?? AppColors.primary)),
      ],
    );
  }

  Widget _signatureBox(String title, String signatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 180,
          height: 1,
          color: Colors.grey,
        ),
        const SizedBox(height: 6),
        Text(signatory, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  void _showAddGradeDialog(BuildContext context) {
    final studentCtrl = TextEditingController(text: 'Alexander Wright');
    final rollCtrl = TextEditingController(text: '10-A-01');
    final subjCtrl = TextEditingController(text: 'Mathematics');
    final scoreCtrl = TextEditingController();
    final commentsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Record Assessment Score', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: studentCtrl, decoration: const InputDecoration(labelText: 'Student Name *')),
              const SizedBox(height: 12),
              TextField(controller: rollCtrl, decoration: const InputDecoration(labelText: 'Roll Number')),
              const SizedBox(height: 12),
              TextField(controller: subjCtrl, decoration: const InputDecoration(labelText: 'Subject *')),
              const SizedBox(height: 12),
              TextField(
                controller: scoreCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Score (out of 100) *'),
              ),
              const SizedBox(height: 12),
              TextField(controller: commentsCtrl, decoration: const InputDecoration(labelText: 'Teacher Comments / Feedback')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              final scoreVal = double.tryParse(scoreCtrl.text.trim()) ?? 0.0;
              if (studentCtrl.text.isNotEmpty && subjCtrl.text.isNotEmpty) {
                final newGrade = GradeRecord(
                  id: 'GRD${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                  studentId: 'STD-CUSTOM',
                  studentName: studentCtrl.text.trim(),
                  rollNumber: rollCtrl.text.trim(),
                  grade: '10',
                  subject: subjCtrl.text.trim(),
                  term: _selectedTerm,
                  score: scoreVal,
                  comments: commentsCtrl.text.trim(),
                );
                widget.state.addGrade(newGrade);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Score'),
          ),
        ],
      ),
    );
  }
}
