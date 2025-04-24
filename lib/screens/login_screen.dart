import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  //text fields for email password and initialising the authservice class
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  //method to login to app
  void login() async {
    final user = await authService.login(emailController.text.trim(), passwordController.text.trim());
    if (user != null) {
      if(!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyApp()));
    } else {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login failed")));
    }
  }
  //building login page ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Login")),
          ]
        )
      )
    );
  }
}



