import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/data_provider/auth/auth_data_provider.dart';
import 'package:hotel_flutter/logic/bloc/auth_bloc.dart';
import 'package:hotel_flutter/presentation/screens/splash_screen.dart';
import 'package:hotel_flutter/presentation/screens/tab_screen.dart';
import 'package:hotel_flutter/router/app_router.dart';
import 'package:hotel_flutter/data/respositories/auth_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create an instance of AuthDataProvider
    final AuthDataProvider authDataProvider = AuthDataProvider();
    // Create an instance of AuthRepository
    final AuthRepository authRepository = AuthRepository(authDataProvider);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthBloc(AuthRepository(AuthDataProvider()))),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cryptotel',
        onGenerateRoute: _appRouter.onGenerateRoute,
        theme: ThemeData(
          primaryColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          useMaterial3: true,
          listTileTheme: const ListTileThemeData(
            textColor: Colors.white,
            iconColor: Colors.white,
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Color.fromARGB(255, 29, 53, 115),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
          ),
          textTheme: GoogleFonts.hammersmithOneTextTheme(
            Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.black, displayColor: Colors.black),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
