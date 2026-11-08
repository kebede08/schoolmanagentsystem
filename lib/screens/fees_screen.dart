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

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 750;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fee Management & Billing',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tuition, payment status, receipts, and invoices.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt, size: 18),
              label: const Text('Create Invoice'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _showCreateInvoiceDialog(context),
            ),
          ] else ...[
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
          ],

          const SizedBox(height: 20),

          // Financial KPI Cards (Adaptive for Mobile & Desktop)
          if (isMobile) ...[
            StatCard(
              title: 'TOTAL BILLED',
              value: '\$${widget.state.totalFeesBilled.toStringAsFixed(0)}',
              icon: Icons.receipt_long,
              iconColor: AppColors.primary,
              subtitle: 'Academic Term 1',
            ),
            const SizedBox(height: 10),
            StatCard(
              title: 'TOTAL COLLECTED',
              value: '\$${widget.state.totalFeesCollected.toStringAsFixed(0)}',
              icon: Icons.check_circle_outline,
              iconColor: AppColors.success,
              trendText: '${widget.state.feeCollectionPercentage.toStringAsFixed(0)}% received',
              isTrendPositive: true,
            ),
            const SizedBox(height: 10),
            StatCard(
              title: 'OUTSTANDING BALANCE',
              value: '\$${widget.state.totalFeesPending.toStringAsFixed(0)}',
              icon: Icons.error_outline,
              iconColor: AppColors.danger,
              trendText: 'Pending / Overdue',
              isTrendPositive: false,
            ),
          ] else ...[
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
          ],

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
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.receipt_outlined, size: 18),
                                        tooltip: 'View Official Receipt',
                                        onPressed: () => _showReceiptDialog(context, inv),
                                      ),
                                      if (inv.status != FeeStatus.paid) ...[
                                        const SizedBox(width: 4),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            minimumSize: const Size(0, 32),
                                          ),
                                          onPressed: () => _showRecordPaymentDialog(context, inv),
                                          child: const Text('Collect', style: TextStyle(fontSize: 12)),
                                        ),
                                      ],
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                                        tooltip: 'Delete Invoice',
                                        onPressed: () {
                                          widget.state.deleteInvoice(inv.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Invoice ${inv.invoiceNumber} deleted.')),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
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

  void _showReceiptDialog(BuildContext context, FeeInvoice inv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 580,
          padding: const EdgeInsets.all(28),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.receipt_long, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.state.schoolName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(widget.state.schoolAddress, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    StatusBadge.fee(inv.status),
                  ],
                ),
                const Divider(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('BILLED TO:', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(inv.studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Grade ${inv.grade} • ID: ${inv.studentId}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('RECEIPT #: ${inv.invoiceNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text('Date: ${inv.paymentDate != null ? "${inv.paymentDate!.year}-${inv.paymentDate!.month.toString().padLeft(2, '0')}-${inv.paymentDate!.day.toString().padLeft(2, '0')}" : "Pending"}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        Text('Method: ${inv.paymentMethod}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(inv.feeType, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('\$${inv.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Billed:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('\$${inv.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount Paid:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('\$${inv.paidAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Outstanding Balance:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    Text('\$${inv.balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.danger)),
                  ],
                ),
                const Divider(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Verified by Bursar Office\nOfficial Electronic Record', style: TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.success, width: 1.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        inv.status == FeeStatus.paid ? 'PAID & VERIFIED' : 'PARTIAL / PENDING',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: inv.status == FeeStatus.paid ? AppColors.success : AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton.icon(
            icon: const Icon(Icons.print, size: 16),
            label: const Text('Print Receipt'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Receipt ${inv.invoiceNumber} printed successfully.'), backgroundColor: AppColors.success),
              );
            },
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

