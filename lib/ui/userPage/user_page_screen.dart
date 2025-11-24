import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/widgets/app_bar.dart';
import 'package:myapp/ui/_core/widgets/bottom_menu.dart';
import 'package:myapp/ui/_core/widgets/drawer_menu.dart';

class UserpageScreen extends StatelessWidget {
  const UserpageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: getAppBar(context: context, title: 'Minha Conta'),
      body: Center(child: Text('This is the User Page')),
      bottomNavigationBar: const BottomMenu(initialIndex: 1),
    );
  }
}
