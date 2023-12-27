// ignore_for_file: avoid_print

import 'dart:async';
import 'package:byabsha/view/viewport.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'view/login.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await Firebase.initializeApp(
    // options: FirebaseOptions.fromMap(map),
    options: const FirebaseOptions(
        apiKey: "AIzaSyBEvjc2yWblMNsrFdNf6mtelNnwVECdUn4",
        // authDomain: "xxxx",
        projectId: "byabsha-91faa",
        storageBucket: "byabsha-91faa.appspot.com",
        messagingSenderId: "607840287655",
        appId: "1:607840287655:android:e11be87e00dcc567e31482"),
  );
  // await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    late StreamSubscription<User?> user;

    // ignore: unused_element
    void initState() {
      super.initState();
      user = FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
        }
      });
    }

    @override
    // ignore: unused_element
    void dispose() {
      user.cancel();
      super.dispose();
    }

    return MaterialApp(
      title: "Flutter App",
      home: FirebaseAuth.instance.currentUser == null
          ? const Home()
          : ViewPort(user: FirebaseAuth.instance.currentUser!),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        // brightness: Brightness.dark,
        primaryColor: const Color(0xFF5138ED),

        // Define the default font family.
        fontFamily: 'BreezeSans',
      ),
    );
  }
}
