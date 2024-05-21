import 'package:firebase_core/firebase_core.dart';
import 'package:test_drive/auth/auth_page.dart';
import 'package:test_drive/screen/add_note_screen.dart';
import 'package:test_drive/screen/home.dart';
import 'package:test_drive/widgets/task_widgets.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:test_drive/auth/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Main_Page(),
    );
  }
}