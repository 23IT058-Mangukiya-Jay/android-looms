import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/machine_list_screen.dart';
import '../screens/productions/production_list_screen.dart';
import '../screens/qualities/quality_list_screen.dart';
import '../screens/takas/taka_list_screen.dart';
import '../screens/workers/worker_list_screen.dart';
import '../screens/users/user_list_screen.dart';
import '../screens/reports/report_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
// import '../screens/login/login_screen.dart'; // Handled by auth wrapper usually

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           UserAccountsDrawerHeader(
            accountName: Text(context.read<AuthService>().currentUser?.displayName ?? 'User'),
            accountEmail: Text(context.read<AuthService>().currentUser?.email ?? ''),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
             decoration: const BoxDecoration(
               color: Colors.blue,
             ),
          ),
          _buildDrawerItem(context, 'Dashboard', Icons.dashboard, const DashboardScreen()),
          _buildDrawerItem(context, 'Machines', Icons.precision_manufacturing, const MachineListScreen()),
          _buildDrawerItem(context, 'Productions', Icons.factory, const ProductionListScreen()),
          _buildDrawerItem(context, 'Qualities', Icons.grade, const QualityListScreen()),
          _buildDrawerItem(context, 'Takas', Icons.inventory, const TakaListScreen()),
          _buildDrawerItem(context, 'Workers', Icons.people, const WorkerListScreen()),
          _buildDrawerItem(context, 'Users', Icons.manage_accounts, const UserListScreen()),
          _buildDrawerItem(context, 'Reports', Icons.analytics, const ReportScreen()),
          const Divider(),
          _buildDrawerItem(context, 'Settings', Icons.settings, const SettingsScreen()),
          _buildDrawerItem(context, 'Profile', Icons.person_outline, const ProfileScreen()),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context); // Close drawer
              await context.read<AuthService>().signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, Widget screen) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close drawer
        // Navigate only if the new route is different? 
        // For simplicity, we just pushReplacement.
        // To avoid animation/stack issues, we could check runtimeType but replacement is safe for now.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}
