import 'package:flutter/material.dart';
import 'common.dart';

class SEOHome extends StatelessWidget {
  const SEOHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: roleAppBar('SEO Analytics', context),
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

