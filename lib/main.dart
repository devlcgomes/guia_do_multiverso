import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guia do Multiverso',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00FF88),
          secondary: const Color(0xFF00FF88),
          surface: const Color(0xFF1A1A2E),
          background: const Color(0xFF0F0F1E),
          onSurface: Colors.white,
          onBackground: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F1E),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => InjectionContainer.getCharacterBloc(),
        child: const HomePage(),
      ),
    );
  }
}
