import 'package:crud2a/pages/home_page.dart';
import 'package:crud2a/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String testProviderText = "Hello Provider!";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<String>(create: (context) => testProviderText),
        StreamProvider<FirebaseUser>(
            create: (context) => FirebaseAuth.instance.onAuthStateChanged)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/sign_up': (context) => RegisterPage(),
        },
      ),
    );
  }
}
