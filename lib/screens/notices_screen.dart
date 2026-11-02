import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../models/notice.dart';
import '../theme/app_theme.dart';

class NoticesScreen extends StatefulWidget {
  final SchoolState state;

  const NoticesScreen({super.key, required this.state});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  String _audienceFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = widget.state.notices.where((n) {
      if (_audienceFilter == 'All') return true;
      return n.targetAudience == _audienceFilter || n.targetAudience == 'All';
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
                    'Notice Board & Circulars',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Broadcast school announcements, academic events, and emergency bulletins.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.campaign, size: 18),
                label: const Text('Post Announcement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _showPostNoticeDialog(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Audience Filter
          Row(
            children: ['All', 'Parents', 'Teachers', 'Students'].map((aud) {
              final isSelected = _audienceFilter == aud;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(aud == 'All' ? 'All Audiences' : aud),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() => _audienceFilter = aud);
                  },
                  backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                  selectedColor: AppColors.primary.withOpacity(0.18),
                  labelStyle: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Notices List
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final notice = filtered[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: notice.priority == NoticePriority.urgent
                                    ? AppColors.danger.withOpacity(0.15)
                                    : notice.priority == NoticePriority.high
                                        ? AppColors.warning.withOpacity(0.15)
                                        : AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                notice.priority.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: notice.priority == NoticePriority.urgent
                                      ? AppColors.danger
                                      : notice.priority == NoticePriority.high
                                          ? AppColors.warning
                                          : AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkBg : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Audience: ${notice.targetAudience}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${notice.publishedDate.year}-${notice.publishedDate.month.toString().padLeft(2, '0')}-${notice.publishedDate.day.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          notice.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notice.content,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.person_pin, size: 14, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Published by ${notice.author}',
                              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                          ],
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

  void _showPostNoticeDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final authorCtrl = TextEditingController(text: 'Principal Office');
    String audience = 'All';
    NoticePriority priority = NoticePriority.normal;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Post School Announcement'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Notice Title *')),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: audience,
                          decoration: const InputDecoration(labelText: 'Target Audience'),
                          items: ['All', 'Parents', 'Teachers', 'Students'].map((a) {
                            return DropdownMenuItem(value: a, child: Text(a));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setDialogState(() => audience = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<NoticePriority>(
                          value: priority,
                          decoration: const InputDecoration(labelText: 'Priority'),
                          items: NoticePriority.values.map((p) {
                            return DropdownMenuItem(value: p, child: Text(p.name.toUpperCase()));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setDialogState(() => priority = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: authorCtrl, decoration: const InputDecoration(labelText: 'Author / Signatory')),
                  const SizedBox(height: 12),
                  TextField(
                    controller: contentCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Announcement Details *'),
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
                if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                  final newNotice = Notice(
                    id: 'NTC-${DateTime.now().millisecondsSinceEpoch}',
                    title: titleCtrl.text.trim(),
                    content: contentCtrl.text.trim(),
                    author: authorCtrl.text.trim(),
                    publishedDate: DateTime.now(),
                    targetAudience: audience,
                    priority: priority,
                  );
                  widget.state.addNotice(newNotice);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Publish Notice'),
            ),
          ],
        ),
      ),
    );
  }
}

