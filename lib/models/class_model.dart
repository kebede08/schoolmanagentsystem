class SchoolClass {
  final String id;
  final String grade;
  final String section;
  final String roomNumber;
  final String classTeacherId;
  final String classTeacherName;
  final int capacity;
  final int currentEnrolled;
  final List<String> subjects;

  SchoolClass({
    required this.id,
    required this.grade,
    required this.section,
    required this.roomNumber,
    required this.classTeacherId,
    required this.classTeacherName,
    required this.capacity,
    required this.currentEnrolled,
    required this.subjects,
  });

  String get displayName => 'Grade $grade - $section';
}

