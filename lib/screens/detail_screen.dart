import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/bill_record.dart';
import '../utils/bill_calculator.dart';
import '../theme/app_theme.dart';

class DetailScreen extends StatefulWidget {
  final int billId;
  const DetailScreen({super.key, required this.billId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  BillRecord? _bill;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  final List<String> _months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  ];

  late String _editMonth;
  late TextEditingController _editUnitsController;
  late double _editRebate;

  @override
  void initState() {
    super.initState();
    _loadBill();
  }

  Future<void> _loadBill() async {
    final bill = await DatabaseHelper().getBillById(widget.billId);
    if (bill != null) {
      setState(() {
        _bill = bill;
        _editMonth = bill.month;
        _editUnitsController = TextEditingController(text: bill.units.toString());
        _editRebate = bill.rebatePercent;
      });
    }
  }

  Future<void> _saveEdit() async {
    if (!_formKey.currentState!.validate()) return;
    final units = double.tryParse(_editUnitsController.text) ?? 0;
    final totalCharges = BillCalculator.calculateTotalCharges(units);
    final finalCost = BillCalculator.calculateFinalCost(totalCharges, _editRebate);

    final updated = BillRecord(
      id: _bill!.id,
      month: _editMonth,
      units: units,
      totalCharges: totalCharges,
      rebatePercent: _editRebate,
      finalCost: finalCost,
    );

    await DatabaseHelper().updateBill(updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Record updated!'), backgroundColor: AppTheme.success),
      );
      setState(() => _isEditing = false);
      _loadBill();
    }
  }

  Future<void> _deleteBill() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure you want to delete this bill record? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper().deleteBill(widget.billId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🗑️ Record deleted.'), backgroundColor: AppTheme.error),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _editUnitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bill == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '✏️ Edit Record' : '📄 Bill Detail'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit',
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: _deleteBill,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _isEditing ? _buildEditForm() : _buildDetailView(),
      ),
    );
  }

  Widget _buildDetailView() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bill Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const Divider(height: 24),
            _detailRow(Icons.calendar_month, 'Month', _bill!.month),
            _detailRow(Icons.bolt, 'Units Used', '${_bill!.units.toStringAsFixed(1)} kWh'),
            _detailRow(Icons.percent, 'Rebate', '${_bill!.rebatePercent.toStringAsFixed(1)}%'),
            _detailRow(Icons.receipt, 'Total Charges', 'RM ${_bill!.totalCharges.toStringAsFixed(3)}'),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.price_check, color: AppTheme.primary),
                  const SizedBox(width: 12),
                  const Text('Final Cost', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  Text(
                    'RM ${_bill!.finalCost.toStringAsFixed(3)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accent, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppTheme.textMuted)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _editMonth,
                    decoration: const InputDecoration(
                      labelText: 'Month',
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                    items: _months.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) => setState(() => _editMonth = val!),
                    validator: (val) => val == null ? 'Please select a month' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _editUnitsController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Units Used (kWh)',
                      prefixIcon: Icon(Icons.bolt),
                      suffixText: 'kWh',
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Required';
                      final n = double.tryParse(val);
                      if (n == null) return 'Invalid number';
                      if (n < 1 || n > 1000) return 'Must be 1–1000';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Rebate %', style: TextStyle(color: AppTheme.textMuted)),
                      Text('${_editRebate.toStringAsFixed(1)}%',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                    ],
                  ),
                  Slider(
                    value: _editRebate,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: '${_editRebate.toStringAsFixed(1)}%',
                    activeColor: AppTheme.primary,
                    onChanged: (val) => setState(() => _editRebate = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveEdit,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _isEditing = false),
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}