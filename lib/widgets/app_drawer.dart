import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:readeth/pages/about_us_page.dart';
import 'package:readeth/pages/add_book_page.dart';
import 'package:readeth/pages/home_page.dart';

// ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  List<ScreenHiddenDrawer> pages = [
    ScreenHiddenDrawer(
      ItemHiddenMenu(
        name: "ReadEth",
        baseStyle: const TextStyle(),
        selectedStyle: const TextStyle(),
      ),
      HomePage(),
    ),
    ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Add Book",
          baseStyle: const TextStyle(),
          selectedStyle: const TextStyle(),
        ),
        const AddBookPage()),
    ScreenHiddenDrawer(
      ItemHiddenMenu(
        name: "About Us",
        baseStyle: const TextStyle(),
        selectedStyle: const TextStyle(),
      ),
      AboutUsPage(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      screens: pages,
      backgroundColorAppBar: Colors.black,
      isTitleCentered: true,
      backgroundColorMenu: Colors.black,
      backgroundMenu: DecorationImage(
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black54,
          BlendMode.srcOver,
        ),
        image: const AssetImage("assets/images/cover.jpg"),
      ),
    );
  }
}
