import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../models/worker_model.dart';
import 'add_edit_worker_screen.dart';

class WorkerListScreen extends StatelessWidget {
  const WorkerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<Worker> workers = [
      Worker(
        id: '1',
        name: 'Rajesh Kumar',
        workerCode: 'W001',
        workerType: 'Permanent',
        shift: 'Day',
        phone: '9876543210',
      ),
      Worker(
        id: '2',
        name: 'Suresh Singh',
        workerCode: 'W002',
        workerType: 'Temporary',
        shift: 'Night',
      ),
      Worker(
        id: '3',
        name: 'Mahesh Babu',
        workerCode: 'W003',
        workerType: 'Permanent',
        shift: 'Both',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workers'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: workers.length,
        itemBuilder: (context, index) {
          final worker = workers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              title: Text('${worker.name} (${worker.workerCode})'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('${worker.workerType} | ${worker.shift} Shift'),
                   if (worker.phone != null) Text('Phone: ${worker.phone}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditWorkerScreen(workerId: worker.id),
                        ),
                      );
                    },
                  ),
                  const IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: null, // Demo
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditWorkerScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
