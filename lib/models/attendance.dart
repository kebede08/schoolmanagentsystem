enum AttendanceStatus {
  present,
  absent,
  late,
  excused,
}

class AttendanceRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String rollNumber;
  final String grade;
  final String section;
  final DateTime date;
  AttendanceStatus status;
  final String remarks;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.grade,
    required this.section,
    required this.date,
    required this.status,
    this.remarks = '',
  });

  AttendanceRecord copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? rollNumber,
    String? grade,
    String? section,
    DateTime? date,
    AttendanceStatus? status,
    String? remarks,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      rollNumber: rollNumber ?? this.rollNumber,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      date: date ?? this.date,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
    );
  }
}

