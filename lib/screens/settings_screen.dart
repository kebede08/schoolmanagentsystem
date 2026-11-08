import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final SchoolState state;

  const SettingsScreen({super.key, required this.state});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _principalCtrl;
  late TextEditingController _sessionCtrl;
  late TextEditingController _gradingCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.state.schoolName);
    _addressCtrl = TextEditingController(text: widget.state.schoolAddress);
    _phoneCtrl = TextEditingController(text: widget.state.schoolPhone);
    _principalCtrl = TextEditingController(text: widget.state.principalName);
    _sessionCtrl = TextEditingController(text: widget.state.academicSession);
    _gradingCtrl = TextEditingController(text: widget.state.gradingScale);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _principalCtrl.dispose();
    _sessionCtrl.dispose();
    _gradingCtrl.dispose();
    super.dispose();
  }

  void _saveSettings() {
    widget.state.updateSchoolSettings(
      schoolName: _nameCtrl.text.trim(),
      schoolAddress: _addressCtrl.text.trim(),
      schoolPhone: _phoneCtrl.text.trim(),
      principalName: _principalCtrl.text.trim(),
      academicSession: _sessionCtrl.text.trim(),
      gradingScale: _gradingCtrl.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('School settings and preferences saved successfully!'),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _exportJsonBackup() {
    final exportData = {
      'institution': widget.state.schoolName,
      'address': widget.state.schoolAddress,
      'exported_at': DateTime.now().toIso8601String(),
      'students_count': widget.state.students.length,
      'teachers_count': widget.state.teachers.length,
      'classes_count': widget.state.classes.length,
      'fees_billed': widget.state.totalFeesBilled,
      'fees_collected': widget.state.totalFeesCollected,
      'students': widget.state.students.map((s) => {
        'id': s.id,
        'name': s.name,
        'roll': s.rollNumber,
        'grade': s.grade,
        'section': s.section,
        'email': s.email,
        'attendance': s.attendanceRate,
        'feeBalance': s.feeBalance,
      }).toList(),
    };

    final jsonStr = const JsonEncoder.withIndent('  ').convert(exportData);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.backup, color: AppColors.primary),
            SizedBox(width: 10),
            Text('System Data Export (JSON)'),
          ],
        ),
        content: SizedBox(
          width: 550,
          height: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('The complete institutional dataset has been compiled into JSON:', style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      jsonStr,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy JSON Data'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup JSON ready to archive.')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 750;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portal Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Configure institutional and academic details.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Save Settings', style: TextStyle(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _saveSettings,
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'School & Portal Settings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Configure institutional details, academic parameters, and system preferences.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save, size: 18),
                  label: const Text('Save Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _saveSettings,
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),

          // School Info Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Institutional Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (isMobile) ...[
                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Institution Name *'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _principalCtrl,
                      decoration: const InputDecoration(labelText: 'Principal / Headmaster *'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _addressCtrl,
                      decoration: const InputDecoration(labelText: 'Campus Address *'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneCtrl,
                      decoration: const InputDecoration(labelText: 'Contact Phone *'),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nameCtrl,
                            decoration: const InputDecoration(labelText: 'Institution Name *'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _principalCtrl,
                            decoration: const InputDecoration(labelText: 'Principal / Headmaster *'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _addressCtrl,
                            decoration: const InputDecoration(labelText: 'Campus Address *'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _phoneCtrl,
                            decoration: const InputDecoration(labelText: 'Contact Phone *'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Academic Configuration Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Academic Configuration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (isMobile) ...[
                    TextField(
                      controller: _sessionCtrl,
                      decoration: const InputDecoration(labelText: 'Active Academic Session *'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _gradingCtrl,
                      decoration: const InputDecoration(labelText: 'Grading Standard *'),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _sessionCtrl,
                            decoration: const InputDecoration(labelText: 'Active Academic Session *'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _gradingCtrl,
                            decoration: const InputDecoration(labelText: 'Grading Standard *'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // System Appearance & Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('System Preferences & Data Backup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Dark Mode Display', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Toggle between modern high-contrast Dark and Light color palettes'),
                    value: widget.state.isDarkMode,
                    onChanged: (val) => widget.state.toggleDarkMode(),
                  ),
                  const Divider(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Export JSON Data Backup'),
                        onPressed: _exportJsonBackup,
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.refresh, size: 18, color: AppColors.warning),
                        label: const Text('Reset to Default Demo Data', style: TextStyle(color: AppColors.warning)),
                        onPressed: () {
                          widget.state.resetToDefaultData();
                          _nameCtrl.text = widget.state.schoolName;
                          _principalCtrl.text = widget.state.principalName;
                          _addressCtrl.text = widget.state.schoolAddress;
                          _phoneCtrl.text = widget.state.schoolPhone;
                          _sessionCtrl.text = widget.state.academicSession;
                          _gradingCtrl.text = widget.state.gradingScale;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All records and settings reset to default demo dataset.'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
