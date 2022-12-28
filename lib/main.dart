import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'src/home.dart';

import 'firebase_options.dart';

void main() {
  runApp(
    App()
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign In with Apple example',
      theme: ThemeData(colorScheme: ColorScheme.light()),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<LoginPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In with Google'),
        backgroundColor: Colors.lightBlue[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                signInWithGoogle(context);
              },
              child: Text('Login with Google')
            )
          ]
        )
      )
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final firebaseCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    var uid = firebaseCredential.user?.uid;
    print("Signed in with id: $uid");
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => HomePage()
      ),
    );
  }


  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> init() async {
    print("Init Firebase App");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}