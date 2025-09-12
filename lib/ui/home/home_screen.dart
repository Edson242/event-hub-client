import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/categories_data.dart';
import 'package:myapp/data/restaurant_data.dart';
import 'package:myapp/model/restaurant.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/widgets/app_bar.dart';
import 'package:myapp/ui/_core/widgets/bottom_menu.dart';
import 'package:myapp/ui/_core/widgets/drawer_menu.dart';
import 'package:myapp/ui/home/widgets/categories_widget.dart';
import 'package:myapp/ui/home/widgets/resturant_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RestaurantData restaurantData = Provider.of<RestaurantData>(context);
    final user = context.watch<User?>();
    final pageController = PageController();

    // Start timer outside of build
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (pageController.hasClients) {
        pageController.nextPage(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeIn,
        );
      }
    });

    return Scaffold(
      drawer: DrawerMenu(),
      appBar: getAppBar(context: context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 32.0,
            children: [
              Center(child: Image.asset("assets/logo.png", width: 147)),
              Text("Boas-Vindas, ${user?.displayName}!"),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "O que deseja comer?",
                  suffixStyle: TextStyle(color: AppColors.backgroundWhiteColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.backgroundWhiteColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.backgroundWhiteColor),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.backgroundWhiteColor),
                  ),
                ),
              ),
              SizedBox(
                height: 180.0,
                child: PageView.builder(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: null, // Set to null for infinite scrolling
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Image.asset("assets/banners/banner_promo.png"),
                    );
                  },
                ),
              ),
              Text("Escolha por categorias"),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8.0,
                  children: List.generate(
                    CategoriesData.listCategories.length,
                    (index) {
                      return CategoriesWidget(
                        category: CategoriesData.listCategories[index],
                      );
                    },
                  ),
                ),
              ),
              Text("Bem avaliados"),
              Column(
                spacing: 20.0,
                children: List.generate(restaurantData.listRestaurant.length, (
                  index,
                ) {
                  Restaurant restaurant = restaurantData.listRestaurant[index];
                  return ResturantWidget(restaurant: restaurant);
                }),
              ),
              SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(initialIndex: 0),
    );
  }
}