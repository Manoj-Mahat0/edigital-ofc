import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await API.initialize();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final role = prefs.getString('role') ?? '';

    String route = '/login';
    if (token != null && token.isNotEmpty) {
      switch (role) {
        case 'Admin':
          route = '/admin';
          break;
        case 'Developer':
          route = '/developer';
          break;
        case 'Tester':
          route = '/tester';
          break;
        case 'Staff':
          route = '/staff';
          break;
        case 'SEO':
          route = '/seo';
          break;
        case 'Accountant':
          route = '/accountant';
          break;
        case 'Student':
          route = '/student';
          break;
        default:
          route = '/login';
      }
    }

    if (!mounted) return;
    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0f1724), Color(0xff000000), Color(0xff111827)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlutterLogo(size: 84),
              SizedBox(height: 18),
              CircularProgressIndicator(strokeWidth: 2.2),
            ],
          ),
        ),
      ),
    );
  }
}

