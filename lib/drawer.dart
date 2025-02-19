import 'package:bingr/common/widgets/view_more.dart';
import 'package:bingr/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bingr/layout.dart'; // Import layout to access NavigationController

class CustomeDrawer extends StatefulWidget {
  const CustomeDrawer({Key? key}) : super(key: key);

  @override
  State<CustomeDrawer> createState() => _CustomeDrawerState();
}

class _CustomeDrawerState extends State<CustomeDrawer> {
  final user = FirebaseAuth.instance.currentUser;
  final NavigationController controller = Get.find<NavigationController>();
  final MovieService movieService = MovieService();

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 245, 71, 32),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.grey),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? "User",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${user!.email}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Iconsax.video_horizontal),
            title: const Text("Movies"),
            onTap: () async {
              List<dynamic> movies1 = await movieService.fetchResponse(
                  '/movie/popular?language=en-US&page=1&region=IN');
              List<dynamic> movies2 = await movieService.fetchResponse(
                  '/movie/popular?language=en-US&page=2&region=IN');

              List<dynamic> movies = movies1 + movies2;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewMore(
                    title: "Popular Movies",
                    items: movies,
                    type: "movie",
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.monitor),
            title: const Text("TV Shows"),
            onTap: () async {
              List<dynamic> tv1 = await movieService
                  .fetchResponse('/tv/popular?language=en-US&page=1');
              List<dynamic> tv2 = await movieService
                  .fetchResponse('/tv/popular?language=en-US&page=2');

              List<dynamic> tv = tv1 + tv2;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewMore(
                    title: "Popular Movies",
                    items: tv,
                    type: "tv",
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.heart),
            title: const Text("Favorites"),
            onTap: () {
              controller.selectedIndex.value = 2; // Set to Favorites
              Navigator.pop(context); // Close the drawer
            },
          ),
          const Spacer(),
          SafeArea(
            child: ListTile(
              leading: const Icon(
                Iconsax.logout,
                color: Color.fromARGB(255, 245, 71, 32),
              ),
              title: const Text(
                "Logout",
                style: TextStyle(color: Color.fromARGB(255, 245, 71, 32)),
              ),
              onTap: () {
                signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
