import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import '../screens/login/login_screen.dart';
import '../screens/api/api_posts_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/analytics/analytics_dashboard_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _role = 'Owner';

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('user_role') ?? 'Owner';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = _role == 'Owner';

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
          
          if (isOwner)
            _buildDrawerItem(context, 'Users', Icons.manage_accounts, const UserListScreen()),
          if (isOwner)
            _buildDrawerItem(context, 'Reports', Icons.analytics, const ReportScreen()),
          if (isOwner)
            _buildDrawerItem(context, 'Analytics', Icons.bar_chart, const AnalyticsDashboardScreen()),
            
          _buildDrawerItem(context, 'Industry Posts (API)', Icons.rss_feed, const ApiPostsScreen()),
          _buildDrawerItem(context, 'Notifications', Icons.notifications_active, const NotificationsScreen()),
          const Divider(),
          if (isOwner)
            _buildDrawerItem(context, 'Settings', Icons.settings, const SettingsScreen()),
            
          _buildDrawerItem(context, 'Profile', Icons.person_outline, const ProfileScreen()),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context); // Close drawer
              await context.read<AuthService>().signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
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
        Navigator.pop(context); 
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}
