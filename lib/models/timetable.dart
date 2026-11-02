class PeriodSlot {
  final int periodNumber;
  final String timeRange; // e.g. "08:30 - 09:15"
  final String subject;
  final String teacher;
  final String room;

  PeriodSlot({
    required this.periodNumber,
    required this.timeRange,
    required this.subject,
    required this.teacher,
    required this.room,
  });
}

class DaySchedule {
  final String dayOfWeek; // 'Monday', 'Tuesday', etc.
  final List<PeriodSlot> periods;

  DaySchedule({
    required this.dayOfWeek,
    required this.periods,
  });
}

