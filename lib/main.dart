import 'package:flutter/material.dart';
import 'package:ricknmorty/core/constants.dart';
import 'package:ricknmorty/di/injection.dart';
import 'package:ricknmorty/presentation/pages/character_list_page.dart';

void main() {
  setupDi();
  runApp(const RickAndMortyApp());
}

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick & Morty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.appcolor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.appcolor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: const CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
      ),
      home: const CharacterListPage(),
    );
  }
}
