import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.onSelectScreen,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profile,
  });

  final void Function(String identifier) onSelectScreen;
  final String firstName;
  final String lastName;
  final String email;
  final String profile;

  @override
  Widget build(BuildContext context) {
    //test
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 320, // Drawer header height
              child: DrawerHeader(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(42, 67, 131, 255),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    profile.isNotEmpty
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                CachedNetworkImageProvider(profile),
                          )
                        : const Icon(
                            Icons.person,
                            size: 80,
                            color: Color.fromARGB(255, 29, 53, 115),
                          ),
                    const SizedBox(height: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$firstName $lastName',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis, // Handle overflow
                        ),
                        Text(
                          email,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis, // Handle overflow
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _buildListTile(
              context,
              'Profile',
              'assets/images/icons/userwhite.png',
              30,
              'profile',
            ),
            _buildListTile(
              context,
              'Transactions',
              'assets/images/icons/history.png',
              30,
              '/cryptoTransaction',
            ),
            _buildListTile(
              context,
              'Favorites',
              'assets/images/icons/heart.png',
              30,
              'favorite',
            ),
            _buildListTile(
              context,
              'Help & Support',
              'assets/images/icons/support.png',
              30,
              'help',
            ),
            _buildListTile(
              context,
              'Settings',
              'assets/images/icons/settings.png',
              30,
              'settings',
            ),
            _buildListTile(
              context,
              'Logout',
              'assets/images/icons/logout.png',
              30,
              'logout',
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, String title, String iconPath,
      double size, String identifier) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        height: size,
        width: size,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.white,
              fontSize: 22,
            ),
      ),
      onTap: () => onSelectScreen(identifier),
    );
  }
}
