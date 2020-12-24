import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../components/body_container.dart';
import '../services/auth.dart';
import 'home.dart';
import 'sign_in.dart';

class VerifyScreen extends StatefulWidget {
  static const routeName = '/verifyScreen';

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BodyContainer(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.clipboardCheck,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 30),
            Text(
              "A email have been send to ${user.email} please verify",
              textScaleFactor: 1.3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            MaterialButton(
              height: MediaQuery.of(context).size.height * 0.065,
              minWidth: MediaQuery.of(context).size.width * 0.6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () async {
                await context.read<AuthService>().signOut();
                Navigator.pushReplacementNamed(context, SignIn.routeName);
              },
              color: Theme.of(context).accentColor,
              child: const Text(
                "SIGN OUT",
                textScaleFactor: 1.4,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    }
  }
}
