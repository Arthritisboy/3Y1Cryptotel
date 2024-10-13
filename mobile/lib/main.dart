import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:hotel_flutter/presentation/admin/admin_screen.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/splash_screen.dart';
import 'package:hotel_flutter/router/app_router.dart';
import 'package:hotel_flutter/data/repositories/auth_repository.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BookingBloc bookingBloc = BookingBloc(
    BookingRepository(BookingDataProvider()),
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
            create: (context) => AuthRepository(AuthDataProvider())),
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
          home: const AdminScreen(),
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
      textTheme: GoogleFonts.hammersmithOneTextTheme(
        Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
      ),
    );
  }
}
