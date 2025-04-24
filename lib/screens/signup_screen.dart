import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  //fields for email password and authservice class
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  //registration method
  void register() async {
    final user = await authService.register(emailController.text.trim(), passwordController.text.trim());
    if (!mounted) return;
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyApp()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration failed")));
    }
  }

  //styling of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: const Text("Register")),
          ]
        )
      )
    );
  }
}



