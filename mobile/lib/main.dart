import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/splash_screen.dart';
import 'package:hotel_flutter/router/app_router.dart';
//import 'package:hotel_flutter/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

// var kColorScheme =
//     ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 248, 248, 248));

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cryptotel',
      onGenerateRoute: _appRouter.onGenerateRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
