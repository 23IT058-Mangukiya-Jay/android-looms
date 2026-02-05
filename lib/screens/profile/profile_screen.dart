import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              user?.displayName ?? 'User Name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? 'email@example.com',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(user?.email ?? 'N/A'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.badge),
              title: Text('Role'),
              subtitle: Text('Owner'), // Dummy role for now as firebase user doesn't strictly have it in basic object
            ),
             const Divider(),
            ListTile(
               leading: const Icon(Icons.settings),
               title: const Text('Settings'),
               trailing: const Icon(Icons.arrow_forward_ios),
               onTap: () {},
            ),
             const Divider(),
             const SizedBox(height: 20),
             ElevatedButton(
               onPressed: () {},
               child: const Text('Edit Profile'),
             )
          ],
        ),
      ),
    );
  }
}
