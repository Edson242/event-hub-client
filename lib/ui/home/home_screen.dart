import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/widgets/app_bar.dart';
import 'package:myapp/ui/_core/widgets/bottom_menu.dart';
import 'package:myapp/ui/_core/widgets/drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final pageController = PageController();

    // Start timer outside of build
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn,
        );
      }
    });

    return Scaffold(
      drawer: DrawerMenu(),
      appBar: getAppBar(context: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset("assets/logo.png", width: 147)),
              const SizedBox(height: 32.0),
              const Text("Boas-Vindas!"),
              const SizedBox(height: 32.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "O que deseja para hoje?",
                  suffixStyle: const TextStyle(color: AppColors.backgroundWhiteColor),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.backgroundWhiteColor),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.backgroundWhiteColor),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.backgroundWhiteColor),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
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
              const SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomMenu(initialIndex: 0),
    );
  }
}