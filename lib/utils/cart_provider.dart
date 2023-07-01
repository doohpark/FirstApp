import 'package:flutter/material.dart';
import 'package:shrine/model/cart_model.dart';

class CartProvider with ChangeNotifier {
  List<Carts> wishlist = [];
  bool isContained = false;

  check(String currentUuid) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      for(var i=0; i<wishlist.length; i++){
        if(wishlist[i].uuid == currentUuid){
          isContained = true;
        }
        else{
          isContained = false;
        }
      }
      notifyListeners();
    });
  }

  add(String imageUrl, String name, String uuid) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      wishlist.add(Carts(imageUrl: imageUrl, name: name, uuid: uuid));
      notifyListeners();
    });
  }

  del(int index) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      wishlist.removeAt(index);
      notifyListeners();
    });
  }
}
