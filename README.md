# EduPulse - Modern School Management Web Application

A responsive, feature-rich **School Management System Web Application** built with **Flutter 3.24 (Dart 3.5)** and Material Design 3.

---

## 🌟 Key Features

1. **Executive Dashboard**:
   - Live KPI Stat Cards: Total Enrolled Students, Faculty Count, Today's Attendance %, and Fee Collection status.
   - Interactive Charts:
     - **Weekly Attendance Trend** bar chart.
     - **Fee Collection Breakdown** donut gauge (Paid, Pending, Overdue).
   - Class Enrollment Capacity tracking.
   - Recent school announcements and bulletins feed.

2. **Student Directory**:
   - Search by name, roll number, email, or guardian name.
   - Grade filter tabs (Grade 10, Grade 11, Grade 12).
   - Detailed student profile inspection dialog (Guardian info, contact, academic standing).
   - "Add Student" enrollment form with live validation and state update.
   - Delete/remove student functionality.

3. **Faculty & Staff Management**:
   - Department filtering: Science & STEM, Mathematics, Humanities, Computer Science, Social Sciences.
   - Faculty member cards displaying specialization, qualification, assigned classes, and contact info.
   - "Add Faculty" modal form.

4. **Classroom & Course Allocation**:
   - Room numbers, homeroom teachers, and enrolled vs. capacity visual indicators.
   - Subject tags per class.

5. **Daily Attendance Register**:
   - Interactive Date Picker for past/future attendance records.
   - Grade and section filters.
   - One-click **"Mark All Present"** batch action.
   - Live attendance toggle buttons per student: **P** (Present), **L** (Late), **A** (Absent), **E** (Excused).
   - Live status counters and attendance percentage calculation.

6. **Examinations & Gradebook**:
   - Term switcher: Term 1, Midterm, Final exams.
   - Score entry, instant percentage calculation, letter grades (A+, A, B, C, D, F), and GPA standard scale (4.0).
   - "Record Assessment Score" modal with teacher feedback comments.

7. **Fee Management & Invoicing**:
   - Financial overview: Total Billed, Total Collected, Outstanding Arrears.
   - Filter by status: Paid, Pending, Overdue.
   - Interactive table with "Collect Payment" action modal supporting Bank Transfer, Credit Card, Cash, and Cheque.
   - "Create Invoice" dialog.

8. **Weekly Class Timetable**:
   - Day-of-week switcher (Monday through Friday).
   - Period-by-period breakdown (Periods 1 - 6) with time slots, subject color tags, teacher, and classroom location.

9. **Notice Board & Announcements**:
   - Target audience filter (All, Parents, Teachers, Students).
   - Priority badges (Urgent, High, Normal).
   - "Post School Announcement" modal form.

10. **Role-Based Experience & System Preferences**:
    - **Role Switcher Dropdown** in top bar: Switch between **Admin**, **Teacher**, **Student**, and **Parent** views.
    - **Dark / Light Theme Toggle** with custom styling.
    - Responsive layout with collapsible desktop sidebar and mobile navigation drawer.

---

## 🚀 How to Run the App

### Option 1: Double-Click the Launcher
Simply double-click:
```bat
run_web.bat
```

### Option 2: Run via Terminal / PowerShell
```powershell
$env:Path = "C:\flutter\bin;$env:Path"
flutter run -d chrome
```

### Option 3: Build Web Production Artifact
```powershell
$env:Path = "C:\flutter\bin;$env:Path"
flutter build web --release
```
The production bundle will be generated in `build/web/`.

---

## 📁 Project Architecture

```
lib/
├── main.dart                      # App entry point, responsive shell, routing
├── models/
│   ├── student.dart               # Student profile data model
│   ├── teacher.dart               # Faculty and staff data model
│   ├── class_model.dart           # Class and room data model
│   ├── attendance.dart            # Attendance records and status enums
│   ├── grade.dart                 # Exam scores, letter grades, GPA calculation
│   ├── fee.dart                   # Invoicing, fee categories, and payments
│   ├── notice.dart                # Announcements and priority definitions
│   └── timetable.dart             # Daily and weekly period schedules
├── services/
│   ├── mock_data.dart             # Seed data for realistic school management
│   └── school_state.dart          # Central ChangeNotifier state manager
├── theme/
│   └── app_theme.dart             # Material 3 light and dark theme palette
├── widgets/
│   ├── sidebar_nav.dart           # Collapsible navigation rail / drawer
│   ├── top_nav_bar.dart           # App bar with search, role switcher, notifications
│   ├── stat_card.dart             # KPI summary metrics cards
│   ├── custom_chart.dart          # Bar charts & donut graphs
│   └── status_badge.dart          # Formatted status tags and pills
└── screens/
    ├── dashboard_screen.dart      # Main executive dashboard
    ├── students_screen.dart       # Student directory & admissions
    ├── teachers_screen.dart       # Faculty list & assignments
    ├── classes_screen.dart        # Classroom capacity & subjects
    ├── attendance_screen.dart     # Daily attendance register & batch actions
    ├── gradebook_screen.dart      # Exam scores & GPA grading
    ├── fees_screen.dart           # Fee billing & payment collection
    ├── timetable_screen.dart      # Weekly class timetable
    ├── notices_screen.dart        # School notices & announcements
    └── settings_screen.dart       # School profile & appearance settings
```

