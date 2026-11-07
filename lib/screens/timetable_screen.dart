import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../models/timetable.dart';
import '../theme/app_theme.dart';

class TimetableScreen extends StatefulWidget {
  final SchoolState state;

  const TimetableScreen({super.key, required this.state});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String _selectedDay = 'Monday';
  String _selectedGrade = '10';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final schedule = widget.state.weeklySchedule.firstWhere(
      (d) => d.dayOfWeek == _selectedDay,
      orElse: () => widget.state.weeklySchedule.first,
    );

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
                    'Class Timetable & Schedule',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Master daily period schedules, subject timeslots, and room allocations.',
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
                  // Grade level dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      borderRadius: BorderRadius.circular(10),
                      color: isDark ? AppColors.darkCard : Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGrade,
                        items: ['10', '11', '12'].map((g) {
                          return DropdownMenuItem(value: g, child: Text('Grade $g Schedule'));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedGrade = val);
                        },
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Period'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _showAddPeriodDialog(context, schedule),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Day of Week Tabs
          Row(
            children: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].map((day) {
              final isSelected = _selectedDay == day;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(day),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedDay = day);
                  },
                  backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Schedule Cards List
          Expanded(
            child: ListView.separated(
              itemCount: schedule.periods.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final p = schedule.periods[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        // Period Number Badge
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'P${p.periodNumber}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),

                        // Time Range
                        SizedBox(
                          width: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('TIME SLOT', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(p.timeRange, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            ],
                          ),
                        ),

                        // Subject
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('SUBJECT', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(p.subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                        ),

                        // Teacher
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline, size: 16, color: AppColors.secondary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(p.teacher, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ),

                        // Room
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBg : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(p.room, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPeriodDialog(BuildContext context, DaySchedule schedule) {
    final numCtrl = TextEditingController(text: '${schedule.periods.length + 1}');
    final timeCtrl = TextEditingController(text: '02:35 - 03:20');
    final subjCtrl = TextEditingController();
    final teacherCtrl = TextEditingController();
    final roomCtrl = TextEditingController(text: 'Room 301');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Period Slot (${schedule.dayOfWeek})'),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: TextField(controller: numCtrl, decoration: const InputDecoration(labelText: 'Period #'))),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: 'Time Range (e.g. 02:35 - 03:20)'))),
                ],
              ),
              const SizedBox(height: 12),
              TextField(controller: subjCtrl, decoration: const InputDecoration(labelText: 'Subject Name *')),
              const SizedBox(height: 12),
              TextField(controller: teacherCtrl, decoration: const InputDecoration(labelText: 'Teacher / Instructor *')),
              const SizedBox(height: 12),
              TextField(controller: roomCtrl, decoration: const InputDecoration(labelText: 'Classroom / Lab *')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              if (subjCtrl.text.isNotEmpty && teacherCtrl.text.isNotEmpty) {
                final pNum = int.tryParse(numCtrl.text.trim()) ?? (schedule.periods.length + 1);
                setState(() {
                  schedule.periods.add(
                    PeriodSlot(
                      periodNumber: pNum,
                      timeRange: timeCtrl.text.trim(),
                      subject: subjCtrl.text.trim(),
                      teacher: teacherCtrl.text.trim(),
                      room: roomCtrl.text.trim(),
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Period $pNum added to ${schedule.dayOfWeek} schedule.'), backgroundColor: AppColors.success),
                );
              }
            },
            child: const Text('Save Period'),
          ),
        ],
      ),
    );
  }
}
