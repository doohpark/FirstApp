import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/model/cart_model.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/utils/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Wish List'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Consumer<CartProvider>(
          builder: (context, value, child) => value.wishlist.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: value.wishlist.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.all(10),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      leading: Image.network(value.wishlist[index].imageUrl),
                      title: Text(value.wishlist[index].name),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.blueGrey,
                        onPressed: () {
                          value.del(index);
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                  'Empty',
                  style: TextStyle(color: Colors.white),
                )),
        ),
      ),
    );
  }
}
