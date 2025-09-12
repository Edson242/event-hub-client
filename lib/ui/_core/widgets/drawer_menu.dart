import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/checkout/checkout_screen.dart';
import 'package:myapp/ui/home/home_screen.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/ui/splash/splash_screen.dart';
// import 'package:myapp/ui/userPage/user_page_screen.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Image.asset("assets/logo.png", width: 147),
                ),
              ),
              ListTile(
                title: Row(
                  spacing: 8.0,
                  children: [Icon(Icons.home), Text("Menu")],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomeScreen();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                title: Row(
                  spacing: 8.0,
                  children: [Icon(Icons.shopping_basket), Text("Sacola")],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CheckoutScreen();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                title: Row(
                  spacing: 8.0,
                  children: [Icon(Icons.person), Text("Minha Conta")],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SplashScreen();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                hoverColor: AppColors.backgroundWhiteColor,
                selectedColor: AppColors.backgroundWhiteColor,
                title: Row(
                  spacing: 8.0,
                  children: [Icon(Icons.exit_to_app), Text("Sair")],
                ),
                onTap: () {
                  AuthService().logoutUser();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
