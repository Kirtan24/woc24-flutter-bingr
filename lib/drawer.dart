import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomeDrawer extends StatefulWidget {
  const CustomeDrawer({Key? key}) : super(key: key);

  @override
  State<CustomeDrawer> createState() => _CustomeDrawerState();
}

class _CustomeDrawerState extends State<CustomeDrawer> {
  final user = FirebaseAuth.instance.currentUser;

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
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.monitor),
            title: const Text("TV Shows"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.heart),
            title: const Text("Favorites"),
            onTap: () {
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
