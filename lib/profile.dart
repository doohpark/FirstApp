import 'package:shrine/login.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/utils/appData.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              semanticLabel: 'logout',
            ),
            onPressed: () {
              appProfile = AppProfile(); // init login data.
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Image.network(
              appProfile.loginType == LoginType.Anonymous
                  ? "http://handong.edu/site/handong/res/img/logo.png"
                  : appProfile.user!.photoURL!,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: 24.0,
            ),
            Text(
              appProfile.user!.uid,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Divider(
              color: Colors.white,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              appProfile.loginType == LoginType.Anonymous
                  ? "Anonymous"
                  : appProfile.user!.email!,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "DooHyun Park\nI promise to take the test honestly before GOD",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
