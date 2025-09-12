import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/banners/banner_logo.png', height: 60),
                Text(
                  'Single Thred',
                  style: TextStyle(color: AppColors.lightBackgroundColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
