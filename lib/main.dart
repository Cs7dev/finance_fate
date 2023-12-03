import 'dart:io';
import 'package:flutter/material.dart';
import 'login_page.dart'; // Import your login page file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Set the initial page to Login Page
    );
  }
}
