import 'package:flutter/material.dart';
import 'common.dart';

class StaffHome extends StatelessWidget {
  const StaffHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: roleAppBar('Staff Portal', context),
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

