import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../models/user_model.dart';
import 'add_edit_user_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
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

  void _deleteUser(String id) {
    setState(() {
      users.removeWhere((u) => u.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User deleted')),
    );
  }

  Future<void> _navigateToAddEdit([User? user]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditUserScreen(user: user),
      ),
    );

    if (result != null && result is User) {
      setState(() {
        if (user == null) {
          users.add(result);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User added')),
          );
        } else {
          final index = users.indexWhere((u) => u.id == user.id);
          if (index != -1) {
            users[index] = result;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User updated')),
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _navigateToAddEdit(user),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteUser(user.id),
                  ),
                ],
              ),
              onTap: () => _navigateToAddEdit(user),
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
