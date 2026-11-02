import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class WeeklyAttendanceBarChart extends StatelessWidget {
  final List<double> weeklyRates; // e.g. [96.0, 94.5, 98.0, 95.0, 97.2]
  final List<String> days;

  const WeeklyAttendanceBarChart({
    super.key,
    required this.weeklyRates,
    this.days = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weekly Attendance Trends (%)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Avg: 96.1%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          child: CustomPaint(
            size: const Size(double.infinity, 180),
            painter: _BarChartPainter(
              rates: weeklyRates,
              days: days,
              isDark: isDark,
              barColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> rates;
  final List<String> days;
  final bool isDark;
  final Color barColor;

  _BarChartPainter({
    required this.rates,
    required this.days,
    required this.isDark,
    required this.barColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white10 : Colors.black.withOpacity(0.06))
      ..strokeWidth = 1;

    final bottomPadding = 30.0;
    final chartHeight = size.height - bottomPadding;
    final n = rates.length;
    final slotWidth = size.width / n;
    final barWidth = math.min(36.0, slotWidth * 0.45);

    // Draw grid horizontal lines (0%, 50%, 100%)
    for (int i = 0; i <= 2; i++) {
      final y = chartHeight - (chartHeight / 2) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final barPaint = Paint()..color = barColor;
    final bgBarPaint = Paint()
      ..color = (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04));

    for (int i = 0; i < n; i++) {
      final xCenter = slotWidth * i + slotWidth / 2;
      final xLeft = xCenter - barWidth / 2;
      final rate = rates[i].clamp(0.0, 100.0);
      final barHeight = (rate / 100.0) * chartHeight;
      final yTop = chartHeight - barHeight;

      // Draw background bar
      final bgRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(xLeft, 0, barWidth, chartHeight),
        const Radius.circular(6),
      );
      canvas.drawRRect(bgRect, bgBarPaint);

      // Draw actual value bar
      final activeRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(xLeft, yTop, barWidth, barHeight),
        const Radius.circular(6),
      );
      canvas.drawRRect(activeRect, barPaint);

      // Draw text label below bar
      final textSpan = TextSpan(
        text: days[i],
        style: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(xCenter - textPainter.width / 2, chartHeight + 10),
      );

      // Draw rate value on top
      final valSpan = TextSpan(
        text: '${rates[i].toStringAsFixed(0)}%',
        style: TextStyle(
          color: isDark ? AppColors.darkText : AppColors.lightText,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
      final valPainter = TextPainter(
        text: valSpan,
        textDirection: TextDirection.ltr,
      );
      valPainter.layout();
      valPainter.paint(
        canvas,
        Offset(xCenter - valPainter.width / 2, yTop - 16),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) => true;
}

class FeeCollectionDonutChart extends StatelessWidget {
  final double collected;
  final double pending;
  final double overdue;

  const FeeCollectionDonutChart({
    super.key,
    required this.collected,
    required this.pending,
    required this.overdue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = collected + pending + overdue;
    final percentage = total > 0 ? (collected / total) * 100 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fee Collection Breakdown',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 130,
              height: 130,
              child: CustomPaint(
                painter: _DonutChartPainter(
                  collected: collected,
                  pending: pending,
                  overdue: overdue,
                  total: total,
                  isDark: isDark,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      Text(
                        'Collected',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legendItem('Paid', collected, AppColors.success, isDark),
                  const SizedBox(height: 8),
                  _legendItem('Pending', pending, AppColors.warning, isDark),
                  const SizedBox(height: 8),
                  _legendItem('Overdue', overdue, AppColors.danger, isDark),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(String label, double amount, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final double collected;
  final double pending;
  final double overdue;
  final double total;
  final bool isDark;

  _DonutChartPainter({
    required this.collected,
    required this.pending,
    required this.overdue,
    required this.total,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 14.0;

    final bgPaint = Paint()
      ..color = isDark ? Colors.white10 : Colors.black.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    if (total == 0) return;

    final startAngle = -math.pi / 2;
    double currentAngle = startAngle;

    final items = [
      {'val': collected, 'color': AppColors.success},
      {'val': pending, 'color': AppColors.warning},
      {'val': overdue, 'color': AppColors.danger},
    ];

    for (var item in items) {
      final val = item['val'] as double;
      final color = item['color'] as Color;
      final sweepAngle = (val / total) * 2 * math.pi;

      if (sweepAngle > 0.001) {
        final arcPaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          currentAngle,
          sweepAngle - 0.04, // slight gap
          false,
          arcPaint,
        );
        currentAngle += sweepAngle;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) => true;
}

