import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtl = TextEditingController();
  final passCtl = TextEditingController();

  Future<void> _signup() async {
    try {
      final user = await AuthService().signUp(emailCtl.text.trim(), passCtl.text.trim());
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
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: emailCtl, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: passCtl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _signup, child: const Text('Create Account')),
        ]),
      ),
    );
  }
}
