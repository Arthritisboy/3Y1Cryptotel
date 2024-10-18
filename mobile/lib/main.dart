import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/data_provider/auth/auth_data_provider.dart';
import 'package:hotel_flutter/data/data_provider/auth/booking_data_provider.dart';
import 'package:hotel_flutter/data/data_provider/auth/favorite_data_provider.dart';
import 'package:hotel_flutter/data/data_provider/auth/hotel_data_provider.dart';
import 'package:hotel_flutter/data/data_provider/auth/restaurant_data_provider.dart';
import 'package:hotel_flutter/data/repositories/booking_repository.dart';
import 'package:hotel_flutter/data/repositories/favorite_repository.dart';
import 'package:hotel_flutter/data/repositories/hotel_repository.dart';
import 'package:hotel_flutter/data/repositories/restaurant_repository.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_bloc.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_bloc.dart';
import 'package:hotel_flutter/presentation/screens/admin/admin_appScreen.dart';
import 'package:hotel_flutter/presentation/screens/admin/admin_userScreen.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/splash_screen.dart';
import 'package:hotel_flutter/router/app_router.dart';
import 'package:hotel_flutter/data/repositories/auth_repository.dart';
import 'package:logging/logging.dart';

void main() async {
  // Ensure the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set up logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {});

  // Initialize SharedPreferences
  final authRepository = AuthRepository(AuthDataProvider());
  await authRepository.initializeSharedPreferences();

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository; // Add AuthRepository as a parameter
  final BookingBloc bookingBloc;

  MyApp(
      {super.key, required this.authRepository}) // Accept it in the constructor
      : bookingBloc = BookingBloc(BookingRepository(BookingDataProvider()));

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository), // Provide it here
        RepositoryProvider(
            create: (context) => HotelRepository(HotelDataProvider())),
        RepositoryProvider(
            create: (context) =>
                RestaurantRepository(RestaurantDataProvider())),
        RepositoryProvider(
            create: (context) => BookingRepository(BookingDataProvider())),
        RepositoryProvider(
            create: (context) => FavoriteRepository(FavoriteDataProvider())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AuthBloc(RepositoryProvider.of<AuthRepository>(context))),
          BlocProvider(
              create: (context) =>
                  HotelBloc(RepositoryProvider.of<HotelRepository>(context))),
          BlocProvider(
              create: (context) => RestaurantBloc(
                  RepositoryProvider.of<RestaurantRepository>(context))),
          BlocProvider.value(value: bookingBloc),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cryptotel',
          onGenerateRoute: AppRouter(bookingBloc).onGenerateRoute,
          theme: _buildAppTheme(context),
          home: SplashScreen(),
        ),
      ),
    );
  }

  ThemeData _buildAppTheme(BuildContext context) {
    return ThemeData(
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.white,
      ),
      textTheme: _buildHelveticaTextTheme(),
    );
  }

  TextTheme _buildHelveticaTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
