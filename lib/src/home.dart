import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../firebase_options.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {

  String? email = "";
  String? uid = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.lightBlue[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Email: $email',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'UID: $uid',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue[900],
                ),
                onPressed: () {
                  signOut(context);
                },
                child: Text('Logout')
              )
            ),
          ]
        )
      )
    );
  }

  Future<void> getData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      uid = FirebaseAuth.instance.currentUser?.uid;
      email = FirebaseAuth.instance.currentUser?.email;
      print("User's UID: $uid");
      print("User's email: $email");
      linkEmail();
    }
  }

  Future<void> sendEmailLink() async {
    var acs = ActionCodeSettings(
      url: 'https://www.brenhr.com/login',
      handleCodeInApp: true,
      androidPackageName: 'com.brenhr.gtkFlutter',
    );

    var emailAuth = 'frbtestauth01@gmail.com';
    FirebaseAuth.instance.sendSignInLinkToEmail(
        email: emailAuth, actionCodeSettings: acs)
            .catchError((onError) => print('Error sending email verification $onError'))
            .then((value) => print('Successfully sent email verification'));
  }

  Future<void> linkEmail() async {
    var emailLink = "https://frfirestore.page.link/?link=https://fr-test-auth.firebaseapp.com/__/auth/action?apiKey%3DAIzaSyB0uCLs23fFUjOE8MjPSXhASCA4qcHxlrw%26mode%3DsignIn%26oobCode%3DVNXoT7eumgRUzTO-yORRXr_nyfBz6beOP4Dvu3aMHEQAAAGBaSXV9A%26continueUrl%3Dhttps://www.brenhr.com/login%26lang%3Den&apn=com.brenhr.gtkFlutter&amv&afl=https://fr-test-auth.firebaseapp.com/__/auth/action?apiKey%3DAIzaSyB0uCLs23fFUjOE8MjPSXhASCA4qcHxlrw%26mode%3DsignIn%26oobCode%3DVNXoT7eumgRUzTO-yORRXr_nyfBz6beOP4Dvu3aMHEQAAAGBaSXV9A%26continueUrl%3Dhttps://www.brenhr.com/login%26lang%3Den";
    var email = 'frbtestauth01@gmail.com';
    final authCredential = EmailAuthProvider.credentialWithLink(email: email, emailLink: emailLink); 
    
    await FirebaseAuth.instance.currentUser?.linkWithCredential(authCredential);
  }

  void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }
}

