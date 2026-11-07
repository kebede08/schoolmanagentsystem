# EduPulse - Modern School Management Application (Web & Android)

A cross-platform, responsive, feature-rich **School Management System** built with **Flutter 3.24 (Dart 3.5)** and Material Design 3, targeting both **Web** and **Android**.

---

## 🌟 Key Modules & Features

1. **Executive Dashboard**:
   - Live KPI Stat Cards: Total Enrolled Students, Faculty Count, Today's Attendance %, and Fee Collection status.
   - Interactive Charts:
     - **Weekly Attendance Trend** bar chart.
     - **Fee Collection Breakdown** donut gauge (Paid, Pending, Overdue).
   - Class Enrollment Capacity tracking.
   - Recent school announcements and bulletins feed.

2. **Multi-Modal Biometric Attendance System**:
   - **Fingerprint Scan**: Live capacitive pulse ring, scan animation, and instant verification.
   - **Face Recognition HUD**: 3D bounding viewfinder, AI facial landmark detection grid, and confidence scoring.
   - **Pattern Lock**: Interactive 3x3 touch/mouse pattern connector with visual sequence feedback.
   - Interactive Date Picker, Grade/Section filters, and one-click **"Mark All Present"** batch action.
   - Individual status toggles: **P** (Present), **L** (Late), **A** (Absent), **E** (Excused).

3. **Student Directory & Admissions**:
   - Search by name, roll number, email, or guardian name.
   - Grade filter tabs (Grade 10, Grade 11, Grade 12).
   - Detailed student profile inspection dialog with guardian contacts and academic standing.
   - "Add Student" enrollment form with live validation and state updates.
   - Delete/remove student functionality.

4. **Faculty & Staff Management**:
   - Department filtering: Science & STEM, Mathematics, Humanities, Computer Science, Social Sciences.
   - Faculty member cards displaying specialization, qualification, assigned classes, and contact info.
   - "Add Faculty" modal form.

5. **Classroom & Course Allocation**:
   - Room numbers, homeroom teachers, and enrolled vs. capacity visual meters.
   - Enrolled student roster viewer per classroom.
   - "Add Section" modal dialog.

6. **Examinations & Gradebook**:
   - Term switcher: Term 1, Midterm, Final exams.
   - Score entry, instant percentage calculation, letter grades (A+, A, B, C, D, F), and GPA standard scale (4.0).
   - **Official Student Report Card Generator**: Professional, printable academic transcript dialog.

7. **Fee Management & Invoicing**:
   - Financial overview: Total Billed, Total Collected, Outstanding Arrears.
   - Filter by status: Paid, Pending, Overdue.
   - "Collect Payment" action modal supporting Bank Transfer, Credit Card, Cash, and Cheque.
   - **Official Printable Receipt Voucher**: Formatted school receipt with transaction reference.

8. **Weekly Class Timetable**:
   - Multi-grade selector (Grades 10, 11, and 12).
   - Day-of-week switcher (Monday through Friday).
   - Period-by-period breakdown (Periods 1 - 6) with time slots, subject color tags, teacher, and classroom location.

9. **Notice Board & Announcements**:
   - Target audience filter (All, Parents, Teachers, Students).
   - Priority badges (Urgent, High, Normal).
   - "Post School Announcement" modal form.

10. **Role-Based Experience & System Preferences**:
    - **Role Switcher Dropdown** in top bar: Switch between **Admin**, **Teacher**, **Student**, and **Parent** views.
    - **Dark / Light Theme Toggle** with custom palette.
    - Responsive layout with collapsible desktop sidebar and automatic mobile navigation drawer for Android phones and tablets.
    - School profile editor and JSON backup exporter.

---

## 🚀 How to Run the App

### Web (Chrome / Edge / Safari / Firefox)
- **1-Click Web Launcher**: Double-click `run_web.bat`
- **Via Terminal**:
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\flutter_runner.ps1 run -d chrome
  ```
- **Build Web Release**:
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\flutter_runner.ps1 build web --release
  ```

### Android (Phone / Tablet / Emulator)
- **1-Click Android Launcher**: Double-click `run_android.bat`
- **Via Terminal**:
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\flutter_runner.ps1 run -d android
  ```
- **Build Release APK**: Double-click `build_apk.bat` or run:
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\flutter_runner.ps1 build apk --release
  ```
  The generated APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📁 Project Architecture

```
school_management/
├── android/                       # Native Android project (Gradle, AndroidManifest, Kotlin)
│   ├── app/
│   │   ├── src/main/AndroidManifest.xml
│   │   └── build.gradle
│   └── build.gradle
├── web/                           # Web application shell & metadata
│   ├── index.html
│   └── manifest.json
├── lib/
│   ├── main.dart                  # Responsive app shell (drawer on mobile, sidebar on desktop)
│   ├── models/                    # Data models (Student, Teacher, Class, Attendance, Grade, Fee, Notice, Timetable)
│   ├── services/                  # ChangeNotifier State & realistic Seed Data
│   ├── theme/                     # Material 3 Light & Dark themes
│   ├── widgets/                   # Biometric Dialog, Charts, Stat Cards, Navbars
│   └── screens/                   # 10 comprehensive management screens
├── run_web.bat                    # 1-Click Web launcher
├── run_android.bat                # 1-Click Android launcher
├── build_apk.bat                  # 1-Click APK builder
└── connect_github.bat             # 1-Click GitHub connector
```
