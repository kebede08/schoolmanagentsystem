import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../models/teacher.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';

class TeachersScreen extends StatefulWidget {
  final SchoolState state;

  const TeachersScreen({super.key, required this.state});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  String _selectedDept = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = widget.state.teachers.where((t) {
      final matchesDept = _selectedDept == 'All' || t.department == _selectedDept;
      final q = widget.state.searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          t.name.toLowerCase().contains(q) ||
          t.subject.toLowerCase().contains(q) ||
          t.department.toLowerCase().contains(q) ||
          t.employeeId.toLowerCase().contains(q);
      return matchesDept && matchesSearch;
    }).toList();

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
                    'Faculty & Staff Directory',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage instructors, department assignments, and class allocations.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add_alt, size: 18),
                label: const Text('Add Faculty'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _showAddTeacherDialog(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Department Filters
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['All', 'Science & STEM', 'Mathematics', 'Humanities & English', 'Computer Science', 'Social Sciences'].map((dept) {
              final isSelected = _selectedDept == dept;
              return FilterChip(
                label: Text(dept),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    _selectedDept = dept;
                  });
                },
                backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                selectedColor: AppColors.primary.withOpacity(0.18),
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Teachers Cards Grid
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 1100
                    ? 3
                    : constraints.maxWidth > 700
                        ? 2
                        : 1;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.35,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final teacher = filtered[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.secondary.withOpacity(0.15),
                                  child: Text(
                                    teacher.name[0],
                                    style: const TextStyle(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        teacher.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: isDark ? AppColors.darkText : AppColors.lightText,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        teacher.department,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        teacher.employeeId,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                StatusBadge.generic(teacher.status, isSuccess: teacher.status == 'Active'),
                              ],
                            ),
                            const Divider(height: 24),
                            Text(
                              'Specialization: ${teacher.subject}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkText : AppColors.lightText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              teacher.qualification,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: teacher.assignedClasses.map((c) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkBg : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    c,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.mail_outline, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      teacher.email,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                                      tooltip: 'Edit Faculty Info',
                                      onPressed: () => _showEditTeacherDialog(context, teacher),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                                      tooltip: 'Delete',
                                      onPressed: () => widget.state.deleteTeacher(teacher.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditTeacherDialog(BuildContext context, Teacher teacher) {
    final nameCtrl = TextEditingController(text: teacher.name);
    final empCtrl = TextEditingController(text: teacher.employeeId);
    final deptCtrl = TextEditingController(text: teacher.department);
    final subjCtrl = TextEditingController(text: teacher.subject);
    final qualCtrl = TextEditingController(text: teacher.qualification);
    final emailCtrl = TextEditingController(text: teacher.email);
    final phoneCtrl = TextEditingController(text: teacher.phone);
    String status = teacher.status;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Edit Faculty: ${teacher.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name *')),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: empCtrl, decoration: const InputDecoration(labelText: 'Employee ID'))),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(controller: deptCtrl, decoration: const InputDecoration(labelText: 'Department'))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: subjCtrl, decoration: const InputDecoration(labelText: 'Subject Specialization *')),
                  const SizedBox(height: 12),
                  TextField(controller: qualCtrl, decoration: const InputDecoration(labelText: 'Qualification *')),
                  const SizedBox(height: 12),
                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Work Email')),
                  const SizedBox(height: 12),
                  TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Faculty Status'),
                    items: ['Active', 'On Leave'].map((s) {
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
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && subjCtrl.text.isNotEmpty) {
                  final updated = teacher.copyWith(
                    name: nameCtrl.text.trim(),
                    employeeId: empCtrl.text.trim(),
                    department: deptCtrl.text.trim(),
                    subject: subjCtrl.text.trim(),
                    qualification: qualCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    status: status,
                  );
                  widget.state.updateTeacher(updated);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Faculty profile for ${updated.name} updated successfully.'),
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

  void _showAddTeacherDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final empCtrl = TextEditingController(text: 'EMP-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}');
    final deptCtrl = TextEditingController(text: 'Science & STEM');
    final subjCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final qualCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Faculty Member', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 450,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name *')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextField(controller: empCtrl, decoration: const InputDecoration(labelText: 'Employee ID'))),
                    const SizedBox(width: 12),
                    Expanded(child: TextField(controller: deptCtrl, decoration: const InputDecoration(labelText: 'Department'))),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(controller: subjCtrl, decoration: const InputDecoration(labelText: 'Subject Specialization *')),
                const SizedBox(height: 12),
                TextField(controller: qualCtrl, decoration: const InputDecoration(labelText: 'Qualification (e.g. M.Sc, Ph.D) *')),
                const SizedBox(height: 12),
                TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Work Email')),
                const SizedBox(height: 12),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && subjCtrl.text.isNotEmpty) {
                final newTeacher = Teacher(
                  id: 'TCH${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                  name: nameCtrl.text.trim(),
                  employeeId: empCtrl.text.trim(),
                  department: deptCtrl.text.trim(),
                  subject: subjCtrl.text.trim(),
                  qualification: qualCtrl.text.trim().isEmpty ? 'B.Ed / M.A.' : qualCtrl.text.trim(),
                  email: emailCtrl.text.trim().isEmpty ? '${nameCtrl.text.toLowerCase().replaceAll(' ', '.')}@edupulse.edu' : emailCtrl.text.trim(),
                  phone: phoneCtrl.text.trim().isEmpty ? '+1 (555) 000-0000' : phoneCtrl.text.trim(),
                  assignedClasses: ['Grade 10-A', 'Grade 11-A'],
                );
                widget.state.addTeacher(newTeacher);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add Member'),
          ),
        ],
      ),
    );
  }
}

