import 'package:flutter/material.dart';
import 'package:treino_tabuada/ui/views/TelaLogin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treinar Tabuada',
      home: const TelaLogin(),
    );
  }
}