import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../models/quality_model.dart';
import 'add_edit_quality_screen.dart';

class QualityListScreen extends StatefulWidget {
  const QualityListScreen({super.key});

  @override
  State<QualityListScreen> createState() => _QualityListScreenState();
}

class _QualityListScreenState extends State<QualityListScreen> {
  // Dummy Data
  final List<Quality> qualities = [
    Quality(
      id: '1',
      name: 'Cotton 60s',
      ratePerMeter: 12.50,
      description: 'Standard cotton fabric',
      createdAt: DateTime.now(),
    ),
    Quality(
      id: '2',
      name: 'Polyester 40s',
      ratePerMeter: 9.75,
      description: 'Synthetic fabric for rough use',
      createdAt: DateTime.now(),
    ),
    Quality(
      id: '3',
      name: 'Silk Blend',
      ratePerMeter: 45.00,
      description: 'Premium silk blend',
      createdAt: DateTime.now(),
    ),
  ];

  void _deleteQuality(String id) {
    setState(() {
      qualities.removeWhere((q) => q.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quality deleted')),
    );
  }

  Future<void> _navigateToAddEdit([Quality? quality]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditQualityScreen(quality: quality),
      ),
    );

    if (result != null && result is Quality) {
      setState(() {
        if (quality == null) {
          qualities.add(result);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quality added')),
          );
        } else {
          final index = qualities.indexWhere((q) => q.id == quality.id);
          if (index != -1) {
            qualities[index] = result;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Quality updated')),
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qualities'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: qualities.length,
        itemBuilder: (context, index) {
          final quality = qualities[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.amber[100],
                child: const Icon(Icons.grade, color: Colors.amber),
              ),
              title: Text(quality.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(quality.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '₹${quality.ratePerMeter.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _navigateToAddEdit(quality),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteQuality(quality.id),
                  ),
                ],
              ),
              onTap: () => _navigateToAddEdit(quality),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEdit(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
