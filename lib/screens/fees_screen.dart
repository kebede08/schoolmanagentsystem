import 'package:flutter/material.dart';
import '../services/school_state.dart';
import '../models/fee.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';
import '../widgets/stat_card.dart';

class FeesScreen extends StatefulWidget {
  final SchoolState state;

  const FeesScreen({super.key, required this.state});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  String _statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = widget.state.invoices.where((inv) {
      if (_statusFilter == 'Paid') return inv.status == FeeStatus.paid;
      if (_statusFilter == 'Pending') return inv.status == FeeStatus.pending;
      if (_statusFilter == 'Overdue') return inv.status == FeeStatus.overdue;
      return true;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fee Management & Billing',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track student tuition, payment status, receipts, and invoice reconciliation.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.receipt, size: 18),
                label: const Text('Create Invoice'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _showCreateInvoiceDialog(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Financial KPI Cards
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'TOTAL BILLED',
                  value: '\$${widget.state.totalFeesBilled.toStringAsFixed(0)}',
                  icon: Icons.receipt_long,
                  iconColor: AppColors.primary,
                  subtitle: 'Academic Term 1',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'TOTAL COLLECTED',
                  value: '\$${widget.state.totalFeesCollected.toStringAsFixed(0)}',
                  icon: Icons.check_circle_outline,
                  iconColor: AppColors.success,
                  trendText: '${widget.state.feeCollectionPercentage.toStringAsFixed(0)}% received',
                  isTrendPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'OUTSTANDING BALANCE',
                  value: '\$${widget.state.totalFeesPending.toStringAsFixed(0)}',
                  icon: Icons.error_outline,
                  iconColor: AppColors.danger,
                  trendText: 'Pending / Overdue',
                  isTrendPositive: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Filters
          Row(
            children: ['All', 'Paid', 'Pending', 'Overdue'].map((status) {
              final isSelected = _statusFilter == status;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(status),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() => _statusFilter = status);
                  },
                  backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                  selectedColor: AppColors.primary.withOpacity(0.18),
                  labelStyle: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Invoices Table
          Expanded(
            child: Card(
              child: filtered.isEmpty
                  ? const Center(child: Text('No fee invoices match filter.'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 28,
                          horizontalMargin: 20,
                          headingRowHeight: 48,
                          dataRowMinHeight: 64,
                          dataRowMaxHeight: 64,
                          columns: const [
                            DataColumn(label: Text('Invoice #')),
                            DataColumn(label: Text('Student Name')),
                            DataColumn(label: Text('Fee Category')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Paid')),
                            DataColumn(label: Text('Balance')),
                            DataColumn(label: Text('Due Date')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: filtered.map((inv) {
                            return DataRow(
                              cells: [
                                DataCell(Text(inv.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(inv.studentName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      Text('Grade ${inv.grade}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                                    ],
                                  ),
                                ),
                                DataCell(Text(inv.feeType)),
                                DataCell(Text('\$${inv.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Text('\$${inv.paidAmount.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold))),
                                DataCell(
                                  Text(
                                    '\$${inv.balance.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: inv.balance > 0 ? AppColors.danger : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(Text('${inv.dueDate.year}-${inv.dueDate.month.toString().padLeft(2, '0')}-${inv.dueDate.day.toString().padLeft(2, '0')}')),
                                DataCell(StatusBadge.fee(inv.status)),
                                DataCell(
                                  inv.status != FeeStatus.paid
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            minimumSize: const Size(0, 32),
                                          ),
                                          onPressed: () => _showRecordPaymentDialog(context, inv),
                                          child: const Text('Collect', style: TextStyle(fontSize: 12)),
                                        )
                                      : const Icon(Icons.check, color: AppColors.success, size: 20),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRecordPaymentDialog(BuildContext context, FeeInvoice inv) {
    final amountCtrl = TextEditingController(text: inv.balance.toStringAsFixed(0));
    String method = 'Bank Transfer';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Record Payment - ${inv.invoiceNumber}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Student: ${inv.studentName} (Grade ${inv.grade})'),
              const SizedBox(height: 6),
              Text('Remaining Balance: \$${inv.balance.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger)),
              const SizedBox(height: 16),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Payment Amount (\$) *'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: method,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                items: ['Bank Transfer', 'Credit Card', 'Cash Deposit', 'Cheque'].map((m) {
                  return DropdownMenuItem(value: m, child: Text(m));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => method = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
              onPressed: () {
                final amt = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
                if (amt > 0) {
                  widget.state.recordPayment(inv.id, amt, method);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateInvoiceDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final gradeCtrl = TextEditingController(text: '10');
    final feeTypeCtrl = TextEditingController(text: 'Tuition Fee - Term 1');
    final amountCtrl = TextEditingController(text: '2400');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Generate New Fee Invoice'),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Student Name *')),
              const SizedBox(height: 12),
              TextField(controller: gradeCtrl, decoration: const InputDecoration(labelText: 'Grade')),
              const SizedBox(height: 12),
              TextField(controller: feeTypeCtrl, decoration: const InputDecoration(labelText: 'Fee Description *')),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Total Amount (\$) *'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              final amt = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
              if (nameCtrl.text.isNotEmpty && amt > 0) {
                final newInv = FeeInvoice(
                  id: 'INV-${DateTime.now().millisecondsSinceEpoch}',
                  invoiceNumber: 'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                  studentId: 'STD-CUSTOM',
                  studentName: nameCtrl.text.trim(),
                  grade: gradeCtrl.text.trim(),
                  feeType: feeTypeCtrl.text.trim(),
                  amount: amt,
                  paidAmount: 0.0,
                  dueDate: DateTime.now().add(const Duration(days: 30)),
                  status: FeeStatus.pending,
                );
                widget.state.addInvoice(newInv);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Issue Invoice'),
          ),
        ],
      ),
    );
  }
}

