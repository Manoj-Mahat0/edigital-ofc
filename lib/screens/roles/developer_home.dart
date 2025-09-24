import 'package:flutter/material.dart';
import 'common.dart';

class DeveloperHome extends StatelessWidget {
  const DeveloperHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: roleAppBar('Developer Workspace', context),
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

