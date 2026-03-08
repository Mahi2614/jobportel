import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/view/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCgB5i0euTbSQGo3c61QjkVVp63tDny3g4",
      appId: "1:110366584931:android:5ccbd18ea7334c3947c856",
      messagingSenderId: "110366584931",
      projectId: "jobportel-dd4d7",
    ),
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}
