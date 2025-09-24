import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';

class SimpleFlipCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final Duration duration;

  const SimpleFlipCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<SimpleFlipCard> createState() => _SimpleFlipCardState();
}

class _SimpleFlipCardState extends State<SimpleFlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
  }

  void _toggle() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double borderRadius = 14;
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);
          final isShowingBack = angle > (pi / 2);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: Colors.grey.shade800),
                color: Colors.white.withOpacity(0.02),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: isShowingBack
                  ? Transform(
                      transform: Matrix4.identity()..rotateY(pi),
                      alignment: Alignment.center,
                      child: _backSide(borderRadius),
                    )
                  : _frontSide(borderRadius),
            ),
          );
        },
      ),
    );
  }

  Widget _frontSide(double borderRadius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade900),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.55), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backSide(double borderRadius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.grey.shade900,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.workspace_premium, size: 28, color: Colors.blue.shade300),
            const SizedBox(height: 8),
            Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text(
              'Tap to flip back',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCtl = TextEditingController();
  final TextEditingController _passCtl = TextEditingController();
  String? _error;
  bool _loading = false;
  bool _keepLoggedIn = false;

  final List<Map<String, String>> _cards = const [
    {'img': 'https://randomuser.me/api/portraits/men/32.jpg', 'title': 'Manage'},
    {'img': 'https://randomuser.me/api/portraits/men/45.jpg', 'title': 'Time'},
    {'img': 'https://randomuser.me/api/portraits/women/50.jpg', 'title': 'Team'},
    {'img': 'https://randomuser.me/api/portraits/women/52.jpg', 'title': 'Chat'},
    {'img': 'https://randomuser.me/api/portraits/group/3.jpg', 'title': 'Tasks'},
    {'img': 'https://randomuser.me/api/portraits/men/40.jpg', 'title': 'Files'},
    {'img': 'https://randomuser.me/api/portraits/men/60.jpg', 'title': 'Calendar'},
    {'img': 'https://randomuser.me/api/portraits/women/61.jpg', 'title': 'Notes'},
    {'img': 'https://randomuser.me/api/portraits/group/4.jpg', 'title': 'Projects'},
  ];

  Future<void> _handleLogin() async {
    final String email = _emailCtl.text.trim();
    final String password = _passCtl.text;

    setState(() {
      _error = null;
    });

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Please provide email and password';
      });
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final resp = await API.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final data = resp.data as Map<String, dynamic>;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', (data['access_token'] ?? '').toString());
      await prefs.setString('role', (data['role'] ?? '').toString());
      await prefs.setString('id', (data['id'] ?? '').toString());
      await prefs.setString('full_name', (data['full_name'] ?? '').toString());

      final String role = (data['role'] ?? '').toString();
      String route = '/';
      if (role == 'Admin') route = '/admin';
      else if (role == 'Developer') route = '/developer';
      else if (role == 'Tester') route = '/tester';
      else if (role == 'Staff') route = '/staff';
      else if (role == 'SEO') route = '/seo';
      else if (role == 'Accountant') route = '/accountant';
      else if (role == 'Student') route = '/student';
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(route);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0f1724), Color(0xff000000), Color(0xff111827)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Card(
              color: Colors.black.withOpacity(0.25),
              elevation: 16,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: SizedBox(
                height: 640,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Text('E-Digital', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blue.shade300, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text('Welcome Back', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  const Text('👋', style: TextStyle(fontSize: 28)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text("Don't have an account?", style: TextStyle(color: Colors.grey.shade400)),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pushNamed('/signup'),
                                    child: const Text('Sign Up'),
                                  ),
                                ],
                              ),
                              if (_error != null) ...[
                                const SizedBox(height: 8),
                                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                              ],
                              const SizedBox(height: 14),
                              TextField(
                                controller: _emailCtl,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'user@example.com',
                                  filled: true,
                                  fillColor: Colors.grey.shade900,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _passCtl,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  filled: true,
                                  fillColor: Colors.grey.shade900,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    elevation: 8,
                                  ),
                                  child: _loading
                                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                      : const Text('Log In'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _keepLoggedIn,
                                        onChanged: (v) => setState(() => _keepLoggedIn = v ?? false),
                                        activeColor: Colors.blue,
                                      ),
                                      const Text('Keep me logged in', style: TextStyle(color: Colors.white70)),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('Forgot password?'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final totalWidth = MediaQuery.of(context).size.width;
                          if (totalWidth < 800) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Colors.grey.shade900, Colors.black87]),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: GridView.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              children: _cards.map((c) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: SimpleFlipCard(
                                    imageUrl: c['img'] ?? '',
                                    title: c['title'] ?? '',
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

