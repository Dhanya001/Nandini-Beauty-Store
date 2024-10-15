import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nandini_beauty_store/Others/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(apiKey: "AIzaSyADH5cJASv9mXl4g1FcND5m4FYRc0kRtdY",
        appId: "1:963528147030:android:2442e8ee5de12882d7bbf7",
        messagingSenderId: "963528147030",
        projectId: "nandini-beauty-store",
        storageBucket: "nandini-beauty-store.appspot.com",
      )
  );

  await Firebase.initializeApp();
  //final FirebaseStorage storage = FirebaseStorage.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.grey),
          bodySmall: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
