import 'package:flutter/material.dart';
import 'common.dart';

class AccountantHome extends StatelessWidget {
  const AccountantHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: roleAppBar('Accounts & Finance', context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(spacing: 8, runSpacing: 8, children: const [
              Chip(label: Text('Invoices: 42')),
              Chip(label: Text('Paid: 31')),
              Chip(label: Text('Overdue: 5')),
              Chip(label: Text('Expenses: ₹ 2.1L')),
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: ListView(
                  children: const [
                    ListTile(leading: Icon(Icons.receipt_long), title: Text('INV-1042'), trailing: Text('₹ 12,000'), subtitle: Text('Due: 25 Sep')),
                    Divider(height: 1),
                    ListTile(leading: Icon(Icons.receipt_long), title: Text('INV-1039'), trailing: Text('₹ 7,500'), subtitle: Text('Paid')),
                    Divider(height: 1),
                    ListTile(leading: Icon(Icons.trending_down), title: Text('Expense - Hosting'), trailing: Text('₹ 2,999'), subtitle: Text('Sep 12')),
                  ],
                ),
              ),
            ),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('New Invoice'))),
          ],
        ),
      ),
    );
  }
}

