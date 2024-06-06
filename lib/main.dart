import 'package:firebase_core/firebase_core.dart';
import 'package:test_drive/data/firestore.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:test_drive/auth/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Ensure root folder exists
  await Firestore_Datasource().ensureRootFolderExists();
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
