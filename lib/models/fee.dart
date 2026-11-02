enum FeeStatus {
  paid,
  pending,
  overdue,
}

class FeeInvoice {
  final String id;
  final String invoiceNumber;
  final String studentId;
  final String studentName;
  final String grade;
  final String feeType; // 'Tuition', 'Transportation', 'Lab', 'Exam'
  final double amount;
  final double paidAmount;
  final DateTime dueDate;
  final DateTime? paymentDate;
  final String paymentMethod; // 'Credit Card', 'Bank Transfer', 'Cash'
  final FeeStatus status;

  FeeInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.studentId,
    required this.studentName,
    required this.grade,
    required this.feeType,
    required this.amount,
    required this.paidAmount,
    required this.dueDate,
    this.paymentDate,
    this.paymentMethod = 'Bank Transfer',
    required this.status,
  });

  double get balance => amount - paidAmount;

  FeeInvoice copyWith({
    String? id,
    String? invoiceNumber,
    String? studentId,
    String? studentName,
    String? grade,
    String? feeType,
    double? amount,
    double? paidAmount,
    DateTime? dueDate,
    DateTime? paymentDate,
    String? paymentMethod,
    FeeStatus? status,
  }) {
    return FeeInvoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      grade: grade ?? this.grade,
      feeType: feeType ?? this.feeType,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      dueDate: dueDate ?? this.dueDate,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
    );
  }
}

