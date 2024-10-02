import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MainDrawer extends StatelessWidget {
  MainDrawer(
      {super.key,
      required this.onSelectScreen,
      required this.firstName,
      required this.lastName,
      required this.email});

  final void Function(String identifier) onSelectScreen;
  String firstName;
  String lastName;
  String email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(42, 67, 131, 255),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Image.asset('assets/images/icons/userwhite.png',
                        height: 60, width: 60),
                    const SizedBox(width: 18),
                    Text(
                      '$firstName $lastName',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      email,
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
            leading: Image.asset(
              'assets/images/icons/homewhite.png',
              height: 30,
              width: 30,
            ),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
            ),
            onTap: () => onSelectScreen('homescreen'),
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/icons/userwhite.png',
              height: 30,
              width: 30,
            ),
            title: Text(
              'Profile',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
            ),
            onTap: () => onSelectScreen('profile'),
          ),
          ListTile(
              leading: Image.asset(
                'assets/images/icons/history.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Transactions',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                    ),
              ),
              onTap: () => onSelectScreen('/cryptoTransaction')),
          ListTile(
            leading: Image.asset(
              'assets/images/icons/heart.png',
              height: 30,
              width: 30,
            ),
            title: Text(
              'Favorites',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
            ),
            onTap: () {
              onSelectScreen('profile');
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/icons/support.png',
              height: 30,
              width: 30,
            ),
            title: Text(
              'Help & Support',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
            ),
            onTap: () {
              onSelectScreen('profile');
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/icons/settings.png',
              height: 30,
              width: 30,
            ),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
            ),
            onTap: () {
              onSelectScreen('settings');
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/icons/logout.png',
              height: 30,
              width: 30,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontSize: 22,
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
