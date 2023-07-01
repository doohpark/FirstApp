// import 'package:flutter/material.dart';
// import 'model/product.dart';
// import 'model/products_repository.dart';
//
// class FavoritePage extends StatefulWidget {
//   const FavoritePage({Key? key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => FavoritePageState();
// }
//
// class FavoritePageState extends State<FavoritePage> {
//   final items = favoriteList.toList();
//
//   @override
//   Widget build(BuildContext context) {
//     final Iterable<Dismissible> tiles = favoriteList.map((Product product) {
//       return Dismissible(
//         key: Key(product.name),
//         onDismissed: (direction) {
//           setState(() {
//             items.remove(product);
//           });
//           favoriteList.remove(product);
//         },
//         background: Container(color: Colors.red),
//         child: ListTile(
//           title: Text(
//             product.name,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       );
//     });
//
//     final List<Widget> divided = ListTile.divideTiles(
//       context: context,
//       tiles: tiles,
//     ).toList();
//
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           centerTitle: true,
//           title: const Text('Favorite Hotels'),
//         ),
//         body: ListView(children: divided));
//   }
// }
