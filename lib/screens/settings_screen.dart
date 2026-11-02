import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  final SchoolState state;

  const SettingsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
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

          const SizedBox(height: 24),

          // School Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Institutional Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Institution Name',
                            hintText: 'EduPulse International Academy',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'School Code / Registration ID',
                            hintText: 'SCH-EDU-2026-X9',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Campus Address',
                      hintText: '450 University Avenue, Education District, Innovation Park',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Academic Configuration Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Academic Configuration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Current Academic Term',
                            hintText: 'Term 1 (Fall Session 2026)',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Grading Standard',
                            hintText: 'GPA 4.0 Standard Scale (A+, A, B, C, D, F)',
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  const Text('System Appearance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Dark Mode Display', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Toggle between modern high-contrast Dark and Light color palettes'),
                    value: state.isDarkMode,
                    onChanged: (val) => state.toggleDarkMode(),
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Export Data Backup'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Academic records backup exported successfully.')),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Reset Demo Data'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Demo data reloaded to defaults.')),
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

