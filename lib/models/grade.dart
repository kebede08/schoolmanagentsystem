class GradeRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String rollNumber;
  final String grade;
  final String subject;
  final String term; // 'Term 1', 'Midterm', 'Final'
  final double score; // 0 to 100
  final double maxScore;
  final String comments;

  GradeRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.grade,
    required this.subject,
    required this.term,
    required this.score,
    this.maxScore = 100,
    this.comments = '',
  });

  double get percentage => (score / maxScore) * 100;

  String get letterGrade {
    final p = percentage;
    if (p >= 90) return 'A+';
    if (p >= 80) return 'A';
    if (p >= 70) return 'B';
    if (p >= 60) return 'C';
    if (p >= 50) return 'D';
    return 'F';
  }

  double get gpa {
    final p = percentage;
    if (p >= 90) return 4.0;
    if (p >= 80) return 3.5;
    if (p >= 70) return 3.0;
    if (p >= 60) return 2.0;
    if (p >= 50) return 1.0;
    return 0.0;
  }
}

