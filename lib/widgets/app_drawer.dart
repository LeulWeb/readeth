import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      enableCornerAnimation: true,
      leadingAppBar: SvgPicture.string(
        '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6h10M4 12h16M7 12h13M4 18h10"/></svg>',
        color: Colors.white,
      ),
      slidePercent: 30,
      backgroundColorMenu: Colors.black,
      backgroundMenu: DecorationImage(
        fit: BoxFit.cover,
        image: const AssetImage("assets/images/cover2.png"),
      ),
    );
  }
}
