import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:shrine/utils/appData.dart';

// FirebaseStorage storage = FirebaseStorage.instanceFor(
//     bucket: storagePath
// );

FirebaseStorage storage = FirebaseStorage.instance;

Future<dynamic> uploadImage(File imageFile) async {
  //Create a reference to the location you want to upload to in firebase
  Reference reference =
      storage.ref().child("images").child(path.basename(imageFile.path));
  // Reference reference = storage.ref().child(path.basename(imageFile.path));
  print("$reference");
  //Upload the file to firebase
  return reference.putFile(imageFile);
}

Future<String> getImageURL(String filename) async {
  return await storage.ref().child('images').child(filename).getDownloadURL();
  // return await storage.ref().child(filename).getDownloadURL();
}

class Product {
  Product({
    required this.uuid,
    required this.filename,
    required this.name,
    required this.price,
    required this.desc,
    required this.likes,
    required this.uid,
    required this.created,
    required this.modified,
  })  : assert(uuid != null),
        assert(filename != null),
        assert(name != null),
        assert(price != null),
        assert(desc != null),
        assert(likes != null),
        assert(uid != null)
  //assert(created != null)
  //assert(modified != null)
  ;

  final String uuid;
  final String filename;
  final String name;
  final int price;
  final String desc;
  final int likes;
  final String uid;
  final Timestamp created;
  final Timestamp modified;
  DocumentReference? reference;

  Product.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['uuid'] != null),
        assert(map['filename'] != null),
        assert(map['name'] != null),
        assert(map['price'] != null),
        assert(map['desc'] != null),
        assert(map['likes'] != null),
        // assert(map['uid'] != null),
        //assert(map['created'] != null),
        //assert(map['modified'] != null),
        uuid = map!['uuid'],
        filename = map!['filename'],
        name = map!['name'],
        price = map!['price'],
        desc = map['desc'],
        likes = map!['likes'],
        uid = map!['uid'],
        created = map!['created'],
        modified = map!['modified'];

  Product.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  String get imagePath =>
      'gs://moappfinal-b334f.appspot.com/images/' + filename; //'$id-0.jpg';
}
