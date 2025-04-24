import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import '/services/auth_service.dart';
import 'welcome_screen.dart';

class SettingsScreen extends StatefulWidget {
  final AppTheme selectedTheme;
  final ValueChanged<AppTheme> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final authService = AuthService();
  User? currentUser = FirebaseAuth.instance.currentUser;


  //logout functionality
  void logout() async {
    await authService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (_) => const WelcomeScreen()), (route) => false,
    );
  }

  //creating the list of themes
  @override
  Widget build(BuildContext context) {
    final themeOptions = {
      AppTheme.light: 'Light Theme',
      AppTheme.dark: 'Dark Theme',
      AppTheme.highContrast: 'High Contrast',
      AppTheme.redBlack: 'Red & Black',
      AppTheme.redWhite: 'Red & White',
      AppTheme.yellowBlack: 'Yellow & Black',
      AppTheme.yellowWhite: 'Yellow & White',
    };

    //styling of the screen
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          DropdownButtonFormField<AppTheme>(
            value: widget.selectedTheme,
            decoration: InputDecoration(
              labelText: 'Theme Mode',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest
            ),
            items: themeOptions.entries.map((entry) {
              return DropdownMenuItem<AppTheme>(value: entry.key, child: Text(entry.value));}).toList(),
            onChanged: (value) {
              if (value != null) widget.onThemeChanged(value);
            }
          ),
          const Divider(height: 32),
          const Text('Account',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(leading: const Icon(Icons.email), title: Text(currentUser?.email ?? 'Unknown user')),
          ListTile(leading: const Icon(Icons.logout), title: const Text('Log Out'), onTap: logout)
        ]
      )
    );
  }
}
