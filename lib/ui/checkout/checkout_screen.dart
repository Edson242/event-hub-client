import 'package:flutter/material.dart';
import 'package:myapp/model/dish.dart';
import 'package:myapp/ui/_core/bag_provider.dart';
import 'package:myapp/ui/_core/widgets/bottom_menu.dart';
import 'package:myapp/ui/home/home_screen.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BagProvider bagProvider = Provider.of<BagProvider>(context);
    if (bagProvider.dishesOnBag.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Sacola'),
          actions: [
            TextButton(
              onPressed: () {
                bagProvider.clearBag();
              },
              child: Text("Limpar"),
            ),
          ],
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 18.0,
            children: [
              Text(
                "Sua sacola está vazia!",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text("Home"),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Sacola'),
          actions: [
            TextButton(
              onPressed: () {
                bagProvider.clearBag();
              },
              child: Text("Limpar"),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Pedidos", textAlign: TextAlign.center),
                Column(
                  children: List.generate(
                    bagProvider.getMapByAmount().keys.length,
                    (index) {
                      Dish dish =
                          bagProvider.getMapByAmount().keys.toList()[index];
                      return ListTile(
                        onTap: () {},
                        leading: Image.asset(
                          "assets/dishes/default.png",
                          width: 48.0,
                          height: 48.0,
                        ),
                        title: Text(dish.name),
                        subtitle: Text("R\$${dish.price.toString()}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                bagProvider.removeDishFromBag(dish);
                              },
                              icon: Icon(Icons.remove),
                            ),
                            Text(
                              bagProvider.getMapByAmount()[dish].toString(),
                              style: TextStyle(fontSize: 18.0),
                            ),
                            IconButton(
                              onPressed: () {
                                bagProvider.addAllDishToBag([dish]);
                              },
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomMenu(initialIndex: 2),
      );
    }
  }
}
