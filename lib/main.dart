import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/list_screen.dart';
import 'screens/about_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ElectricityBillApp());
}

class ElectricityBillApp extends StatelessWidget {
  const ElectricityBillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Bill Estimator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/list': (context) => const ListScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}