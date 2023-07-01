import 'package:shrine/model/product.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shrine/utils/appData.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

class AddPage extends StatefulWidget {
  AddPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
  Product? product;
  File? _image;
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _priceController = new TextEditingController();
  final TextEditingController _descController = new TextEditingController();

  Future getImage() async {
    var image =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add'),
        actions: <Widget>[
          Builder(builder: (context) {
            return TextButton(
              child: Text(
                "save",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              onPressed: () async {
                // firestore save image
                if (_image != null) {
                  //await storage.ref().child("images").child(widget.product.filename).delete(); // delete
                  await uploadImage(_image as File); // upload
                  //print(path.basename(_image.path));
                  String uuid = Uuid().v1();
                  FirebaseFirestore.instance
                      .collection('product')
                      .doc(uuid)
                      .set(// with filename
                          {
                    'uuid': uuid,
                    'name': _nameController.text,
                    'price': int.parse(_priceController.text),
                    'desc': _descController.text,
                    'filename': path.basename(_image!.path),
                    'uid': appProfile.user!.uid,
                    'likes': 0,
                    'created': FieldValue.serverTimestamp(),
                    'modified': FieldValue.serverTimestamp(),
                  }).then((value) => Navigator.pop(context));
                } else {
                  // upload handong logo
                  await uploadImage(await getImageFileFromAssets('handong_logo.png'));
                  //print(path.basename(_image.path));
                  String uuid = Uuid().v1();
                  FirebaseFirestore.instance
                      .collection('product')
                      .doc(uuid)
                      .set(// with filename
                          {
                    'uuid': uuid,
                    'name': _nameController.text,
                    'price': int.parse(_priceController.text),
                    'desc': _descController.text,
                    'filename': "handong_logo.png",
                    'uid': appProfile.user!.uid,
                    'likes': 0,
                    'created': FieldValue.serverTimestamp(),
                    'modified': FieldValue.serverTimestamp(),
                  }).then((value) => Navigator.pop(context));
                }
              },
            );
          })
        ],
      ),
      body: Builder(
        builder: (context) {
          //final product = widget.product;
//          final NumberFormat formatter = NumberFormat.simpleCurrency(
//              locale: Localizations.localeOf(context).toString());

          return ListView(
            children: <Widget>[
              Column(children: <Widget>[
                _image != null
                    ? Image.file(
                        _image!,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: Image.network(
                          "https://icon-library.com/images/upload-icon-png/upload-icon-png-16.jpg",
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          color: Colors.white,
                        ),
                      ),
              ]),
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          // image picker
                          await getImage();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextField(
                                controller: _nameController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'ProductName',
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                              //Text(product.name, style: Theme.of(context).textTheme.headline5.merge(TextStyle(color: Color.fromRGBO(42, 88, 149, 1.0), fontWeight: FontWeight.bold)),),
                              SizedBox(
                                height: 12.0,
                              ),
                              TextField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Price',
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                              //Text(formatter.format(product.price), style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Colors.blueAccent))),
                              SizedBox(
                                height: 12.0,
                              ),
                              TextField(
                                controller: _descController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Description',
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //Text(product.desc, style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Colors.blueAccent)))
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
