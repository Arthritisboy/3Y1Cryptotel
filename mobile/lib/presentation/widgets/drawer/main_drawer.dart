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
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            child: CachedNetworkImage(
                              imageUrl: profile,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundColor:
                                const Color.fromARGB(255, 173, 175, 210),
                            child: const Icon(
                              Icons.person,
                              size: 80,
                              color: Color.fromARGB(255, 29, 53, 115),
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
                'Payment',
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
                'assets/images/icons/history.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'History',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                    ),
              ),
              onTap: () {
                onSelectScreen('history');
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
