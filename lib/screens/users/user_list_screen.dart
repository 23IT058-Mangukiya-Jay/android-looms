import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../models/user_model.dart';
import 'add_edit_user_screen.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<User> users = [
      User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: 'owner',
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastLogin: DateTime.now(),
      ),
      User(
        id: '2',
        name: 'Jane Smith',
        email: 'jane@example.com',
        role: 'manager',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: user.role == 'owner' ? Colors.purple[100] : Colors.green[100],
                child: Icon(
                  user.role == 'owner' ? Icons.security : Icons.person,
                  color: user.role == 'owner' ? Colors.purple : Colors.green,
                ),
              ),
              title: Text(user.name),
              subtitle: Text('${user.email}\nRole: ${user.role}'),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditUserScreen(userId: user.id),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditUserScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
