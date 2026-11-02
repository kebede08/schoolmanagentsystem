enum NoticePriority {
  urgent,
  high,
  normal,
}

class Notice {
  final String id;
  final String title;
  final String content;
  final String author;
  final DateTime publishedDate;
  final String targetAudience; // 'All', 'Teachers', 'Students', 'Parents'
  final NoticePriority priority;

  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.publishedDate,
    required this.targetAudience,
    required this.priority,
  });
}

