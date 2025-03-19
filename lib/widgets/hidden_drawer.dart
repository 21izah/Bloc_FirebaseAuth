import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:izahs/features/auth/presentation/pages/homeScreen01.dart';

import '../main.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.blue,
            name: 'Home',
            baseStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
            selectedStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        HomeScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          colorLineSelected: Colors.green,
          name: 'Service',
          baseStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          selectedStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        HomeScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.blue,
            name: 'Gallery',
            baseStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            selectedStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        HomeScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.blue,
            name: 'Contact',
            baseStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
            selectedStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        HomeScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            colorLineSelected: Colors.blue,
            name: 'English',
            baseStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
            selectedStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        HomeScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            onTap: () => null,

            // FirebaseAuth.instance.signOut().then(
            //       (value) => Navigator.of(context).pushAndRemoveUntil(
            //           MaterialPageRoute(
            //             builder: (context) => const LogInPage(),
            //           ),
            //           (route) => false),
            //     ),
            colorLineSelected: Colors.blue,
            name: 'Log out',
            baseStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
            selectedStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        HomeScreen(),
      ),
    ];
  }

  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      slidePercent: 90,
      backgroundColorMenu: Colors.black,
      screens: _pages,
      initPositionSelected: 0,
      backgroundColorAppBar: Colors.blue,
      backgroundColorContent: Colors.blue,
    );
  }
}
