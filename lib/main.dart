import 'package:coviddashboard/Screen/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Corona Dashboard',
      home: 
      // Clarifia()
      HomePage(),
    );
  }
}

