import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 120),
        children: [
          Text('Appearance', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('System Default'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement theme toggle logic in Riverpod
            },
          ),
          const Divider(),
          const SizedBox(height: 24),
          Text('About', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 16),
          const ListTile(
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
