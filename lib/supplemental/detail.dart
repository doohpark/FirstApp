import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/utils/appData.dart';
import 'package:shrine/utils/cart_provider.dart';

class ProductArguments {
  final Product product;

  // final List<Product> favoriteList;

  ProductArguments(
    this.product,
    // this.favoriteList
  );
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ProductArguments;
    var cartProvider = Provider.of<CartProvider>(context);
    cartProvider.check(args.product.uuid);
    final ThemeData theme = Theme.of(context);
    var millisCreated = DateTime.fromMillisecondsSinceEpoch(
        args.product.created.millisecondsSinceEpoch);
    var millisModified = DateTime.fromMillisecondsSinceEpoch(
        args.product.created.millisecondsSinceEpoch);
    var d24Created = DateFormat('yy/MM/dd, HH:mm').format(millisCreated);
    var d24Modified = DateFormat('yy/MM/dd, HH:mm').format(millisModified);
    Size size = MediaQuery.of(context).size;
    // bool isContained = args.favoriteList.contains(args.product);

    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Detail'),
          actions: <Widget>[
            Builder(builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.edit,
                  semanticLabel: 'edit',
                ),
                onPressed: () {
                  if (args.product.uid == appProfile.user!.uid) {
                    // can edit
                    print("Can edit!");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) =>
                                EditPagePopup(product: args.product)));
                  } else {
                    //can't edit
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "You don't have permission to edit this product."),
                    ));
                  }
                },
              );
            }),
            Builder(builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.delete,
                  semanticLabel: 'delete',
                ),
                onPressed: () async {
                  if (args.product.uid == appProfile.user!.uid) {
                    // can delete
                    print("Can delete!");
                    await FirebaseFirestore.instance
                        .collection('product')
                        .doc(args.product.uuid)
                        .delete();
                    Navigator.pop(context);
                  } else {
                    //can't edit
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "You don't have permission to delete this product.")));
                  }
                },
              );
            }),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.4,
                    child: FutureBuilder(
                      future: getImageURL(args.product.filename),
                      builder: (context, AsyncSnapshot<String> value) {
                        if (!value.hasData) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Image.network(
                          value.data!,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  args.product.name,
                                  textStyle: theme.textTheme.titleLarge
                                      ?.copyWith(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                  speed: const Duration(milliseconds: 100),
                                ),
                              ],
                              repeatForever: true,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "\$  ${args.product.price}",
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(color: Colors.blue),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Divider(
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              args.product.desc,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(color: Colors.blue),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.thumb_up),
                              color: Colors.blue,
                              onPressed: () async {
                                final uuid = args.product.uuid;
                                final uid = appProfile.user!.uid;

                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .get()
                                    .then((value) {
                                  //print(value.data);
                                  List<dynamic> likes = value.data()!['likes'];
                                  //print(likes);
                                  if (likes.contains(uuid)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("You already like it!")));
                                  } else {
                                    args.product.reference!.update(
                                        {'likes': FieldValue.increment(1)});
                                    value.reference.update({
                                      'likes': FieldValue.arrayUnion([uuid])
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Like it!")));
                                  }
                                });
                              },
                            ),
                            Text(args.product.likes.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.merge(
                                      TextStyle(color: Colors.blueAccent),
                                    )),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "creator: <${args.product.uid}>",
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: Colors.blue),
                        ),
                        Text(
                          d24Created.toString() + " Created",
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: Colors.blue),
                        ),
                        Text(
                          d24Modified.toString() + " Modified",
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Consumer<CartProvider>(
          builder: (context, value, child) {
            return FloatingActionButton(
              child: cartProvider.isContained
                  ? Icon(Icons.check)
                  : Icon(Icons.shopping_cart),
              onPressed: () async {
                cartProvider.add(await getImageURL(args.product.filename),
                    args.product.name, args.product.uuid);
                cartProvider.check(args.product.uuid);
                print('added');
              },
            );
          },
        ),
      ),
    );
  }
}

class EditPagePopup extends StatefulWidget {
  Product product;

  EditPagePopup({required this.product});

  @override
  State<StatefulWidget> createState() => EditPagePopupState();
}

class EditPagePopupState extends State<EditPagePopup> {
  File? _image;
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _priceController = new TextEditingController();
  final TextEditingController _descController = new TextEditingController();

  Future getImage() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image as File?;
    });
  }

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.product.name;
    _priceController.text = widget.product.price.toString();
    _descController.text = widget.product.desc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        actions: <Widget>[
          TextButton(
            child: Text(
              "save",
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            onPressed: () async {
              // firestore save image
              if (_image != null) {
                await storage
                    .ref()
                    .child("images")
                    .child(widget.product.filename)
                    .delete(); // delete
                await uploadImage(_image!); // upload
                //print(path.basename(_image.path));
                widget.product.reference!.update(// with filename
                    {
                  'name': _nameController.text,
                  'price': int.parse(_priceController.text),
                  'desc': _descController.text,
                  'filename': path.basename(_image!.path),
                  'modified': FieldValue.serverTimestamp()
                }).then((value) => Navigator.pop(context));
              } else {
                widget.product.reference!.update(// without filename
                    {
                  'name': _nameController.text,
                  'price': int.parse(_priceController.text),
                  'desc': _descController.text,
                  'modified': FieldValue.serverTimestamp()
                }).then((value) => Navigator.pop(context));
              }
            },
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          //final product = widget.product;
          final NumberFormat formatter = NumberFormat.simpleCurrency(
              locale: Localizations.localeOf(context).toString());

          return ListView(
            children: <Widget>[
              Column(children: <Widget>[
                _image != null
                    ? Image.file(
                        _image!,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    : FutureBuilder(
                        future: getImageURL(widget.product.filename),
                        builder: (context, AsyncSnapshot<String> value) {
                          return Image.network(
                            value.hasData
                                ? value.data.toString()
                                : "http://handong.edu/site/handong/res/img/logo.png",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          );
                        }),
              ]),
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.photo_camera),
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
                              ),
                              //Text(formatter.format(product.price), style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Colors.blueAccent))),
                              SizedBox(
                                height: 12.0,
                              ),
                              TextField(
                                controller: _descController,
                                style: TextStyle(color: Colors.white),
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
