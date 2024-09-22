import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 29, 53, 115),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 18),
                    Text(
                      'Lance Kian Flores',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      'lancekian12@gmail.com',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              size: 26,
              color: Colors.white,
            ),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
            ),
            onTap: () {
              onSelectScreen('homescreen');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              size: 26,
              color: Colors.white,
            ),
            title: Text(
              'Profile',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
            ),
            onTap: () {
              onSelectScreen('profile');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              size: 26,
              color: Colors.white,
            ),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
            ),
            onTap: () {
              onSelectScreen('settings');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 26,
              color: Colors.white,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
            ),
            onTap: () {
              onSelectScreen('logout');
            },
          ),
        ],
      ),
    );
  }
}
