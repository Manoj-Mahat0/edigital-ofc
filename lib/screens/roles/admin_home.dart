import 'package:flutter/material.dart';
import 'common.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: roleAppBar('Admin Dashboard', context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                SizedBox(width: 260, child: StatCard(label: 'Active Users', value: '1,248', icon: Icons.people, color: Colors.blue)),
                SizedBox(width: 260, child: StatCard(label: 'Projects', value: '87', icon: Icons.folder, color: Colors.purple)),
                SizedBox(width: 260, child: StatCard(label: 'Revenue', value: '₹ 12.4L', icon: Icons.currency_rupee, color: Colors.green)),
                SizedBox(width: 260, child: StatCard(label: 'Reports', value: '23', icon: Icons.assessment, color: Colors.orange)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 2,
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: const [
                    ListTile(leading: Icon(Icons.security), title: Text('Audit Logs'), subtitle: Text('Review latest activities')),
                    Divider(height: 1),
                    ListTile(leading: Icon(Icons.group_add), title: Text('Pending Approvals'), subtitle: Text('3 new join requests')),
                    Divider(height: 1),
                    ListTile(leading: Icon(Icons.settings), title: Text('System Settings'), subtitle: Text('Manage roles & permissions')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

