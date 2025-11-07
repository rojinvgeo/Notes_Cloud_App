import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtl = TextEditingController();
  final passCtl = TextEditingController();

  Future<void> _login() async {
    try {
      final user = await AuthService().signIn(emailCtl.text.trim(), passCtl.text.trim());
      if (user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: emailCtl, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: passCtl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _login, child: const Text('Login')),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())),
            child: const Text('Create an account'),
          ),
        ]),
      ),
    );
  }
}
