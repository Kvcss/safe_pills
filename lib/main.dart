import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safe_pills/repository/pills_repository.dart';
import 'package:safe_pills/screen/homeView.dart';
import 'package:safe_pills/screen/homeViewModel.dart';
import 'repository/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pillsRepository = PillsRepository();
    final pillsViewModel = PillsViewModel(pillsRepository);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safe Pills',
      theme: ThemeData(
        primaryColor: const Color(0xFF2B998B), 
        scaffoldBackgroundColor: Colors.white, 
      ),
      home: HomeView(viewModel: pillsViewModel), 
    );
  }
}