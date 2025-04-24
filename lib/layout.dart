import 'package:bingr/drawer.dart';
import 'package:bingr/screens/home/home.dart';
import 'package:bingr/screens/search/search.dart';
import 'package:bingr/screens/favorite/favorites.dart';
import 'package:bingr/util/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class Layout extends StatelessWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      drawer: CustomeDrawer(),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 60,
          backgroundColor:
              BHelperFunction.isDarkMode(context) ? Colors.black : Colors.white,
          indicatorColor: Colors.red.withOpacity(0.3), // Highlight effect color
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) {
            if (index == 1 && controller.selectedIndex.value == 1) {
              controller.focusSearchField();
            } else {
              controller.selectedIndex.value = index;
            }
          },
          destinations: [
            NavigationDestination(
              icon: Icon(
                Iconsax.home,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Iconsax.search_normal,
              ),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(
                Iconsax.add,
              ),
              label: 'My List',
            ),
          ],
        ),
      ),
      body: Obx(
        () {
          return SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    pinned: false,
                    centerTitle: true,
                    // title: const Text(
                    //   "Bingr_",
                    //   style: TextStyle(
                    //     color: Color.fromARGB(255, 245, 71, 32),
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    title: Image.asset(
                      'assets/logos/branding-image.png',
                      width: 150,
                    ),
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: const Icon(
                        Iconsax.menu_1,
                        color: Color.fromARGB(255, 245, 71, 32),
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ];
              },
              body: controller.screens[controller.selectedIndex.value],
            ),
          );
        },
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final FocusNode searchPageFocusNode = FocusNode();

  late final screens = [
    Home(),
    Search(focusNode: searchPageFocusNode),
    Favorites(),
  ];

  void focusSearchField() {
    searchPageFocusNode.requestFocus();
  }

  @override
  void onClose() {
    searchPageFocusNode.dispose();
    super.onClose();
  }
}
