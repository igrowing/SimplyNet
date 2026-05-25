import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction,
                size: 72,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.35)),
            const SizedBox(height: 16),
            const Text('Coming soon',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text('$title will be defined in the next phase.',
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5))),
          ],
        ),
      ),
    );
  }
}
