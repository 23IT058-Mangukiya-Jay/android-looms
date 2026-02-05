import 'package:flutter/material.dart';
import '../models/machine_model.dart';
import '../services/database_service.dart';
import 'add_edit_machine_screen.dart';

class MachineListScreen extends StatelessWidget {
  const MachineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Machines (Looms)'),
      ),
      body: StreamBuilder<List<Machine>>(
        stream: DatabaseService().getMachines(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final machines = snapshot.data ?? [];

          if (machines.isEmpty) {
            return const Center(child: Text('No machines found.'));
          }

          return ListView.builder(
            itemCount: machines.length,
            itemBuilder: (context, index) {
              final machine = machines[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(
                      '${machine.machineCode} - ${machine.machineName}'),
                  subtitle: Text(
                      'Type: ${machine.machineType} | Status: ${machine.status}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddEditMachineScreen(machine: machine),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDelete(context, machine);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditMachineScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Machine machine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Machine'),
        content: Text(
            'Are you sure you want to delete ${machine.machineCode}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseService().deleteMachine(machine.id);
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
