import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/widgets/app_bar.dart';
import 'package:myapp/ui/_core/widgets/bottom_menu.dart';
import 'package:myapp/ui/_core/widgets/drawer_menu.dart';
import 'package:provider/provider.dart';

class UserpageScreen extends StatelessWidget {
  const UserpageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: getAppBar(context: context, title: '${user?.displayName}'),
      body: Center(child: Text('This is the User Page')),
      bottomNavigationBar: BottomMenu(initialIndex: 3),
    );
  }
}
