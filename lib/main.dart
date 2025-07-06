import 'package:flutter/material.dart';
import 'screens/login_screens.dart';

void main() {
  runApp(const AppNotas());
}

class AppNotas extends StatelessWidget {
  const AppNotas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicacion de Notas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
