import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({
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
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 320, // Increase height here
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
                            radius: 60, // Increase the size of profile picture
                            backgroundImage: NetworkImage(profile),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors
                                .transparent, // Make sure background is transparent
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white, // White background
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.person,
                                size: 80,
                                color: Color.fromARGB(255, 67, 131,
                                    255), // Semi-transparent blue color
                              ),
                            ),
                          ),
                    const SizedBox(height: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$firstName $lastName',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                          overflow: TextOverflow.ellipsis, // Handle overflow
                        ),
                        Text(
                          email,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                          overflow: TextOverflow.ellipsis, // Handle overflow
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
              onTap: () => onSelectScreen('/cryptoTransaction'),
            ),
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
                onSelectScreen('favorite');
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
                onSelectScreen('help');
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
      ),
    );
  }
}
