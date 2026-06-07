import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../db/database_helper.dart';
import '../models/bill_record.dart';
import '../utils/bill_calculator.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _unitsController = TextEditingController();

  String? _selectedMonth;
  double _rebatePercent = 0.0;
  double? _totalCharges;
  double? _finalCost;
  bool _calculated = false;

  final List<String> _months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  ];

  @override
  void dispose() {
    _unitsController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please select a month before calculating.'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    final units = double.tryParse(_unitsController.text);
    if (units == null || units < 1 || units > 1000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Units must be between 1 and 1000 kWh.'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    final total = BillCalculator.calculateTotalCharges(units);
    final finalCost = BillCalculator.calculateFinalCost(total, _rebatePercent);

    setState(() {
      _totalCharges = total;
      _finalCost = finalCost;
      _calculated = true;
    });
  }

  Future<void> _saveBill() async {
    if (!_calculated || _selectedMonth == null || _totalCharges == null || _finalCost == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please calculate the bill first before saving.'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    final units = double.tryParse(_unitsController.text) ?? 0;
    final record = BillRecord(
      month: _selectedMonth!,
      units: units,
      totalCharges: _totalCharges!,
      rebatePercent: _rebatePercent,
      finalCost: _finalCost!,
    );

    await DatabaseHelper().insertBill(record);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Bill saved successfully!'),
          backgroundColor: AppTheme.success,
        ),
      );
      _resetForm();
    }
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _unitsController.clear();
      _selectedMonth = null;
      _rebatePercent = 0.0;
      _totalCharges = null;
      _finalCost = null;
      _calculated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚡ E-Bill Estimator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'View Records',
            onPressed: () => Navigator.pushNamed(context, '/list'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoBanner(),
              const SizedBox(height: 16),
              _buildInputCard(),
              const SizedBox(height: 16),
              _buildRebateCard(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _calculate,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calculate'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetForm,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_calculated) ...[
                const SizedBox(height: 20),
                _buildResultCard(),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _saveBill,
                  icon: const Icon(Icons.save),
                  label: const Text('Save to Database'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Card(
      color: const Color(0xFFE3F2FD),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF90CAF9)),
      ),
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: AppTheme.primary),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Enter your electricity usage details below to estimate your monthly bill. All fields are required.',
                style: TextStyle(color: AppTheme.textDark, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Billing Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 16),
            // Month Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedMonth,
              decoration: const InputDecoration(
                labelText: 'Month',
                prefixIcon: Icon(Icons.calendar_month),
                helperText: 'Select the billing month',
              ),
              hint: const Text('Select Month'),
              items: _months.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (val) => setState(() => _selectedMonth = val),
              validator: (val) => val == null ? 'Please select a month' : null,
            ),
            const SizedBox(height: 16),
            // Units input
            TextFormField(
              controller: _unitsController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: const InputDecoration(
                labelText: 'Units Used (kWh)',
                prefixIcon: Icon(Icons.bolt),
                suffixText: 'kWh',
                helperText: 'Enter a value between 1 and 1000',
              ),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please enter units used';
                final num = double.tryParse(val);
                if (num == null) return 'Enter a valid number';
                if (num < 1) return 'Minimum is 1 kWh';
                if (num > 1000) return 'Maximum is 1000 kWh';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRebateCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rebate Percentage',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_rebatePercent.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: _rebatePercent,
              min: 0,
              max: 5,
              divisions: 10,
              label: '${_rebatePercent.toStringAsFixed(1)}%',
              activeColor: AppTheme.primary,
              onChanged: (val) => setState(() => _rebatePercent = val),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0%', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                Text('5%', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Drag the slider to set your rebate (0% – 5%)',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      color: const Color(0xFFE8F5E9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFA5D6A7), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.receipt_long, color: AppTheme.success),
                SizedBox(width: 8),
                Text(
                  'Calculation Result',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _resultRow('Month', _selectedMonth ?? '-'),
            _resultRow('Units Used', '${_unitsController.text} kWh'),
            _resultRow('Rebate', '${_rebatePercent.toStringAsFixed(1)}%'),
            _resultRow('Total Charges', 'RM ${_totalCharges!.toStringAsFixed(3)}'),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Final Cost (After Rebate)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  'RM ${_finalCost!.toStringAsFixed(3)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textMuted)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
        ],
      ),
    );
  }
}