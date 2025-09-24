import 'package:flutter/material.dart';
import 'common.dart';

class TesterHome extends StatelessWidget {
  const TesterHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: roleAppBar('QA & Testing', context),
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

