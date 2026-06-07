import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/bill_record.dart';
import '../theme/app_theme.dart';
import 'detail_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<BillRecord>> _billsFuture;

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  void _loadBills() {
    setState(() {
      _billsFuture = DatabaseHelper().getAllBills();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Bill Records'),
      ),
      body: FutureBuilder<List<BillRecord>>(
        future: _billsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final bills = snapshot.data ?? [];
          if (bills.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: AppTheme.textMuted),
                  SizedBox(height: 16),
                  Text(
                    'No records yet.\nCalculate and save a bill first.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bills.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final bill = bills[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primary,
                    child: Text(
                      bill.month.substring(0, 3),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    bill.month,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark),
                  ),
                  subtitle: const Text('Tap to view details'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'RM ${bill.finalCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                          fontSize: 16,
                        ),
                      ),
                      const Text('Final Cost', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                    ],
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(billId: bill.id!),
                      ),
                    );
                    _loadBills();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}