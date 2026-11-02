import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../models/grade.dart';
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

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    'Evaluate academic performance, calculate GPA, and record exam marks.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
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

          const SizedBox(height: 20),

          // Term Selector & Performance Overview
          Row(
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
              const Spacer(),
              _metricPill('Class Average', '${avgScore.toStringAsFixed(1)} pts', AppColors.primary),
              const SizedBox(width: 10),
              _metricPill('Top Score', '${topScore.toStringAsFixed(1)} pts', AppColors.success),
              const SizedBox(width: 10),
              _metricPill('Pass Rate', '${passRate.toStringAsFixed(0)}%', AppColors.secondary),
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

