import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../models/class_model.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';

class ClassesScreen extends StatelessWidget {
  final SchoolState state;

  const ClassesScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    'Classes & Room Allocations',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Monitor classroom capacity, subject curriculum, and assigned homeroom teachers.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Class Section'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _showAddClassDialog(context),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Cards Grid
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 950 ? 2 : 1;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: state.classes.length,
                  itemBuilder: (context, index) {
                    final cls = state.classes[index];
                    final pct = cls.currentEnrolled / cls.capacity;

                    return Card(
                      child: InkWell(
                        onTap: () => _showClassRosterDialog(context, cls),
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.meeting_room,
                                          color: AppColors.primary,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cls.displayName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? AppColors.darkText : AppColors.lightText,
                                            ),
                                          ),
                                          Text(
                                            cls.roomNumber,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: pct >= 0.95
                                          ? AppColors.danger.withOpacity(0.12)
                                          : AppColors.success.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      pct >= 0.95 ? 'Near Capacity' : 'Available',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: pct >= 0.95 ? AppColors.danger : AppColors.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  const Icon(Icons.person_pin, size: 16, color: AppColors.secondary),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Class Mentor: ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                  Text(
                                    cls.classTeacherName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // Capacity bar
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Enrollment Capacity',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        ),
                                      ),
                                      Text(
                                        '${cls.currentEnrolled} / ${cls.capacity} (${(pct * 100).toStringAsFixed(0)}%)',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: pct,
                                      minHeight: 8,
                                      backgroundColor: isDark ? Colors.white10 : Colors.black12,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        pct > 0.9 ? AppColors.warning : AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              // Subjects Tag Row & Roster Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: cls.subjects.take(4).map((s) {
                                        return Chip(
                                          label: Text(s, style: const TextStyle(fontSize: 11)),
                                          padding: EdgeInsets.zero,
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF1F5F9),
                                          side: BorderSide.none,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.people, size: 16),
                                    label: const Text('View Roster'),
                                    onPressed: () => _showClassRosterDialog(context, cls),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

  void _showClassRosterDialog(BuildContext context, SchoolClass cls) {
    final students = state.students
        .where((s) => s.grade == cls.grade && s.section == cls.section)
        .toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.class_outlined, color: AppColors.primary),
            const SizedBox(width: 10),
            Text('${cls.displayName} Student Roster (${students.length} Enrolled)'),
          ],
        ),
        content: SizedBox(
          width: 550,
          height: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mentor: ${cls.classTeacherName} • ${cls.roomNumber}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const Divider(height: 20),
              Expanded(
                child: students.isEmpty
                    ? const Center(child: Text('No students currently enrolled in this section.'))
                    : ListView.separated(
                        itemCount: students.length,
                        separatorBuilder: (c, i) => const Divider(height: 12),
                        itemBuilder: (c, index) {
                          final s = students[index];
                          return ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.primary.withOpacity(0.15),
                              child: Text(s.name[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                            ),
                            title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            subtitle: Text('Roll: ${s.rollNumber} • Attendance: ${s.attendanceRate}% • Guardian: ${s.guardianName}'),
                            trailing: StatusBadge.generic(s.status, isSuccess: s.status == 'Active'),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showAddClassDialog(BuildContext context) {
    final gradeCtrl = TextEditingController(text: '10');
    final secCtrl = TextEditingController(text: 'C');
    final roomCtrl = TextEditingController(text: 'Room 303 (East Wing)');
    final teacherCtrl = TextEditingController(text: 'Dr. Marcus Vance');
    final capCtrl = TextEditingController(text: '35');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Class Section', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: TextField(controller: gradeCtrl, decoration: const InputDecoration(labelText: 'Grade Level *'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: secCtrl, decoration: const InputDecoration(labelText: 'Section *'))),
                ],
              ),
              const SizedBox(height: 12),
              TextField(controller: roomCtrl, decoration: const InputDecoration(labelText: 'Room Number *')),
              const SizedBox(height: 12),
              TextField(controller: teacherCtrl, decoration: const InputDecoration(labelText: 'Class Teacher Name *')),
              const SizedBox(height: 12),
              TextField(controller: capCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Student Capacity *')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              if (gradeCtrl.text.isNotEmpty && secCtrl.text.isNotEmpty) {
                final cap = int.tryParse(capCtrl.text.trim()) ?? 30;
                final newCls = SchoolClass(
                  id: 'CLS-${gradeCtrl.text.trim()}${secCtrl.text.trim()}',
                  grade: gradeCtrl.text.trim(),
                  section: secCtrl.text.trim(),
                  roomNumber: roomCtrl.text.trim(),
                  classTeacherId: 'TCH001',
                  classTeacherName: teacherCtrl.text.trim(),
                  capacity: cap,
                  currentEnrolled: 0,
                  subjects: ['Mathematics', 'Physics', 'English', 'Computer Science'],
                );
                state.addClass(newCls);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Section Grade ${newCls.grade}-${newCls.section} added successfully.'), backgroundColor: AppColors.success),
                );
              }
            },
            child: const Text('Create Section'),
          ),
        ],
      ),
    );
  }
}
