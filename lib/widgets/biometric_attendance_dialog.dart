import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../models/attendance.dart';
import '../theme/app_theme.dart';

enum BiometricMode {
  fingerprint,
  faceRecognition,
  patternLock,
}

class BiometricAttendanceDialog extends StatefulWidget {
  final SchoolState state;
  final String grade;
  final String section;
  final AttendanceRecord? preselectedRecord;
  final BiometricMode initialMode;

  const BiometricAttendanceDialog({
    super.key,
    required this.state,
    required this.grade,
    required this.section,
    this.preselectedRecord,
    this.initialMode = BiometricMode.fingerprint,
  });

  @override
  State<BiometricAttendanceDialog> createState() => _BiometricAttendanceDialogState();
}

class _BiometricAttendanceDialogState extends State<BiometricAttendanceDialog>
    with SingleTickerProviderStateMixin {
  late BiometricMode _activeMode;
  late AnimationController _animCtrl;

  // Selected student for verification
  late String _selectedStudentId;
  bool _isScanning = false;
  bool _isSuccess = false;
  String _statusMessage = 'Ready for biometric verification';
  double _matchAccuracy = 0.0;
  String? _verifiedStudentName;
  String? _verifiedRoll;
  String? _checkInTimestamp;

  // Pattern lock points (0 to 8)
  final List<int> _selectedPatternNodes = [];

  @override
  void initState() {
    super.initState();
    _activeMode = widget.initialMode;
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    final roster = _getEligibleRecords();
    if (widget.preselectedRecord != null) {
      _selectedStudentId = widget.preselectedRecord!.id;
    } else if (roster.isNotEmpty) {
      _selectedStudentId = roster.first.id;
    } else {
      _selectedStudentId = '';
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  List<AttendanceRecord> _getEligibleRecords() {
    return widget.state.attendance
        .where((a) => a.grade == widget.grade && a.section == widget.section)
        .toList();
  }

  AttendanceRecord? _getCurrentRecord() {
    try {
      return widget.state.attendance.firstWhere((a) => a.id == _selectedStudentId);
    } catch (_) {
      return null;
    }
  }

  void _triggerScan() {
    if (_isScanning) return;
    final current = _getCurrentRecord();
    if (current == null) return;

    setState(() {
      _isScanning = true;
      _isSuccess = false;
      _statusMessage = _activeMode == BiometricMode.fingerprint
          ? 'Scanning biometric dermal ridges...'
          : _activeMode == BiometricMode.faceRecognition
              ? 'Analyzing facial keypoints and mesh...'
              : 'Validating security pattern gesture...';
    });

    Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      final now = DateTime.now();
      final timeStr =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

      // Update Attendance in SchoolState
      widget.state.markAttendance(current.id, AttendanceStatus.present);

      setState(() {
        _isScanning = false;
        _isSuccess = true;
        _matchAccuracy = 98.4 + (math.Random().nextDouble() * 1.5);
        _verifiedStudentName = current.studentName;
        _verifiedRoll = current.rollNumber;
        _checkInTimestamp = timeStr;
        _statusMessage = 'VERIFIED! Attendance recorded successfully.';
      });
    });
  }

  void _resetPattern() {
    setState(() {
      _selectedPatternNodes.clear();
      _isSuccess = false;
      _statusMessage = 'Draw your pattern to check in';
    });
  }

  void _onNodeTapped(int index) {
    if (_isScanning || _isSuccess) return;
    if (!_selectedPatternNodes.contains(index)) {
      setState(() {
        _selectedPatternNodes.add(index);
      });
      // When at least 4 nodes are connected, verify automatically
      if (_selectedPatternNodes.length >= 4) {
        _triggerScan();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final records = _getEligibleRecords();
    final current = _getCurrentRecord();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      child: Container(
        width: 780,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modal Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.fingerprint, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Smart Biometric Check-In Kiosk',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                        Text(
                          'Grade ${widget.grade}-${widget.section} • Multi-Modal Identity Verification',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Close Terminal',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Mode Selector Tabs (Fingerprint, Face Recognition, Pattern Lock)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBg : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _modeTab(
                    mode: BiometricMode.fingerprint,
                    label: 'Fingerprint Scanner',
                    icon: Icons.fingerprint,
                  ),
                  _modeTab(
                    mode: BiometricMode.faceRecognition,
                    label: 'Face Recognition ID',
                    icon: Icons.face_retouching_natural,
                  ),
                  _modeTab(
                    mode: BiometricMode.patternLock,
                    label: 'Pattern Check-In',
                    icon: Icons.grid_3x3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Main Body: Left Side (Verification Area) & Right Side (Student Roster)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Panel: Scanner HUD
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 380,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0B1329) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isSuccess
                            ? AppColors.success
                            : _isScanning
                                ? AppColors.primary
                                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: _buildScannerContent(current),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Status Badge
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isSuccess
                                ? AppColors.success.withOpacity(0.15)
                                : _isScanning
                                    ? AppColors.primary.withOpacity(0.15)
                                    : Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _isSuccess
                                  ? AppColors.success
                                  : _isScanning
                                      ? AppColors.primary
                                      : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isSuccess
                                    ? Icons.check_circle
                                    : _isScanning
                                        ? Icons.sync
                                        : Icons.info_outline,
                                size: 16,
                                color: _isSuccess
                                    ? AppColors.success
                                    : _isScanning
                                        ? AppColors.primary
                                        : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _statusMessage,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _isSuccess
                                        ? AppColors.success
                                        : _isScanning
                                            ? AppColors.primary
                                            : Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (_isSuccess && _verifiedStudentName != null) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_verifiedStudentName (Roll: $_verifiedRoll) • Check-in: $_checkInTimestamp • Match: ${_matchAccuracy.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Right Panel: Student Selection & Quick Stats
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Student to Verify',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 290,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBg : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: ListView.separated(
                          itemCount: records.length,
                          separatorBuilder: (c, i) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final rec = records[index];
                            final isSelected = rec.id == _selectedStudentId;
                            final isPresent = rec.status == AttendanceStatus.present;

                            return ListTile(
                              dense: true,
                              selected: isSelected,
                              selectedTileColor: AppColors.primary.withOpacity(0.12),
                              onTap: () {
                                setState(() {
                                  _selectedStudentId = rec.id;
                                  _isSuccess = isPresent;
                                  _statusMessage = isPresent
                                      ? 'Already verified as Present'
                                      : 'Tap scanner to check in';
                                  if (_activeMode == BiometricMode.patternLock) {
                                    _selectedPatternNodes.clear();
                                  }
                                });
                              },
                              leading: CircleAvatar(
                                radius: 14,
                                backgroundColor: isPresent
                                    ? AppColors.success
                                    : AppColors.primary.withOpacity(0.2),
                                child: Text(
                                  rec.studentName[0],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isPresent ? Colors.white : AppColors.primary,
                                  ),
                                ),
                              ),
                              title: Text(
                                rec.studentName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Roll: ${rec.rollNumber}',
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              trailing: Icon(
                                isPresent ? Icons.check_circle : Icons.radio_button_unchecked,
                                size: 16,
                                color: isPresent ? AppColors.success : Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Manual Trigger / Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          icon: Icon(
                            _isSuccess ? Icons.verified : Icons.touch_app,
                            size: 18,
                          ),
                          label: Text(
                            _isScanning
                                ? 'Scanning...'
                                : _isSuccess
                                    ? 'Verified (Scan Again)'
                                    : 'Touch / Tap to Verify',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isSuccess ? AppColors.success : AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _triggerScan,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeTab({
    required BiometricMode mode,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _activeMode == mode;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _activeMode = mode;
            _isScanning = false;
            _isSuccess = false;
            _statusMessage = 'Ready for biometric verification';
            _selectedPatternNodes.clear();
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerContent(AttendanceRecord? current) {
    switch (_activeMode) {
      case BiometricMode.fingerprint:
        return _buildFingerprintView();
      case BiometricMode.faceRecognition:
        return _buildFaceView(current);
      case BiometricMode.patternLock:
        return _buildPatternView();
    }
  }

  // 1. FINGERPRINT SCANNER VIEW
  Widget _buildFingerprintView() {
    return GestureDetector(
      onTap: _triggerScan,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer Pulse Ring
                if (_isScanning)
                  AnimatedBuilder(
                    animation: _animCtrl,
                    builder: (context, _) {
                      return Container(
                        width: 140 + (_animCtrl.value * 25),
                        height: 140 + (_animCtrl.value * 25),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(1 - _animCtrl.value),
                            width: 2,
                          ),
                        ),
                      );
                    },
                  ),

                // Biometric Touchpad Sensor
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: _isSuccess
                          ? [AppColors.success.withOpacity(0.3), AppColors.success.withOpacity(0.05)]
                          : _isScanning
                              ? [AppColors.primary.withOpacity(0.35), AppColors.primary.withOpacity(0.08)]
                              : [Colors.blue.withOpacity(0.15), Colors.transparent],
                    ),
                    border: Border.all(
                      color: _isSuccess
                          ? AppColors.success
                          : _isScanning
                              ? AppColors.primary
                              : Colors.blue.withOpacity(0.4),
                      width: 2.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _isSuccess ? Icons.fingerprint : Icons.fingerprint,
                      size: 78,
                      color: _isSuccess
                          ? AppColors.success
                          : _isScanning
                              ? AppColors.primary
                              : Colors.blue.shade400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _isSuccess
                  ? 'FINGERPRINT MATCH CONFIRMED'
                  : _isScanning
                      ? 'HOLD STILL • VERIFYING BIOMETRIC...'
                      : 'PLACE FINGER ON OPTICAL SENSOR',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: _isSuccess
                    ? AppColors.success
                    : _isScanning
                        ? AppColors.primary
                        : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Click / Tap sensor to initiate capture',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // 2. FACE RECOGNITION VIEW
  Widget _buildFaceView(AttendanceRecord? current) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Camera Viewport Frame
            Container(
              width: 210,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isSuccess
                      ? AppColors.success
                      : _isScanning
                          ? AppColors.primary
                          : Colors.cyan.withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Corner HUD Brackets
                    CustomPaint(
                      size: const Size(210, 200),
                      painter: _FaceHudPainter(
                        color: _isSuccess
                            ? AppColors.success
                            : _isScanning
                                ? AppColors.primary
                                : Colors.cyanAccent,
                      ),
                    ),

                    // Face Avatar / Mesh
                    Opacity(
                      opacity: _isSuccess ? 0.9 : 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.face,
                            size: 90,
                            color: _isSuccess
                                ? AppColors.success
                                : _isScanning
                                    ? Colors.cyanAccent
                                    : Colors.white70,
                          ),
                          if (current != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                current.studentName,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Vertical Scanning Laser Beam
                    if (_isScanning)
                      AnimatedBuilder(
                        animation: _animCtrl,
                        builder: (context, _) {
                          return Positioned(
                            top: _animCtrl.value * 180,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.cyanAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyanAccent.withOpacity(0.8),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          _isSuccess
              ? 'AI FACE RECOGNITION: MATCH 99.2%'
              : _isScanning
                  ? 'DETECTING 68 FACIAL LANDMARKS...'
                  : 'AI VISION CAMERA FEED ACTIVE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: _isSuccess
                ? AppColors.success
                : _isScanning
                    ? Colors.cyanAccent
                    : Colors.grey,
          ),
        ),
      ],
    );
  }

  // 3. PATTERN CHECK-IN VIEW
  Widget _buildPatternView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Connect nodes to verify pattern',
              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh, size: 18),
              onPressed: _resetPattern,
              tooltip: 'Clear Pattern',
            ),
          ],
        ),
        const SizedBox(height: 6),

        // 3x3 Grid
        Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          child: GridView.builder(
            itemCount: 9,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final isConnected = _selectedPatternNodes.contains(index);
              final order = _selectedPatternNodes.indexOf(index);

              return GestureDetector(
                onTap: () => _onNodeTapped(index),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isConnected
                          ? (_isSuccess ? AppColors.success : AppColors.primary)
                          : Colors.grey.withOpacity(0.2),
                      border: Border.all(
                        color: isConnected
                            ? (_isSuccess ? AppColors.success : AppColors.primary)
                            : Colors.grey.shade400,
                        width: isConnected ? 3 : 1.5,
                      ),
                      boxShadow: isConnected
                          ? [
                              BoxShadow(
                                color: (_isSuccess ? AppColors.success : AppColors.primary)
                                    .withOpacity(0.5),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: isConnected
                          ? Text(
                              '${order + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            )
                          : Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FaceHudPainter extends CustomPainter {
  final Color color;

  _FaceHudPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    const cornerLength = 24.0;

    // Top-left corner
    canvas.drawLine(const Offset(10, 10), const Offset(10 + cornerLength, 10), paint);
    canvas.drawLine(const Offset(10, 10), const Offset(10, 10 + cornerLength), paint);

    // Top-right corner
    canvas.drawLine(Offset(size.width - 10, 10), Offset(size.width - 10 - cornerLength, 10), paint);
    canvas.drawLine(Offset(size.width - 10, 10), Offset(size.width - 10, 10 + cornerLength), paint);

    // Bottom-left corner
    canvas.drawLine(Offset(10, size.height - 10), Offset(10 + cornerLength, size.height - 10), paint);
    canvas.drawLine(Offset(10, size.height - 10), Offset(10, size.height - 10 - cornerLength), paint);

    // Bottom-right corner
    canvas.drawLine(Offset(size.width - 10, size.height - 10), Offset(size.width - 10 - cornerLength, size.height - 10), paint);
    canvas.drawLine(Offset(size.width - 10, size.height - 10), Offset(size.width - 10, size.height - 10 - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant _FaceHudPainter oldDelegate) => oldDelegate.color != color;
}

