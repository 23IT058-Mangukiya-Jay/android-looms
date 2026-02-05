import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../models/production_model.dart';
import 'add_edit_production_screen.dart';

class ProductionListScreen extends StatelessWidget {
  const ProductionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<Production> productions = [
      Production(
        id: '1',
        date: DateTime.now(),
        machineId: 'm1',
        machineName: 'Loom 01',
        workerId: 'w1',
        workerName: 'Ram Kumar',
        takaId: 't1',
        takaNumber: 'Taka-101',
        shift: 'Day',
        metersProduced: 120.5,
        earnings: 1205.0,
      ),
      Production(
        id: '2',
        date: DateTime.now().subtract(const Duration(days: 1)),
        machineId: 'm2',
        machineName: 'Loom 02',
        workerId: 'w2',
        workerName: 'Shyam Singh',
        takaId: 't2',
        takaNumber: 'Taka-102',
        shift: 'Night',
        metersProduced: 115.0,
        earnings: 1150.0,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productions'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: productions.length,
        itemBuilder: (context, index) {
          final production = productions[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: production.shift == 'Day' ? Colors.orange[100] : Colors.blue[100],
                child: Icon(
                  production.shift == 'Day' ? Icons.wb_sunny : Icons.nightlight_round,
                  color: production.shift == 'Day' ? Colors.orange : Colors.blue,
                ),
              ),
              title: Text('${production.machineName} - ${production.workerName}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Taka: ${production.takaNumber} | Mtrs: ${production.metersProduced}'),
                  Text(
                    'Date: ${production.date.toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Text(
                '₹${production.earnings.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                 // Edit in future
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditProductionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
