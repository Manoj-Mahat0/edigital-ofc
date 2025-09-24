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
    this.duration = const Duration(milliseconds: 450),
  });

  @override
  State<SimpleFlipCard> createState() => _SimpleFlipCardState();
}

class _SimpleFlipCardState extends State<SimpleFlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _front = true;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    super.initState();
  }

  void _toggle() {
    if (_front) _controller.forward();
    else _controller.reverse();
    _front = !_front;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = 12.0;
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (ctx, child) {
          final angle = _controller.value * pi;
          final isBack = angle > (pi / 2);
          final transform = Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle);
          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: Colors.grey.shade800),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 6))],
              ),
              child: isBack ? Transform(
                transform: Matrix4.identity()..rotateY(pi),
                alignment: Alignment.center,
                child: _back(borderRadius),
              ) : _frontSide(borderRadius),
            ),
          );
        },
      ),
    );
  }

  Widget _frontSide(double r) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(widget.imageUrl, fit: BoxFit.cover, errorBuilder: (_,__,___)=>Container(color: Colors.grey.shade900)),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.black54, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
            ),
          ),
          Positioned(bottom: 8, left: 8, right: 8, child: Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _back(double r) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: Container(
        color: Colors.grey.shade900,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.check_circle_outline, size: 28, color: Colors.blue.shade300),
          const SizedBox(height: 6),
          Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Tap to flip back', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _codeCtl = TextEditingController();
  final TextEditingController _passCtl = TextEditingController();
  final TextEditingController _confirmCtl = TextEditingController();
  String? _role;
  String? _error;
  String? _success;
  bool _loading = false;
  bool _termsChecked = false;

  final List<Map<String, String>> _cards = const [
    {'img': 'https://randomuser.me/api/portraits/men/11.jpg', 'title': 'Collab'},
    {'img': 'https://randomuser.me/api/portraits/women/12.jpg', 'title': 'Grow'},
    {'img': 'https://randomuser.me/api/portraits/men/13.jpg', 'title': 'Plan'},
    {'img': 'https://randomuser.me/api/portraits/women/14.jpg', 'title': 'Share'},
    {'img': 'https://randomuser.me/api/portraits/group/1.jpg', 'title': 'Teamwork'},
    {'img': 'https://randomuser.me/api/portraits/men/15.jpg', 'title': 'Secure'},
    {'img': 'https://randomuser.me/api/portraits/women/16.jpg', 'title': 'Learn'},
    {'img': 'https://randomuser.me/api/portraits/women/17.jpg', 'title': 'Create'},
    {'img': 'https://randomuser.me/api/portraits/group/2.jpg', 'title': 'Success'},
  ];

  Future<void> _handleSignup() async {
    setState(() {
      _error = null;
      _success = null;
    });

    final String code = _codeCtl.text.trim();
    final String pass = _passCtl.text;
    final String confirm = _confirmCtl.text;

    if (pass != confirm) {
      setState(() => _error = 'Passwords do not match!');
      return;
    }
    if ((_role ?? '').isEmpty) {
      setState(() => _error = 'Please select a role!');
      return;
    }
    if (!_termsChecked) {
      setState(() => _error = 'Please accept Terms & Privacy');
      return;
    }

    setState(() => _loading = true);

    try {
      final resp = await API.dio.post('/invites/signup', data: {
        'code': code,
        'password': pass,
        'role': _role,
      });
      final data = resp.data as Map<String, dynamic>;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', (data['role'] ?? '').toString());
      await prefs.setString('code', (data['code'] ?? '').toString());

      setState(() => _success = (data['message'] ?? 'Signed up successfully').toString());

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) Navigator.of(context).pushReplacementNamed('/login');
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _codeCtl.dispose();
    _passCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF0F1724), Color(0xFF000000), Color(0xFF111827)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Card(
              color: Colors.black.withOpacity(0.25),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 16,
              child: SizedBox(
                height: 680,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Text('E-Digital', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blue.shade300, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Text('Create an Account ✨', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(children: [
                                Text("Already have an account?", style: TextStyle(color: Colors.grey.shade400)),
                                TextButton(onPressed: () => Navigator.of(context).pushReplacementNamed('/login'), child: const Text('Log In')),
                              ]),
                              if (_error != null) ...[
                                const SizedBox(height: 6),
                                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                              ],
                              if (_success != null) ...[
                                const SizedBox(height: 6),
                                Text(_success!, style: const TextStyle(color: Colors.greenAccent)),
                              ],
                              const SizedBox(height: 12),
                              TextField(
                                controller: _codeCtl,
                                decoration: InputDecoration(
                                  hintText: 'Invite Code',
                                  filled: true,
                                  fillColor: Colors.grey.shade900,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _role,
                                    hint: const Text('Select Role', style: TextStyle(color: Colors.white70)),
                                    isExpanded: true,
                                    items: const [
                                      'Developer','Tester','SEO','HR','Accountant','Student','Staff','Intern'
                                    ].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                                    onChanged: (v) => setState(() => _role = v),
                                    dropdownColor: Colors.grey.shade900,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _passCtl,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  filled: true,
                                  fillColor: Colors.grey.shade900,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _confirmCtl,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  filled: true,
                                  fillColor: Colors.grey.shade900,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _termsChecked,
                                    onChanged: (v) => setState(() => _termsChecked = v ?? false),
                                    activeColor: Colors.blue,
                                  ),
                                  const Expanded(
                                    child: Text('I agree to the Terms & Privacy', style: TextStyle(color: Colors.white70)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _handleSignup,
                                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  child: _loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Sign Up'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    LayoutBuilder(builder: (context, constraints) {
                      if (constraints.maxWidth < 800) return const SizedBox.shrink();
                      return Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.grey.shade900, Colors.black87]),
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                          ),
                          child: GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            children: _cards.map((c) {
                              return Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                child: SimpleFlipCard(imageUrl: c['img'] ?? '', title: c['title'] ?? ''),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }),
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

