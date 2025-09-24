import 'package:flutter/material.dart';
import 'common.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: roleAppBar('Student Dashboard', context),
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

