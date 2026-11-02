class Teacher {
  final String id;
  final String name;
  final String employeeId;
  final String department;
  final String subject;
  final String email;
  final String phone;
  final String qualification;
  final List<String> assignedClasses;
  final String status; // 'Active', 'On Leave'

  Teacher({
    required this.id,
    required this.name,
    required this.employeeId,
    required this.department,
    required this.subject,
    required this.email,
    required this.phone,
    required this.qualification,
    required this.assignedClasses,
    this.status = 'Active',
  });

  Teacher copyWith({
    String? id,
    String? name,
    String? employeeId,
    String? department,
    String? subject,
    String? email,
    String? phone,
    String? qualification,
    List<String>? assignedClasses,
    String? status,
  }) {
    return Teacher(
      id: id ?? this.id,
      name: name ?? this.name,
      employeeId: employeeId ?? this.employeeId,
      department: department ?? this.department,
      subject: subject ?? this.subject,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      qualification: qualification ?? this.qualification,
      assignedClasses: assignedClasses ?? this.assignedClasses,
      status: status ?? this.status,
    );
  }
}

