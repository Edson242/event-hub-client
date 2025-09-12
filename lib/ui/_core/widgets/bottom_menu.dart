import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/checkout/checkout_screen.dart';
import 'package:myapp/ui/home/home_screen.dart';
import 'package:myapp/ui/userPage/user_page_screen.dart';

class BottomMenu extends StatefulWidget {
  final int initialIndex;

  const BottomMenu({super.key, this.initialIndex = 0});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void onItemTapped(int index) {
    if (selectedIndex == index) return;

    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CheckoutScreen(),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserpageScreen(),
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildIcon(Icons.home, 0),
            buildIcon(Icons.search, 1),
            buildIcon(Icons.shopping_basket, 2),
            buildIcon(Icons.person, 3),
          ],
        ),
      ),
    );
  }

  Widget buildIcon(IconData icon, int index) {
    return IconButton(
      onPressed: () => onItemTapped(index),
      icon: Icon(
        icon,
        color: selectedIndex == index ? AppColors.backgroundWhiteColor : Colors.grey,
      ),
    );
  }
}

