import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('access_token');
  await prefs.remove('role');
  await prefs.remove('id');
  await prefs.remove('full_name');
  if (context.mounted) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}

PreferredSizeWidget _roleAppBar(String title, BuildContext context) {
  return AppBar(
    title: Text(title),
    actions: [
      IconButton(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    ],
  );
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({super.key, required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ]),
          ],
        ),
      ),
    );
  }
}

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _roleAppBar('Admin Dashboard', context),
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

class DeveloperHome extends StatelessWidget {
  const DeveloperHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _roleAppBar('Developer Workspace', context) as AppBar,
        body: Column(
          children: [
            const TabBar(tabs: [Tab(text: 'My Projects'), Tab(text: 'Tasks')]),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    children: const [
                      ListTile(leading: Icon(Icons.code), title: Text('Mobile App'), subtitle: Text('Flutter • main • 3 open PRs')),
                      Divider(height: 1),
                      ListTile(leading: Icon(Icons.code), title: Text('Backend API'), subtitle: Text('Dart • develop • 5 issues')),
                      Divider(height: 1),
                      ListTile(leading: Icon(Icons.code), title: Text('Web Admin'), subtitle: Text('React • staging • 1 open PR')),
                    ],
                  ),
                  ListView(
                    children: const [
                      CheckboxListTile(value: false, onChanged: null, title: Text('Implement login flow')),
                      Divider(height: 1),
                      CheckboxListTile(value: false, onChanged: null, title: Text('Fix failing unit tests')),
                      Divider(height: 1),
                      CheckboxListTile(value: true, onChanged: null, title: Text('Refactor API client')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TesterHome extends StatelessWidget {
  const TesterHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _roleAppBar('QA & Testing', context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: const [
                  ListTile(leading: Icon(Icons.bug_report), title: Text('Regression Suite'), subtitle: Text('120 tests • last run 2h ago')),
                  Divider(height: 1),
                  ListTile(leading: Icon(Icons.memory), title: Text('Smoke Tests'), subtitle: Text('24 tests • last run 15m ago')),
                  Divider(height: 1),
                  ListTile(leading: Icon(Icons.check_circle), title: Text('E2E Checkout'), subtitle: Text('12 tests • stable')), 
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.play_arrow), label: const Text('Run All Tests')),
            ),
          ],
        ),
      ),
    );
  }
}

class StaffHome extends StatelessWidget {
  const StaffHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _roleAppBar('Staff Portal', context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Attendance', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text('Present: 20  Absent: 2  Leave: 1'),
                ])))),
                const SizedBox(width: 12),
                Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Announcements', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text('Town hall on Friday 4 PM'),
                ])))),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: ListView(
                  children: const [
                    ListTile(leading: Icon(Icons.event), title: Text('Meeting with HR'), subtitle: Text('Tomorrow 11:00 AM')),
                    Divider(height: 1),
                    ListTile(leading: Icon(Icons.school), title: Text('Training: Communication Skills'), subtitle: Text('Monday 3:00 PM')),
                  ],
                ),
              ),
            ),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.time_to_leave), label: const Text('Apply Leave'))),
          ],
        ),
      ),
    );
  }
}

class SEOHome extends StatelessWidget {
  const SEOHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _roleAppBar('SEO Analytics', context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: const [
                  Text('Organic Traffic'),
                  SizedBox(height: 8),
                  LinearProgressIndicator(value: 0.72),
                  SizedBox(height: 6),
                  Text('72% of monthly goal'),
                ])))),
                const SizedBox(width: 12),
                Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: const [
                  Text('Keyword Rankings'),
                  SizedBox(height: 8),
                  LinearProgressIndicator(value: 0.45),
                  SizedBox(height: 6),
                  Text('45% top-10 keywords'),
                ])))),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: ListView(
                  children: const [
                    ListTile(leading: Icon(Icons.trending_up), title: Text('Brand - position 3'), subtitle: Text('Improved by 2 positions')),
                    Divider(height: 1),
                    ListTile(leading: Icon(Icons.trending_down), title: Text('Marketing tool - position 18'), subtitle: Text('Dropped by 1 position')),
                    Divider(height: 1),
                    ListTile(leading: Icon(Icons.link), title: Text('New backlinks: 12'), subtitle: Text('From 5 domains')),
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

class AccountantHome extends StatelessWidget {
  const AccountantHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _roleAppBar('Accounts & Finance', context),
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

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _roleAppBar('Student Dashboard', context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Courses', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _courseCard(context, 'Flutter Basics', 0.6),
                _courseCard(context, 'Dart Advanced', 0.3),
                _courseCard(context, 'UI/UX Design', 0.85),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: ListView(
                  children: const [
                    ListTile(leading: Icon(Icons.assignment), title: Text('Assignment: Build a Login UI'), subtitle: Text('Due: Friday')),
                    Divider(height: 1),
                    ListTile(leading: Icon(Icons.quiz), title: Text('Quiz: Widgets Basics'), subtitle: Text('Available now')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _courseCard(BuildContext context, String title, double progress) {
    return SizedBox(
      width: 260,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 6),
            Text('${(progress * 100).toStringAsFixed(0)}% complete'),
          ]),
        ),
      ),
    );
  }
}

