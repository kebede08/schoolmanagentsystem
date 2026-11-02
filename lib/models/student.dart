class Student {
  final String id;
  final String name;
  final String rollNumber;
  final String grade;
  final String section;
  final String email;
  final String phone;
  final String guardianName;
  final String guardianPhone;
  final String gender;
  final DateTime dateOfBirth;
  final double attendanceRate;
  final double feeBalance;
  final String status; // 'Active', 'On Leave', 'Graduated'

  Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.grade,
    required this.section,
    required this.email,
    required this.phone,
    required this.guardianName,
    required this.guardianPhone,
    required this.gender,
    required this.dateOfBirth,
    this.attendanceRate = 95.0,
    this.feeBalance = 0.0,
    this.status = 'Active',
  });

  Student copyWith({
    String? id,
    String? name,
    String? rollNumber,
    String? grade,
    String? section,
    String? email,
    String? phone,
    String? guardianName,
    String? guardianPhone,
    String? gender,
    DateTime? dateOfBirth,
    double? attendanceRate,
    double? feeBalance,
    String? status,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      rollNumber: rollNumber ?? this.rollNumber,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      attendanceRate: attendanceRate ?? this.attendanceRate,
      feeBalance: feeBalance ?? this.feeBalance,
      status: status ?? this.status,
    );
  }
}

