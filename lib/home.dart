import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shrine/cart.dart';
import 'package:shrine/supplemental/detail.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shrine/utils/appData.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/product.dart';
import 'model/products_repository.dart';

class SortMenuWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SortMenuWidgetState();
}

class SortMenuWidgetState extends State<SortMenuWidget> {
  String dropdownValue = 'ASC';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        value: dropdownValue,
        dropdownColor: Colors.black,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 2,
        ),
        onChanged: (newValue) {
          setState(() {
            dropdownValue = newValue!;
            isDescending = newValue == 'DESC';
            print(isDescending);
            context.findAncestorStateOfType<_HomePageState>()?.rebuild();
          });
          // query and sorting
        },
        items: <String>['ASC', 'DESC']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSelected = true;

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> list;

    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey,
          title: const Text('Thug Club'),
          leading: IconButton(
            icon: Icon(
              Icons.person,
              semanticLabel: 'profile',
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                semanticLabel: 'cart',
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (MaterialAppContext) => CartPage())
                // );

              },
            ),
            IconButton(
                icon: const Icon(
                  Icons.add,
                  semanticLabel: 'add',
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/add');
                }),
          ],
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 8.0,
            ),
            SortMenuWidget(),
            SizedBox(
              height: 8.0,
            ),
            Container(child: _buildBody(context)),
          ],
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    List<DocumentSnapshot> list;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('product').snapshots(),
      builder: (context, snapshot) {
        //print(snapshot);
        if (!snapshot.hasData) return LinearProgressIndicator();
        list = snapshot.data!.docs;
        list.sort((a, b) {
          if (isDescending)
            return b['price'].compareTo(a['price']);
          else
            return a['price'].compareTo(b['price']);
        });
        return _buildGrid(context, list);
      },
    );
  }

  Widget _buildGrid(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      childAspectRatio: 8.0 / 9.0,
      children: snapshot.map((data) => _buildCard(context, data)).toList(),
    );
  }

  Widget _buildCard(BuildContext context, DocumentSnapshot data) {
    final Product product = Product.fromSnapshot(data);
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: FutureBuilder(
                  future: getImageURL(data['filename']),
                  builder: (context, AsyncSnapshot<String> value) {
                    if (!value.hasData) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return Image.network(
                      value.data.toString(),
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    );
                  }),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      formatter.format(product.price),
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            height: 30,
            width: 70,
            child: TextButton(
              child: Text(
                'more',
                style: TextStyle(fontSize: 14, color: theme.primaryColor),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/detail',
                    arguments: ProductArguments(product));
              },
            ),
          ),
        ),
      ]),
    );
  }

// List<Card> _buildGridCards(BuildContext context, DocumentSnapshot data) {
//   final Product product = Product.fromSnapshot(data);
//
//   if (products.isEmpty) {
//     return const <Card>[];
//   }
//
//   final ThemeData theme = Theme.of(context);
//
//   return products.map((product) {
//     return Card(
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           AspectRatio(
//             aspectRatio: 18 / 11,
//             child: FutureBuilder(
//                 future: getImageURL(data['filename']),
//                 builder: (context, AsyncSnapshot<String> value) {
//                   return Image.network(
//                     value!.data,
//                     width: MediaQuery.of(context).size.width,
//                     fit: BoxFit.cover,
//                   );
//                 }
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         product.name,
//                         style: const TextStyle(
//                             fontSize: 12, fontWeight: FontWeight.bold),
//                         maxLines: 1,
//                       ),
//                       Text(
//                         product.desc,
//                         style: theme.textTheme.bodySmall,
//                         maxLines: 2,
//                       ),
//                       Row(
//                         children: [
//                           const SizedBox(
//                             width: 110,
//                           ),
//                           InkWell(
//                             child: const Text(
//                               'more',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                             onTap: () {
//                               Navigator.pushNamed(context, '/detail',
//                                   arguments: ProductArguments(
//                                       product, favoriteList));
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }).toList();
// }
}
