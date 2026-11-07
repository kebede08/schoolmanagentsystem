import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/class_model.dart';
import '../models/attendance.dart';
import '../models/grade.dart';
import '../models/fee.dart';
import '../models/notice.dart';
import '../models/timetable.dart';
import 'mock_data.dart';

class SchoolState extends ChangeNotifier {
  // Theme & Layout
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  String _currentRole = 'Admin'; // 'Admin', 'Teacher', 'Student', 'Parent'
  String get currentRole => _currentRole;

  int _selectedNavIndex = 0;
  int get selectedNavIndex => _selectedNavIndex;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // School Settings
  String _schoolName = 'EduPulse Academy';
  String get schoolName => _schoolName;

  String _schoolAddress = '450 University Avenue, Education District, Innovation Park';
  String get schoolAddress => _schoolAddress;

  String _schoolPhone = '+1 (555) 789-2000';
  String get schoolPhone => _schoolPhone;

  String _principalName = 'Dr. Sarah Sterling';
  String get principalName => _principalName;

  String _academicSession = '2026-2027';
  String get academicSession => _academicSession;

  String _gradingScale = 'GPA 4.0 Standard Scale';
  String get gradingScale => _gradingScale;

  void updateSchoolSettings({
    String? schoolName,
    String? schoolAddress,
    String? schoolPhone,
    String? principalName,
    String? academicSession,
    String? gradingScale,
  }) {
    if (schoolName != null) _schoolName = schoolName;
    if (schoolAddress != null) _schoolAddress = schoolAddress;
    if (schoolPhone != null) _schoolPhone = schoolPhone;
    if (principalName != null) _principalName = principalName;
    if (academicSession != null) _academicSession = academicSession;
    if (gradingScale != null) _gradingScale = gradingScale;
    notifyListeners();
  }

  // Data lists
  List<Student> _students = [];
  List<Teacher> _teachers = [];
  List<SchoolClass> _classes = [];
  List<AttendanceRecord> _attendance = [];
  List<FeeInvoice> _invoices = [];
  List<GradeRecord> _grades = [];
  List<Notice> _notices = [];
  List<DaySchedule> _weeklySchedule = [];

  // Getters
  List<Student> get students => _students;
  List<Teacher> get teachers => _teachers;
  List<SchoolClass> get classes => _classes;
  List<AttendanceRecord> get attendance => _attendance;
  List<FeeInvoice> get invoices => _invoices;
  List<GradeRecord> get grades => _grades;
  List<Notice> get notices => _notices;
  List<DaySchedule> get weeklySchedule => _weeklySchedule;

  SchoolState() {
    _initializeData();
  }

  void _initializeData() {
    _students = MockData.getInitialStudents();
    _teachers = MockData.getInitialTeachers();
    _classes = MockData.getInitialClasses();
    _attendance = MockData.getInitialAttendance();
    _invoices = MockData.getInitialInvoices();
    _grades = MockData.getInitialGrades();
    _notices = MockData.getInitialNotices();
    _weeklySchedule = MockData.getWeeklySchedule();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setRole(String role) {
    _currentRole = role;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Student Actions
  void addStudent(Student student) {
    _students.insert(0, student);
    notifyListeners();
  }

  void updateStudent(Student student) {
    final idx = _students.indexWhere((s) => s.id == student.id);
    if (idx != -1) {
      _students[idx] = student;
      notifyListeners();
    }
  }

  void deleteStudent(String studentId) {
    _students.removeWhere((s) => s.id == studentId);
    notifyListeners();
  }

  // Teacher Actions
  void addTeacher(Teacher teacher) {
    _teachers.insert(0, teacher);
    notifyListeners();
  }

  void updateTeacher(Teacher teacher) {
    final idx = _teachers.indexWhere((t) => t.id == teacher.id);
    if (idx != -1) {
      _teachers[idx] = teacher;
      notifyListeners();
    }
  }

  void deleteTeacher(String teacherId) {
    _teachers.removeWhere((t) => t.id == teacherId);
    notifyListeners();
  }

  void addClass(SchoolClass schoolClass) {
    _classes.add(schoolClass);
    notifyListeners();
  }

  // Attendance Actions
  void markAttendance(String recordId, AttendanceStatus newStatus) {
    final idx = _attendance.indexWhere((a) => a.id == recordId);
    if (idx != -1) {
      _attendance[idx] = _attendance[idx].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void markAllPresent(String grade, String section) {
    for (int i = 0; i < _attendance.length; i++) {
      if (_attendance[i].grade == grade && _attendance[i].section == section) {
        _attendance[i] = _attendance[i].copyWith(status: AttendanceStatus.present);
      }
    }
    notifyListeners();
  }

  // Fee Actions
  void addInvoice(FeeInvoice invoice) {
    _invoices.insert(0, invoice);
    notifyListeners();
  }

  void recordPayment(String invoiceId, double paymentAmount, String paymentMethod) {
    final idx = _invoices.indexWhere((inv) => inv.id == invoiceId);
    if (idx != -1) {
      final current = _invoices[idx];
      final newPaid = current.paidAmount + paymentAmount;
      final newStatus = newPaid >= current.amount ? FeeStatus.paid : FeeStatus.pending;
      _invoices[idx] = current.copyWith(
        paidAmount: newPaid,
        status: newStatus,
        paymentDate: DateTime.now(),
        paymentMethod: paymentMethod,
      );
      notifyListeners();
    }
  }

  // Grade Actions
  void addGrade(GradeRecord gradeRecord) {
    _grades.insert(0, gradeRecord);
    notifyListeners();
  }

  // Notice Actions
  void addNotice(Notice notice) {
    _notices.insert(0, notice);
    notifyListeners();
  }

  // Computed Metrics
  int get totalStudentsCount => _students.length;
  int get totalTeachersCount => _teachers.length;
  int get activeClassesCount => _classes.length;

  double get attendanceRateToday {
    if (_attendance.isEmpty) return 100.0;
    final presentCount = _attendance.where((a) => a.status == AttendanceStatus.present || a.status == AttendanceStatus.late).length;
    return (presentCount / _attendance.length) * 100;
  }

  double get totalFeesBilled => _invoices.fold(0.0, (sum, item) => sum + item.amount);
  double get totalFeesCollected => _invoices.fold(0.0, (sum, item) => sum + item.paidAmount);
  double get totalFeesPending => totalFeesBilled - totalFeesCollected;
  double get feeCollectionPercentage {
    if (totalFeesBilled == 0) return 0.0;
    return (totalFeesCollected / totalFeesBilled) * 100;
  }
}

