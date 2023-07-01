import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shrine/utils/appData.dart';
import 'package:sign_in_button/sign_in_button.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

void addUserToDB(String uid) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {
    if (!value.exists) {
      //print("need to append user");
      FirebaseFirestore.instance.collection('users').doc(uid).set(
        {
          'likes': [],
          'uid': appProfile.user!.uid,
          'email': appProfile.user!.email,
          'name' : appProfile.user!.displayName,
          'status' : 'I promise to take the test honestly before GOD',
        },
      );
    }
  });
}

class GoogleSigninButton extends StatelessWidget {
  const GoogleSigninButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.google,
      onPressed: () {
        _signInWithGoogle(context);
      },
    );
  }

  Future<UserCredential> _signInWithGoogle(context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final User? user = (await _auth.signInWithCredential(credential)).user;
    assert(user!.email != null);
    assert(user!.displayName != null);
    assert(!user!.isAnonymous);
    assert(await user!.getIdToken() != null);

    final User currentUser = await _auth.currentUser!;
    assert(user!.uid == currentUser.uid);

    if (user != null) {
      appProfile.user = user;
      appProfile.loginType = LoginType.Google;
      addUserToDB(user.uid);
      Navigator.popAndPushNamed(context, '/home');
    }

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

class AnonymousSigninButton extends StatelessWidget {
  AnonymousSigninButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInButtonBuilder(
      backgroundColor: Colors.blueGrey.shade700,
      onPressed: () {
        _signInAnonymously(context);
      },
      icon: Icons.question_mark,
      text: 'Sign in with Anonymous',
    );
  }

  Future _signInAnonymously(context) async {
    final User? user = (await _auth.signInAnonymously()).user;
    try {
      assert(user != null);
      assert(user!.isAnonymous);
      assert(!user!.emailVerified);
      assert(await user!.getIdToken() != null);
      print(user!.providerData.length);
      // if (Platform.isIOS) {
      //   // Anonymous auth doesn't show up as a provider on iOS
      //   assert(user!.providerData.isEmpty);
      // } else if (Platform.isAndroid) {
      //   // Anonymous auth does show up as a provider on Android
      //   assert(user!.providerData.length == 1);
      //   assert(user!.providerData[0].providerId == 'firebase');
      //   assert(user!.providerData[0].uid != null);
      //   assert(user!.providerData[0].displayName == null);
      //   assert(user!.providerData[0].photoURL == null);
      //   assert(user!.providerData[0].email == null);
      // }
      final User currentUser = _auth.currentUser!;
      assert(user!.uid == currentUser.uid);
      if (user != null) {
        appProfile.user = user;
        appProfile.loginType = LoginType.Anonymous;
        addUserToDB(user.uid);
        Navigator.popAndPushNamed(context, '/home');
      }
      // UserCredential result = await _auth.signInAnonymously();
      // User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
