import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleHome extends StatelessWidget {
  final String role;
  const RoleHome({super.key, required this.role});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('role');
    await prefs.remove('id');
    await prefs.remove('full_name');
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$role Home'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome, $role!', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}

class AdminHome extends RoleHome {
  const AdminHome({super.key}) : super(role: 'Admin');
}

class DeveloperHome extends RoleHome {
  const DeveloperHome({super.key}) : super(role: 'Developer');
}

class TesterHome extends RoleHome {
  const TesterHome({super.key}) : super(role: 'Tester');
}

class StaffHome extends RoleHome {
  const StaffHome({super.key}) : super(role: 'Staff');
}

class SEOHome extends RoleHome {
  const SEOHome({super.key}) : super(role: 'SEO');
}

class AccountantHome extends RoleHome {
  const AccountantHome({super.key}) : super(role: 'Accountant');
}

class StudentHome extends RoleHome {
  const StudentHome({super.key}) : super(role: 'Student');
}

