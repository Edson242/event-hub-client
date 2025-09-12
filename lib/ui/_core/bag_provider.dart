import 'package:flutter/material.dart';
import 'package:myapp/model/dish.dart';

class BagProvider extends ChangeNotifier {
  List<Dish> dishesOnBag = [];

  void addAllDishToBag(List<Dish> dishes) {
    dishesOnBag.addAll(dishes);
    notifyListeners();
  }

  void addDishToBag(Dish dish) {
    dishesOnBag.add(dish);
    notifyListeners();
  }

  void removeDishFromBag(Dish dish) {
    dishesOnBag.remove(dish);
    notifyListeners();
  }

  void clearBag() {
    dishesOnBag.clear();
    notifyListeners();
  }

  Map<Dish, int> getMapByAmount() {
    Map<Dish, int> mapResult = {};
    for (Dish dish in dishesOnBag) {
      if (mapResult[dish] == null) {
        mapResult[dish] = 1;
      } else {
        mapResult[dish] = mapResult[dish]! + 1;
      }
    }
    return mapResult;
  }
}
